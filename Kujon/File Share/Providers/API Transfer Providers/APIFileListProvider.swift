//
//  APIFileListProvider.swift
//  Kujon
//
//  Created by Adam on 23.12.2016.
//  Copyright © 2016 Mobi. All rights reserved.
//

import Foundation


protocol APIFileListProviderDelegate: ErrorResponseProtocol {
    func apliFileListProvider( _ provider: APIFileListProvider?, didLoadFileList files: [APIFile])

}

protocol APIFileListProviderProtocol: JsonProviderProtocol {
    associatedtype T = APIFileListResponse
}

class APIFileListProvider: RestApiManager, APIFileListProviderProtocol {

    internal var isFetching: Bool = false
    internal weak var delegate: APIFileListProviderDelegate?
    private var endpoint = String()


    private struct APIFileListEndpoint {
        static func allSharedFiles() -> String {
            return  String(format: "%@/files", RestApiManager.BASE_URL)
        }
        static func filesAssignedToCourseId(_ courseId: String, termId: String) -> String {
            return String(format: "%@/files?course_id=%@&term_id=%@", RestApiManager.BASE_URL, courseId, termId)
        }
    }

    internal func loadFileList(courseId: String? = nil, termId: String? = nil) {

        if let courseId = courseId, let termId = termId {
            endpoint = APIFileListEndpoint.filesAssignedToCourseId(courseId, termId: termId)
        } else {
            endpoint = APIFileListEndpoint.allSharedFiles()
        }

        isFetching = true
        UIApplication.shared.isNetworkActivityIndicatorVisible = true

        makeHTTPAuthenticatedGetRequest({ [weak self] data in

            self?.isFetching = false
            UIApplication.shared.isNetworkActivityIndicatorVisible = false

            guard let data = data else {
                self?.delegate?.onErrorOccurs(StringHolder.errorOccures)
                return
            }

            if let delegate = self?.delegate,
                let fileListResponse = try! self?.changeJsonToResposne(data, errorR: delegate) {
                let files = fileListResponse.files
                self?.delegate?.apliFileListProvider(self, didLoadFileList: files)
            }

            }, onError: {[weak self] text in
                self?.delegate?.onErrorOccurs(text)
        })

    }

    internal override func reload() {
        var request = URLRequest(url: URL(string: getMyUrl())!)
        self.headerManager.addHeadersToRequest(&request)
        SessionManager.clearCacheForRequest(request as URLRequest)
        addStoredCookies = false
        refresh = false
    }

    internal override func getMyUrl() -> String {
        return endpoint
    }

}
