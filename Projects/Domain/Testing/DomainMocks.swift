///
/// @Generated by Mockolo
///



import Foundation
import LinkPresentation
import RxSwift
import SwiftSoup
@testable import Domain


public final class AppleLoginUseCaseMock: AppleLoginUseCase {
    public init() { }


    public private(set) var excuteCallCount = 0
    public var excuteArgValues = [String]()
    public var excuteHandler: ((String) -> (Single<Bool>))?
    public func excute(identity: String) -> Single<Bool> {
        excuteCallCount += 1
        excuteArgValues.append(identity)
        if let excuteHandler = excuteHandler {
            return excuteHandler(identity)
        }
        fatalError("excuteHandler returns can't have a default value thus its handler must be set")
    }
}

public final class GoogleLoginUseCaseMock: GoogleLoginUseCase {
    public init() { }


    public private(set) var excuteCallCount = 0
    public var excuteArgValues = [String]()
    public var excuteHandler: ((String) -> (Single<Bool>))?
    public func excute(access: String) -> Single<Bool> {
        excuteCallCount += 1
        excuteArgValues.append(access)
        if let excuteHandler = excuteHandler {
            return excuteHandler(access)
        }
        fatalError("excuteHandler returns can't have a default value thus its handler must be set")
    }
}

public final class LoginRepositoryMock: LoginRepository {
    public init() { }


    public private(set) var requestGoogleLoginCallCount = 0
    public var requestGoogleLoginArgValues = [String]()
    public var requestGoogleLoginHandler: ((String) -> (Single<Bool>))?
    public func requestGoogleLogin(accessToken: String) -> Single<Bool> {
        requestGoogleLoginCallCount += 1
        requestGoogleLoginArgValues.append(accessToken)
        if let requestGoogleLoginHandler = requestGoogleLoginHandler {
            return requestGoogleLoginHandler(accessToken)
        }
        fatalError("requestGoogleLoginHandler returns can't have a default value thus its handler must be set")
    }

    public private(set) var requestAppleLoginCallCount = 0
    public var requestAppleLoginArgValues = [String]()
    public var requestAppleLoginHandler: ((String) -> (Single<Bool>))?
    public func requestAppleLogin(identity: String) -> Single<Bool> {
        requestAppleLoginCallCount += 1
        requestAppleLoginArgValues.append(identity)
        if let requestAppleLoginHandler = requestAppleLoginHandler {
            return requestAppleLoginHandler(identity)
        }
        fatalError("requestAppleLoginHandler returns can't have a default value thus its handler must be set")
    }

    public private(set) var logoutCallCount = 0
    public var logoutHandler: (() -> (Single<Bool>))?
    public func logout() -> Single<Bool> {
        logoutCallCount += 1
        if let logoutHandler = logoutHandler {
            return logoutHandler()
        }
        fatalError("logoutHandler returns can't have a default value thus its handler must be set")
    }

    public private(set) var requestSignUpCallCount = 0
    public var requestSignUpArgValues = [(String, Int?, String?, String?, String)]()
    public var requestSignUpHandler: ((String, Int?, String?, String?, String) -> (Single<Bool>))?
    public func requestSignUp(accessToken: String, age: Int?, gender: String?, nickname: String?, social: String) -> Single<Bool> {
        requestSignUpCallCount += 1
        requestSignUpArgValues.append((accessToken, age, gender, nickname, social))
        if let requestSignUpHandler = requestSignUpHandler {
            return requestSignUpHandler(accessToken, age, gender, nickname, social)
        }
        fatalError("requestSignUpHandler returns can't have a default value thus its handler must be set")
    }
}

public final class LogoutUseCaseMock: LogoutUseCase {
    public init() { }


    public private(set) var excuteCallCount = 0
    public var excuteHandler: (() -> (Single<Bool>))?
    public func excute() -> Single<Bool> {
        excuteCallCount += 1
        if let excuteHandler = excuteHandler {
            return excuteHandler()
        }
        fatalError("excuteHandler returns can't have a default value thus its handler must be set")
    }
}

public final class SignUpUseCaseMock: SignUpUseCase {
    public init() { }


    public private(set) var excuteCallCount = 0
    public var excuteArgValues = [(String, Int?, String?, String?, String)]()
    public var excuteHandler: ((String, Int?, String?, String?, String) -> (Single<Bool>))?
    public func excute(accessToken: String, age: Int?, gender: String?, nickname: String?, social: String) -> Single<Bool> {
        excuteCallCount += 1
        excuteArgValues.append((accessToken, age, gender, nickname, social))
        if let excuteHandler = excuteHandler {
            return excuteHandler(accessToken, age, gender, nickname, social)
        }
        fatalError("excuteHandler returns can't have a default value thus its handler must be set")
    }
}

