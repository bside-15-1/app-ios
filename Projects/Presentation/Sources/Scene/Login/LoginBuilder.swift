//
//  LoginBuilder.swift
//  Presentation
//
//  Created by 박천송 on 2023/04/27.
//

import Foundation

import UIKit

import Domain
import JSAnalyticsInterface
import PresentationInterface

// MARK: - LoginDependency

struct LoginDependency {
  let loginRepository: LoginRepository
  let analytics: JSAnalytics
}

// MARK: - LoginBuilder

final class LoginBuilder: LoginBuildable {
  private let dependency: LoginDependency

  init(dependency: LoginDependency) {
    self.dependency = dependency
  }

  func build(payload: LoginPayload) -> UIViewController {
    let loginManager = LoginManager()

    let viewModel = LoginViewModel(
      analytics: dependency.analytics,
      loginManager: loginManager,
      googleLoginUseCase: GoogleLoginUseCaseImpl(loginRepository: dependency.loginRepository),
      appleLoginUseCase: AppleLoginUseCaseImpl(loginRepository: dependency.loginRepository)
    )

    let viewController = LoginViewController(viewModel: viewModel)
    loginManager.viewController = viewController
    loginManager.delegate = viewModel

    return viewController
  }
}