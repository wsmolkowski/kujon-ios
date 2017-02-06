//
//  MultipartProviding
//  Kujon
//
//  Created by Adam on 09.01.2017.
//  Copyright © 2017 Mobi. All rights reserved.
//

import Foundation



protocol MultipartProviding: class {

    func setupMultipartContentTypeInRequest( _ request: inout URLRequest)

    func createMultipartFormData(parameters: [String: Any], fileName: String?, contentType: String?, fileData: Data?) -> Data

}


extension MultipartProviding {

    func setupMultipartContentTypeInRequest( _ request: inout URLRequest) {
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
    }

    func createMultipartFormData(parameters: [String: Any], fileName: String? = nil, contentType: String? = nil, fileData: Data? = nil) -> Data {

        var body = Data()

        let parametersDataSection = createParametersDataSection(from: parameters)
        body.append(parametersDataSection)


        if let fileName = fileName, let contentType = contentType, let fileData = fileData {
            let fileDataSection = createFileDataSection(fileName: fileName, contentType: contentType, fileData: fileData)
            body.append(fileDataSection)
        }

        body.append(string: "--\(boundary)--" + eol)
        return body
    }

    private func createParametersDataSection(from parameters: [String: Any]) -> Data {
        var data = Data()
        for (key, value) in parameters {
            data.append(string: "--\(boundary)" + eol)
            data.append(string: "Content-Disposition: form-data; name=\"\(key)\"" + eol + eol)
            data.append(string: "\(value)" + eol)
        }
        return data
    }

    private func createFileDataSection(fileName: String, contentType: String, fileData: Data) -> Data {
        var data = Data()
        data.append(string: "--\(boundary)" + eol)
        data.append(string: "Content-Disposition: form-data; name=\"files\"; filename=\"\(fileName)\"" + eol)
        data.append(string: "Content-Type: \(contentType)" + eol + eol)
        data.append(fileData)
        data.append(string: eol)
        return data
    }

    private var boundary: String {
        return "Boundary-KujoniOSApp-8232343678423491230621"
    }

    private var eol: String {
        return "\r\n"
    }

}
