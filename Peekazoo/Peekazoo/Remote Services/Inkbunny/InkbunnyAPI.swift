//
//  InkbunnyAPI.swift
//  Peekazoo
//
//  Created by Thomas Sherwood on 20/05/2017.
//  Copyright © 2017 Peekazoo. All rights reserved.
//

import Foundation

public enum InkbunnyHomepageLoadResult {
    case success([InkbunnySubmission])
    case failure
}

public struct InkbunnyAPI: InkbunnyAPIProtocol {

    private var networkAdapter: NetworkAdapter
    private var submissionDateTimeFormatter: DateFormatter

    public init(networkAdapter: NetworkAdapter) {
        self.networkAdapter = networkAdapter
        submissionDateTimeFormatter = DateFormatter()
        submissionDateTimeFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSSZZZZ"
    }

    public func loadHomepage(completionHandler: @escaping (InkbunnyHomepageLoadResult) -> Void) {
        networkAdapter.get(makeGuestLoginURL()) { data, _ in
            guard let data = data,
                let json = self.jsonObject(from: data) as? [String : Any],
                let sid = json["sid"] as? String else {
                    completionHandler(.failure)
                    return
            }

            self.networkAdapter.get(self.makeSearchURL(sid: sid)) { data, _ in
                guard let data = data,
                      let json = self.jsonObject(from: data) as? [String : Any],
                      let submissions = json["submissions"] as? [[String : Any]] else {
                    completionHandler(.failure)
                    return
                }

                completionHandler(.success(submissions.flatMap(self.parseSubmission)))
            }
        }
    }

    private func makeGuestLoginURL() -> URL {
        return URL(string: "https://inkbunny.net/api_login.php?username=guest&password=")!
    }

    private func makeSearchURL(sid: String) -> URL {
        return URL(string: "https://inkbunny.net/api_search.php?sid=\(sid)")!
    }

    private func jsonObject(from data: Data) -> Any? {
        return try? JSONSerialization.jsonObject(with: data, options: .allowFragments)
    }

    private func parseSubmission(_ json: [String : Any]) -> InkbunnySubmissionImpl? {
        guard let submissionID = json["submission_id"] as? String,
              let title = json["title"] as? String,
              let dateString = json["create_datetime"] as? String,
              let postedDate = submissionDateTimeFormatter.date(from: dateString) else { return nil }

        return InkbunnySubmissionImpl(submissionID: submissionID,
                                  title: title,
                                  postedDate: postedDate)
    }

}
