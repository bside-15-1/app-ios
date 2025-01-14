//
//  DeleteAccountViewController.swift
//  Presentation
//
//  Created by 박천송 on 2023/07/22.
//

import UIKit

import ReactorKit
import RxSwift

import DesignSystem
import PBAnalyticsInterface
import PresentationInterface

final class DeleteAccountViewController: UIViewController, StoryboardView {

  // MARK: UI

  private lazy var contentView = DeleteAccountView()


  // MARK: Properties

  var disposeBag = DisposeBag()

  weak var delegate: DeleteAccountDelegate?

  private let analytics: PBAnalytics


  // MARK: Initializing

  init(
    reactor: DeleteAccountViewReactor,
    analytics: PBAnalytics
  ) {
    defer { self.reactor = reactor }

    self.analytics = analytics

    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }


  // MARK: View Life Cycle

  override func loadView() {
    view = contentView
  }

  override func viewDidLoad() {
    super.viewDidLoad()
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)

    navigationController?.isNavigationBarHidden = false

    configureNavigationBar()
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)

    analytics.log(type: DeleteAccountEvent.shown)
  }


  // MARK: Binding

  func bind(reactor: DeleteAccountViewReactor) {
    contentView.checkBox.rx.controlEvent(.touchUpInside)
      .subscribe(with: self) { `self`, _ in
        self.analytics.log(type: DeleteAccountEvent.click(component: .checkAgreeToDeleteData))
        reactor.action.onNext(.check(!reactor.currentState.isCheck))
      }
      .disposed(by: disposeBag)

    reactor.state.map(\.isCheck)
      .asObservable()
      .distinctUntilChanged()
      .bind(to: contentView.checkBox.rx.isSelected)
      .disposed(by: disposeBag)

    reactor.state.map(\.isDeleteButtonEnabled)
      .asObservable()
      .distinctUntilChanged()
      .bind(to: contentView.deleteButton.rx.isEnabled)
      .disposed(by: disposeBag)

    reactor.state.map(\.isUseButtonEnabled)
      .asObservable()
      .distinctUntilChanged()
      .bind(to: contentView.useButton.rx.isEnabled)
      .disposed(by: disposeBag)

    contentView.deleteButton.rx.controlEvent(.touchUpInside)
      .subscribe(with: self) { `self`, _ in
        self.analytics.log(type: DeleteAccountEvent.click(component: .deleteAccount))

        PBDialog(
          title: "정말로 탈퇴하시겠습니까?",
          content: "계정 정보 및 링크, 폴더가 삭제되며\n삭제된 데이터는 복구되지 않습니다.",
          from: self
        )
        .addAction(content: "탈퇴 확인", priority: .secondary, action: {
          self.analytics.log(type: DeleteAccountEvent.click(component: .confirmdelete))
          reactor.action.onNext(.deleteAccountButtonTapped)
        })
        .addAction(content: "탈퇴 취소", priority: .primary, action: {
          self.analytics.log(type: DeleteAccountEvent.click(component: .canceldelete))
        })
        .show()
      }
      .disposed(by: disposeBag)

    contentView.useButton.rx.controlEvent(.touchUpInside)
      .subscribe(with: self) { `self`, _ in
        self.analytics.log(type: DeleteAccountEvent.click(component: .continueUsing))
        self.navigationController?.popViewController(animated: true)
      }
      .disposed(by: disposeBag)

    reactor.state.map(\.isSucceed)
      .distinctUntilChanged()
      .filter { $0 }
      .asObservable()
      .subscribe(with: self) { `self`, _ in
        self.delegate?.deleteAccountSuccess()
      }
      .disposed(by: disposeBag)
  }
}


// MARK: - NavigationBar

extension DeleteAccountViewController {

  private func configureNavigationBar() {
    let backButton = UIBarButtonItem(
      image: DesignSystemAsset.iconChevronLeftLarge.image.withTintColor(.staticBlack),
      style: .plain,
      target: self,
      action: #selector(pop)
    )

    navigationItem.leftBarButtonItem = backButton
    navigationItem.leftBarButtonItem?.tintColor = .staticBlack
    navigationItem.title = "회원탈퇴"

    let attributes = [
      NSAttributedString.Key.foregroundColor: UIColor.staticBlack,
      NSAttributedString.Key.font: UIFont.titleBold,
    ]
    navigationController?.navigationBar.titleTextAttributes = attributes
  }

  @objc
  private func pop() {
    navigationController?.popViewController(animated: true)
  }
}
