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

        case .googleSpreadsheet,
             .msExcel,
             .msExcel_old1,
             .msExcel_old2,
             .msExcel_old3,
             .msExcel_old4:
            return #imageLiteral(resourceName: "xls-icon")

        case .googlePresentation,
             .msPowerPoint,
             .msPowerPoint_old1,
             .msPowerPoint_old2,
             .msPowerPoint_old3,
             .msPowerPoint_old4:
            return #imageLiteral(resourceName: "preso-icon")

        case .googleDocument,
             .msWord,
             .msWord_old:
            return #imageLiteral(resourceName: "doc-icon")

        case .imagePNG,
             .imageJPG,
             .googlePhoto,
             .googleDrawing:
            return #imageLiteral(resourceName: "jpg-icon")

        case .googleAudio,
             .audioMP3,
             .audioMP3_alt1,
             .audioMP3_alt2,
             .audioMP3_alt3,
             .audioMP4,
             .audioMPEG,
             .audioMPEG_alt,
             .audioM4A,
             .audioM4B,
             .audioM4P,
             .audioWAV,
             .audioWAV_alt,
             .audioOGG,
             .audioWEBM,
             .audio3GP,
             .audio3GP2,
             .audiAIFF,
             .audiAIFF_alt,
             .audioAMR:
            return #imageLiteral(resourceName: "mp3-icon")

        case .documentPDF:
            return #imageLiteral(resourceName: "pdf-icon")

        case .videoMOV,
             .videoMP4,
             .videoWMV,
             .video3GP,
             .videoAVI,
             .videoM4V,
             .video3GP2:
            return #imageLiteral(resourceName: "mov-icon")

        case .zip,
             .zip_alt_1,
             .zip_alt_2:
            return #imageLiteral(resourceName: "unknown-icon")

        case .text:
            return #imageLiteral(resourceName: "unknown-icon")

        case .html:
            return #imageLiteral(resourceName: "unknown-icon")

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
