//
// Created by Wojciech Maciejewski on 26/06/16.
// Copyright (c) 2016 Mobi. All rights reserved.
//

import Foundation

class ProvidersProviderImpl: ProvidersProvider {
    static let sharedInstance: ProvidersProvider = ProvidersProviderImpl()


    lazy var facultiesProvider = FacultiesProvider()

    lazy var gradesProvider = GradesProvider()

    lazy var userDetailsProvider = UserDetailsProvider()

    lazy var usosesProvider = UsosesProvider()


    lazy var lectureProvider = LectureProvider()

    lazy var lecturerProvider = LecturerProvider()

    lazy var courseProvider = CourseProvider()

    lazy var facultieProvider = FacultieProvider()

    lazy var courseDetailsProvider = CourseDetailsProvider()

    lazy var deleteAccountProvider = DeleteAccountProvider()

    lazy var termsProvider = TermsProvider()

    lazy var programmeProvider = ProgrammeProvider()

    lazy var programmeIdProvider = ProgrammeIdProvider()

    lazy var configProvider = ConfigProvider()

    lazy var superUserProvider  = SuperUserProvider()

    lazy var verificationProvider  = VerificationProvider()

    func providerFacultiesProvider() -> FacultiesProvider {
        return self.facultiesProvider
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

    func provideCourseProvider() -> CourseProvider {
        return courseProvider
    }

    func proivdeFacultieProvider() -> FacultieProvider {
        return facultieProvider
    }

    func provideCourseDetailsProvider() -> CourseDetailsProvider{
        return courseDetailsProvider;
    }

    func provideDeleteAccount() -> DeleteAccountProvider {
        return deleteAccountProvider;
    }


    func provideTermsProvider() -> TermsProvider {
        return termsProvider;
    }

    func provideProgrammeProvider() -> ProgrammeProvider {
        return programmeProvider
    }

    func provideProgrammeId() -> ProgrammeIdProvider {
        return programmeIdProvider
    }

    func provideConfigProvider() -> ConfigProvider {
        return configProvider
    }

    lazy var registrationProvider = RegistrationProvider()

    func provideRegistrationProvider() -> RegistrationProvider {
        return registrationProvider
    }

    lazy var loginProvider = LoginProvider()

    func provideLoginProvider() -> LoginProvider {
        return loginProvider
    }

    lazy var logoutProvider  = LogoutProvider()

    func provideLogoutProvider() -> LogoutProvider {
        return logoutProvider
    }

    func provideSuperUserProvider() -> SuperUserProvider {
        return superUserProvider
    }

    func provideVerificationProvider() -> VerificationProvider {
        return verificationProvider
    }

}