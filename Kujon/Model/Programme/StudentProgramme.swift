//
// Created by Wojciech Maciejewski on 10/06/16.
// Copyright (c) 2016 Mobi. All rights reserved.
//

import Foundation
import Decodable

enum ProgrammeStatus: String {
    case active = "active"
    case cancelled = "cancelled"
    case graduatedDiploma = "graduated_diploma"
    case graduatedBeforeDiploma = "graduated_before_diploma"
    case graduatedEndOfStudy = "graduated_end_of_study"

    internal var iconImage: UIImage {
        switch self {
        case .active:
            return #imageLiteral(resourceName: "status-active")
        case .cancelled:
            return #imageLiteral(resourceName: "canceled-status")
        case .graduatedDiploma:
            return #imageLiteral(resourceName: "graduated-diplomma-status")
        case .graduatedBeforeDiploma:
            return #imageLiteral(resourceName: "graduated-before-diploma-status")
        case .graduatedEndOfStudy:
            return #imageLiteral(resourceName: "graduated-end-of-study-status")
        }
    }

    internal var statusDescription: String {
        switch self {
        case .active:
            return StringHolder.programmeStatusActive
        case .cancelled:
            return StringHolder.programmeStatusCancelled
        case .graduatedDiploma:
            return StringHolder.programmeStatusGraduatedDiploma
        case .graduatedBeforeDiploma:
            return StringHolder.programmeStatusGraduatedBeforeDiploma
        case .graduatedEndOfStudy:
            return StringHolder.programmeStatusGraduatedEndOfStudy
        }
    }
}



struct StudentProgramme {
    let id: String
    let programme: Programme
    let status: ProgrammeStatus?

}

extension StudentProgramme: Decodable {

    static func decode(_ j: Any) throws -> StudentProgramme {
        var status: ProgrammeStatus?
        if let statusString: String = try? j => "status" {
            status = ProgrammeStatus.init(rawValue: statusString)
        }
        return try StudentProgramme(
                id: j => "id",
                programme: j => "programme",
                status: status
        )
    }

}
