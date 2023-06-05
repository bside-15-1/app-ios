//
//  InputField.swift
//  DesignSystem
//
//  Created by 박천송 on 2023/06/05.
//

import Foundation
import UIKit

import RxCocoa
import RxSwift
import SnapKit
import Then

public enum InputType {
  case normal
  case search
}

public class InputField: UIView {

  // MARK: Properties

  public var placeHolder: String? {
    didSet {
      textField.placeholder = placeHolder
    }
  }

  public var title: String? {
    didSet {
      titleLabel.text = title
      titleLabel.isHidden = false
    }
  }

  public var text: String? {
    get {
      textField.text
    }

    set {
      textField.text = newValue
    }
  }

  public var errorDescription: String? {
    didSet {
      errorLabel.text = errorDescription
    }
  }

  public var isEnabled = true {
    didSet {
      enabled(isEnabled: isEnabled)
    }
  }

  public var iconActionHandler: (()->Void)? = nil

  public func showError() {
    errorContainer.isHidden = false
  }

  public func hideError() {
    errorContainer.isHidden = true
  }

  public func setDelegate(_ delegate: UITextFieldDelegate) {
    textField.delegate = delegate
  }

  // MARK: UI

  private let stackView = UIStackView().then {
    $0.axis = .vertical
  }

  public let titleLabel = UILabel().then {
    $0.isHidden = true
    $0.font = .subTitleSemiBold
    $0.textColor = .gray900
  }

  private let container = UIView().then {
    $0.backgroundColor = .gray200
    $0.layer.cornerRadius = 8
    $0.layer.borderColor = UIColor.primary500.cgColor
    $0.clipsToBounds = true
  }

  let textField = UITextField().then {
    $0.font = .defaultRegular
  }

  private let rightIcon = UIImageView().then {
    $0.isUserInteractionEnabled = true
  }

  private let errorContainer = UIView().then {
    $0.isHidden = true
  }

  private let errorLabel = UILabel().then {
    $0.textColor = .error
    $0.font = .captionRegular
  }

  private let errorIcon = UIImageView().then {
    $0.image = DesignSystemAsset.iconAlertCircleFill.image.withTintColor(.error)
  }


  // MARK: Initialize

  public convenience init(type: InputType) {
    self.init(frame: .zero)

    switch type {
    case .normal:
      textField.clearButtonMode = .whileEditing
      rightIcon.isHidden = true
      textField.snp.updateConstraints {
        $0.right.equalToSuperview().inset(12.0)
      }
    case .search:
      textField.clearButtonMode = .never
      rightIcon.image = DesignSystemAsset.iconSearchOutline.image.withTintColor(.gray500)
      rightIcon.isHidden = false
      textField.snp.updateConstraints {
        $0.right.equalToSuperview().inset(48.0)
      }
    }
  }

  override init(frame: CGRect) {
    super.init(frame: frame)

    defineLayout()
    addAction()
  }

  required init?(coder: NSCoder) {
    super.init(coder: coder)
  }

  private func defineLayout() {
    addSubview(stackView)

    [titleLabel, container, errorContainer].forEach { stackView.addArrangedSubview($0) }
    [textField, rightIcon].forEach { container.addSubview($0) }
    [errorIcon, errorLabel].forEach { errorContainer.addSubview($0) }

    stackView.setCustomSpacing(4.0, after: titleLabel)
    stackView.setCustomSpacing(2.0, after: container)

    stackView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }

    container.snp.makeConstraints {
      $0.height.equalTo(48.0)
    }

    textField.snp.makeConstraints {
      $0.left.equalToSuperview().inset(12.0)
      $0.right.equalToSuperview().inset(12.0)
      $0.centerY.equalToSuperview()
    }

    rightIcon.snp.makeConstraints {
      $0.size.equalTo(24.0)
      $0.right.equalToSuperview().inset(12.0)
      $0.centerY.equalToSuperview()
    }

    errorIcon.snp.makeConstraints {
      $0.left.equalToSuperview().inset(4.0)
      $0.centerY.equalToSuperview()
      $0.size.equalTo(16.0)
    }

    errorLabel.snp.makeConstraints {
      $0.left.equalTo(errorIcon.snp.right).offset(4.0)
      $0.top.bottom.equalToSuperview()
    }
  }

  private func addAction() {
    rightIcon.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(iconDidTap)))

    textField.addAction(UIAction(handler: { [weak self] _ in
      self?.textField.font = .defaultSemiBold
      self?.container.backgroundColor = .primary100
      self?.container.layer.borderWidth = 1
      self?.rightIcon.image = self?.rightIcon.image?.withTintColor(.gray600)
    }), for: .editingDidBegin)

    textField.addAction(UIAction(handler: { [weak self] _ in
      self?.textField.font = .defaultRegular
      self?.container.backgroundColor = .gray200
      self?.container.layer.borderWidth = 0
      self?.rightIcon.image = self?.rightIcon.image?.withTintColor(.gray500)
    }), for: .editingDidEnd)
  }

  @objc
  private func iconDidTap() {
    iconActionHandler?()
  }

  private func enabled(isEnabled: Bool) {
    if isEnabled {
      isUserInteractionEnabled = true
      titleLabel.textColor = .gray400
      rightIcon.image = rightIcon.image?.withTintColor(.gray400)
    } else {
      isUserInteractionEnabled = false
      titleLabel.textColor = .gray500
      rightIcon.image = rightIcon.image?.withTintColor(.gray500)
    }
  }
}


extension Reactive where Base: InputField {
  var text: ControlProperty<String?> {
    base.textField.rx.text
  }
}