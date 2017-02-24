//
//  Progressable.swift
//  Kujon
//
//  Created by Adam on 23.12.2016.
//  Copyright © 2016 Mobi. All rights reserved.
//

import Foundation

typealias ProgressUpdateHandlerType = ( _ progress:Float, _ totalBytesProceededFormatted:String, _ totalSizeFormatted:String, _ bytesProceeded: Int64) -> Void

protocol ProgressTrackable: class {

    var progress: Float { get set }
    var totalBytesProceeded: Int64 { get set }
    var totalSizeInBytes: Int64 { get set }
    var progressUpdateHandler: ProgressUpdateHandlerType { get set }

    func updateProgress(totalBytesProceeded: Int64, totalSizeInBytes: Int64)
}

extension ProgressTrackable {

    private var progressAdvanceForUnknownSize: Float {
        return 1.0
    }

    internal var totalBytesProceededFormatted: String {
        return ByteCountFormatter.string(fromByteCount: totalSizeInBytes, countStyle: .binary)
    }

    internal var totalSizeFormatted: String {
        if totalSizeInBytes == -1 {
            return "?"
        }
        return ByteCountFormatter.string(fromByteCount: totalSizeInBytes, countStyle: .binary)
    }

    internal func updateProgress(totalBytesProceeded: Int64, totalSizeInBytes: Int64) {
        self.progress = totalSizeInBytes == -1 ? progressAdvanceForUnknownSize : Float(totalBytesProceeded)/Float(totalSizeInBytes)
        if progress < 0.001 { progress = 0.0 }
        self.totalBytesProceeded = totalBytesProceeded
        self.totalSizeInBytes = totalSizeInBytes
        progressUpdateHandler(progress, totalBytesProceededFormatted, totalSizeFormatted, totalBytesProceeded)
    }
}
