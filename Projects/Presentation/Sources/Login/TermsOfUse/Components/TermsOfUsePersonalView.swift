import Foundation
import UIKit

import SnapKit
import Then

import DesignSystem

final class TermsOfUsePersonalView: UIControl {
  override var isSelected: Bool {
    didSet {
      guard isSelected != oldValue else { return }
      checkBox.isSelected = isSelected
    }
  }

  // MARK: UI

  private let container = UIView().then {
    $0.isUserInteractionEnabled = false
  }

  private let checkBox = CheckBox(type: .outline).then {
    $0.isUserInteractionEnabled = false
  }

  private let titleLabel = UILabel().then {
    $0.text = "개인정보 수집 및 이용 동의"
    $0.font = .defaultRegular
    $0.textColor = .gray900
  }

  let showPageButton = UIButton().then {
    $0.setImage(DesignSystemAsset.iconChevronRight.image.withTintColor(.gray500), for: .normal)
  }

  // MARK: Initialize

  override init(frame: CGRect) {
    super.init(frame: frame)

    defineLayout()
  }

  required init?(coder: NSCoder) {
    super.init(coder: coder)
  }

  // MARK: Layout

  private func defineLayout() {
    addSubview(container)

    [checkBox, titleLabel, showPageButton].forEach { addSubview($0) }

    checkBox.snp.makeConstraints {
      $0.top.bottom.equalToSuperview().inset(11)
      $0.left.equalToSuperview().inset(16)
    }

    titleLabel.snp.makeConstraints {
      $0.left.equalTo(checkBox.snp.right).offset(8)
      $0.centerY.equalToSuperview()
    }

    showPageButton.snp.makeConstraints {
      $0.right.equalToSuperview()
      $0.size.equalTo(CGSize(width: 24, height: 24))
      $0.centerY.equalToSuperview()
    }
  }
}
