//
// Created by Wojciech Maciejewski on 26/06/16.
// Copyright (c) 2016 Mobi. All rights reserved.
//

import Foundation

protocol ProvidersProvider {

    func providerFacultiesProvider() -> FacultiesProvider
    func provideGradesProvider() -> GradesProvider
    func provideUserDetailsProvider() -> UserDetailsProvider
    func provideUsosesProvider() -> UsosesProvider
    func provideLectureProvider() -> LectureProvider
    func provideLecturerProvider() ->LecturerProvider
    func provideCourseProvider() -> CourseProvider
    func proivdeFacultieProvider() -> FacultieProvider
    func provideCourseDetailsProvider() -> CourseDetailsProvider
    func provideDeleteAccount() -> DeleteAccountProvider
    func provideTermsProvider() -> TermsProvider
    func provideProgrammeProvider() -> ProgrammeProvider
    func provideProgrammeId() -> ProgrammeIdProvider
    func provideConfigProvider() -> ConfigProvider
    func provideRegistrationProvider() -> RegistrationProvider
    func provideLoginProvider() -> LoginProvider
}
