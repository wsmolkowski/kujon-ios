//
// Created by Wojciech Maciejewski on 26/06/16.
// Copyright (c) 2016 Mobi. All rights reserved.
//

import Foundation

class ProvidersProviderImpl: ProvidersProvider {
    static let sharedInstance: ProvidersProvider = ProvidersProviderImpl()


    lazy var facultieProvider = FacultiesProvider()

    lazy var gradesProvider = GradesProvider()

    lazy var userDetailsProvider = UserDetailsProvider()

    lazy var usosesProvider = UsosesProvider()


    lazy var lectureProvider = LectureProvider()

    lazy var lecturerProvider = LecturerProvider()


    func providerFacultiesProvider() -> FacultiesProvider {
        return self.facultieProvider
    }

    func provideGradesProvider() -> GradesProvider {
        return self.gradesProvider
    }

    func provideUserDetailsProvider() -> UserDetailsProvider {
        return self.userDetailsProvider
    }

    func provideUsosesProvider() -> UsosesProvider {
        return self.usosesProvider
    }

    func provideLectureProvider() -> LectureProvider {
        return self.lectureProvider
    }

    func provideLecturerProvider() -> LecturerProvider {
        return self.lecturerProvider
    }

}
