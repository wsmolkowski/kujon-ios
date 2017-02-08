//
//  FileTypeDescriptionProvider.swift
//  Kujon
//
//  Created by Adam on 08.02.2017.
//  Copyright © 2017 Mobi. All rights reserved.
//

import Foundation

class FileTypeDescriptionProvider {


    static func descriptionForMIMEType(_ mimeType: MIMEType) -> String {

        switch mimeType {
        case .googleFolder:
            return "Folder plików"
        case .googleSpreadsheet, .msExcel:
            return "Arkusz kalkulacyjny"
        case .googlePresentation, .msPowerPoint:
            return "Prezentacja"
        case .googleDocument, .msWord:
            return "Dokument tekstowy"
        case .imagePNG:
            return "Obraz"
        case .imageJPG, .googlePhoto, .googleDrawing:
            return "Obraz"
        case .googleAudio, .audioMP3, .audioMPEG:
            return "Audio"
        case .documentPDF:
            return "Dokument PDF"
        case .videoMOV, .videoMP4, .videoWMV, .video3GP, .videoAVI:
            return "Wideo"
        default:
            return "Nieznany"
        }
    }

    static func descriptionForMIMETypeString(_ mimeTypeString: String) -> String {
        if let mimeType = MIMEType(rawValue: mimeTypeString) {
            return  FileTypeDescriptionProvider.descriptionForMIMEType(mimeType)
        }
        return "Nieznany"
    }
    
    
}
