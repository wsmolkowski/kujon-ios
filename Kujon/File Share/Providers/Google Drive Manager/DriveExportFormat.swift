//
//  DriveExportFormat.swift
//  Kujon
//
//  Created by Adam on 25.12.2016.
//  Copyright © 2016 Mobi. All rights reserved.
//

import Foundation
import GoogleAPIClientForREST

struct DriveExportFormat {

    let mimeType: MIMEType
    let fileExtension: String

    static func mapFormat(for file: GTLRDrive_File) throws -> DriveExportFormat {
        guard let mimeType = file.mimeType else {
            throw DriveManagerError.cannotMapExportFormat
        }

        switch mimeType {
        case MIMEType.googleDocument.rawValue:
            return DriveExportFormat(mimeType: .msWord, fileExtension: "docx")
        case MIMEType.googlePresentation.rawValue:
            return DriveExportFormat(mimeType: .msPowerPoint, fileExtension: "pptx")
        case MIMEType.googleSpreadsheet.rawValue:
            return DriveExportFormat(mimeType: .msExcel, fileExtension: "xlsx")
        case MIMEType.googlePhoto.rawValue:
            return DriveExportFormat(mimeType: .imageJPG, fileExtension: "jpg")
        case MIMEType.googleDrawing.rawValue:
            return DriveExportFormat(mimeType: .imagePNG, fileExtension: "png")
        default:
            throw DriveManagerError.cannotMapExportFormat
        }
    }
    
}
