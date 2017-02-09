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
    case audioOGG = "OGG"
    case audioWEBM = "audio/webm"
    case audio3GP = "audio/3gpp"
    case audio3GP2 = "audio/3gpp2"
    case audiAIFF = "audio/aiff"
    case audiAIFF_alt = "audio/x-aiff"
    case audioAMR = "audio/amr"

    case imageJPG = "image/jpeg"
    case imagePNG = "image/png"

    case documentPDF = "application/pdf"

    case videoAVI = "video/x-msvideo"
    case videoMOV = "video/quicktime"
    case videoM4V = "video/x-m4v"
    case videoMP4 = "video/mp4"
    case video3GP = "video/3gpp"
    case video3GP2 = "video/3gpp2"
    case videoWMV = "video/x-ms-wmv"


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

    case zip = "application/x-compressed"
    case zip_alt_1 = "application/x-zip-compressed"
    case zip_alt_2 = "application/zip"
    
}
