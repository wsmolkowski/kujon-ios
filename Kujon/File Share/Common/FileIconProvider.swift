//
//  FileIconProvider.swift
//  Kujon
//
//  Created by Adam on 18.01.2017.
//  Copyright © 2017 Mobi. All rights reserved.
//

import Foundation


class FileIconProvider {


    static func iconForMIMEType(_ mimeType: MIMEType) -> UIImage {

        switch mimeType {
        case .googleFolder:
            return #imageLiteral(resourceName: "folder-icon")
        case .googleSpreadsheet, .msExcel:
            return #imageLiteral(resourceName: "xls-icon")
        case .googlePresentation, .msPowerPoint:
            return #imageLiteral(resourceName: "preso-icon")
        case .googleDocument, .msWord:
            return #imageLiteral(resourceName: "doc-icon")
        case .imagePNG:
            return #imageLiteral(resourceName: "png-icon")
        case .imageJPG, .googlePhoto, .googleDrawing:
            return #imageLiteral(resourceName: "jpg-icon")
        case .googleAudio, .audioMP3, .audioMPEG:
            return #imageLiteral(resourceName: "mp3-icon")
        case .documentPDF:
            return #imageLiteral(resourceName: "pdf-icon")
        case .videoAVI:
            return #imageLiteral(resourceName: "avi-icon")
        case .videoMOV, .videoMP4, .videoWMV, .video3GP:
            return #imageLiteral(resourceName: "mov-icon")
        default:
            return #imageLiteral(resourceName: "unknown-icon")
        }
    }

    static func iconForMIMETypeString(_ mimeTypeString: String) -> UIImage {
        if let mimeType = MIMEType(rawValue: mimeTypeString) {
            return  FileIconProvider.iconForMIMEType(mimeType)
        }
        return #imageLiteral(resourceName: "unknown-icon")
    }


}
