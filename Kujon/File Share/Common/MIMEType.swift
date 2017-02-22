//
//  MIMEType.swift
//  Kujon
//
//  Created by Adam on 26.12.2016.
//  Copyright © 2016 Mobi. All rights reserved.
//

import Foundation

enum MIMEType: String {
    case googleFolder = "application/vnd.google-apps.folder"
    case googleAudio = "application/vnd.google-apps.audio"
    case googleDocument = "application/vnd.google-apps.document"
    case googleDrawing = "application/vnd.google-apps.drawing"
    case googleFile = "application/vnd.google-apps.file"
    case googleForm = "application/vnd.google-apps.form"
    case googleFusiontable = "application/vnd.google-apps.fusiontable"
    case googleMap = "application/vnd.google-apps.map"
    case googlePhoto = "application/vnd.google-apps.photo"
    case googlePresentation = "application/vnd.google-apps.presentation"
    case googleScript = "application/vnd.google-apps.script"
    case googleSites = "application/vnd.google-apps.sites"
    case googleSpreadsheet = "application/vnd.google-apps.spreadsheet"
    case googleUnknown = "application/vnd.google-apps.unknown"
    case googleVideo = "application/vnd.google-apps.video"

    case binary = "binary/octet-stream"
    case text = "text/plain"
    case html = "text/html"

    case audioMP3 = "audio/mp3"
    case audioMP3_alt1 = "audio/mpeg3"
    case audioMP3_alt2 = "audio/x-mp3"
    case audioMP3_alt3 = "audio/x-mpeg3"
    case audioMP4 = "audio/mp4"
    case audioMPEG = "audio/mpeg"
    case audioMPEG_alt = "audio/x-mpeg"
    case audioM4A = "audio/x-m4a"
    case audioM4B = "audio/x-m4b"
    case audioM4P = "audio/x-m4p"
    case audioWAV = "audio/wav"
    case audioWAV_alt = "audio/x-wav"
    case audioOGG = "application/ogg"
    case audioWEBM = "audio/webm"
    case audio3GP = "audio/3gpp"
    case audio3GP2 = "audio/3gpp2"
    case audiAIFF = "audio/aiff"
    case audiAIFF_alt = "audio/x-aiff"
    case audioAMR = "audio/amr"
    case audioM3U = "audio/x-mpegurl"

    case imageJPG = "image/jpeg"
    case imagePNG = "image/png"
    case imageTIFF = "image/tiff"
    case imageBMP = "image/bmp"
    case imageGIF = "image/gif"

    case documentPDF = "application/pdf"
    case documentRTF = "application/rtf"

    case videoAVI = "video/x-msvideo"
    case videoMOV = "video/quicktime"
    case videoM4V = "video/x-m4v"
    case videoMP4 = "video/mp4"
    case video3GP = "video/3gpp"
    case video3GP2 = "video/3gpp2"
    case videoWMV = "video/x-ms-wmv"
    case videoMPG = "video/mpeg"


    case msWord = "application/vnd.openxmlformats-officedocument.wordprocessingml.document"
    case msWord_old = "application/msword"

    case msPowerPoint = "application/vnd.openxmlformats-officedocument.presentationml.presentation"
    case msPowerPoint_old1 = "application/mspowerpoint"
    case msPowerPoint_old2 = "application/powerpoint"
    case msPowerPoint_old3 = "application/vnd.ms-powerpoint"
    case msPowerPoint_old4 = "application/x-mspowerpoint"

    case msExcel = "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"
    case msExcel_old1 = "application/excel"
    case msExcel_old2 = "application/vnd.ms-excel"
    case msExcel_old3 = "application/x-excel"
    case msExcel_old4 = "application/x-msexcel"

    case openOfficePresentation = "application/vnd.oasis.opendocument.presentation"
    case openOfficeSpreadsheet = "application/vnd.oasis.opendocument.spreadsheet"
    case openOfficeDocument = "application/vnd.oasis.opendocument.text"

    case iWorkKeynote = "application/x-iwork-keynote-sffkey"
    case iWorkPages = "application/x-iwork-pages-sffpages"
    case iWorkNumbers = "application/x-iwork-numbers-sffnumbers"

    case zip = "application/x-compressed"
    case zip_alt_1 = "application/x-zip-compressed"
    case zip_alt_2 = "application/zip"
    case gzip = "application/gzip"


    static func mimeTypeForFileExtension(_ fileExtension: String) -> MIMEType {
        let ext = fileExtension.uppercased()
        switch ext {
        case "ZIP": return MIMEType.zip
        case "GZ": return MIMEType.gzip

        case "XLS": return MIMEType.msExcel_old1
        case "XLSX": return MIMEType.msExcel
        case "DOC": return MIMEType.msWord_old
        case "DOCX": return MIMEType.msWord
        case "DOT": return MIMEType.msWord
        case "PPT": return MIMEType.msPowerPoint_old1
        case "PPTX": return MIMEType.msPowerPoint
        case "ODP": return MIMEType.openOfficePresentation
        case "ODS": return MIMEType.openOfficeSpreadsheet
        case "ODT": return MIMEType.openOfficeDocument
        case "KEY": return MIMEType.iWorkKeynote
        case "PAGES": return MIMEType.iWorkPages
        case "NUMBERS": return MIMEType.iWorkNumbers
        case "RTF": return MIMEType.documentRTF

        case "AVI": return MIMEType.videoAVI
        case "MOV": return MIMEType.videoMOV
        case "MQV": return MIMEType.videoMOV
        case "M4V": return MIMEType.videoM4V
        case "MP4": return MIMEType.videoMP4
        case "3GP": return MIMEType.video3GP
        case "WMV": return MIMEType.videoWMV
        case "MPA": return MIMEType.videoMPG
        case "MPE": return MIMEType.videoMPG
        case "MPEG": return MIMEType.videoMPG
        case "MPG": return MIMEType.videoMPG
        case "MPV2": return MIMEType.videoMPG

        case "JPG": return MIMEType.imageJPG
        case "JPEG": return MIMEType.imageJPG
        case "PNG": return MIMEType.imagePNG
        case "TIFF": return MIMEType.imageTIFF
        case "GIF": return MIMEType.imageGIF
        case "PDF": return MIMEType.documentPDF
        case "BMP": return MIMEType.imageBMP

        case "MP3": return MIMEType.audioMP3
        case "AIF": return MIMEType.audiAIFF
        case "M3U": return MIMEType.audioM3U
        case "WAV": return MIMEType.audioWAV
        case "M4A": return MIMEType.audioMP4
        case "OGG": return MIMEType.audioOGG
        case "AMR": return MIMEType.audioAMR

        default: return MIMEType.binary

        }
    }


}
