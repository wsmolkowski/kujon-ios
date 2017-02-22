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

        case .googleSpreadsheet,
             .openOfficeSpreadsheet,
             .iWorkNumbers,
             .msExcel,
             .msExcel_old1,
             .msExcel_old2,
             .msExcel_old3,
             .msExcel_old4:
            return "Arkusz kalkulacyjny"

        case .googlePresentation,
             .openOfficePresentation,
             .iWorkKeynote,
             .msPowerPoint,
             .msPowerPoint_old1,
             .msPowerPoint_old2,
             .msPowerPoint_old3,
             .msPowerPoint_old4:
            return "Prezentacja"

        case .googleDocument,
             .openOfficeDocument,
             .iWorkPages,
             .documentRTF,
             .msWord,
             .msWord_old:
            return "Dokument tekstowy"

        case .imagePNG,
             .imageJPG,
             .googlePhoto,
             .googleDrawing:
            return "Obraz"

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
            return "Audio"

        case .documentPDF:
            return "Dokument PDF"

        case .videoMOV,
             .videoMP4,
             .videoWMV,
             .video3GP,
             .videoAVI,
             .videoM4V,
             .video3GP2:
            return "Wideo"

        case .zip,
             .zip_alt_1,
             .zip_alt_2:
            return "Archiwum plików"

        case .text:
            return "Plik tekstowy"

        case .html:
            return "Plik html"

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
