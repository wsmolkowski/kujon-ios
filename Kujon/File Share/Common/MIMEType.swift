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
    case audioMP3 = "audio/mpeg3"
    case audioMPEG = "audio/mpeg"
    case imageJPG = "image/jpeg"
    case imagePNG = "image/png"
    case documentPDF = "application/pdf"

    case videoAVI = "video/x-msvideo"
    case videoMOV = "video/quicktime"
    case videoMP4 = "video/mp4"
    case video3GP = "video/3gpp"
    case videoWMV = "video/x-ms-wmv"

    case msWord = "application/vnd.openxmlformats-officedocument.wordprocessingml.document"
    case msPowerPoint = "application/vnd.openxmlformats-officedocument.presentationml.presentation"
    case msExcel = "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"
    
}
