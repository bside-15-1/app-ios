//
//  LinkDetailView.swift
//  Presentation
//
//  Created by 박천송 on 2023/07/18.
//

import UIKit

import SnapKit
import Then

import DesignSystem
import Domain

final class LinkDetailView: UIView {

  // MARK: UI

  private let folderTitleContainer = UIView()
  private let folderTitleLabel = UILabel()
  private let folderTitleIcon = UIImageView().then {
    $0.image = DesignSystemAsset.iconFolder.image.withTintColor(.gray600)
  }

  let thumbnail = UIImageView().then {
    $0.clipsToBounds = true
    $0.layer.cornerRadius = 8
    $0.contentMode = .scaleAspectFit
    $0.isUserInteractionEnabled = true
  }

  private let urlContainer = UIControl()
  private let urlLabel = UILabel()
  private let urlIcon = UIImageView().then {
    $0.image = DesignSystemAsset.logoJoosumSmall.image.withTintColor(.gray600)
  }

  private let linkTitleLabel = UILabel().then {
    $0.numberOfLines = 0
  }

  private let captionLabel = UILabel()

  private let tagView = LinkDetailTagView()

  let bottomView = LinkDetailBottomView()

  let navigationBar = LinkDetailNavigationBar()

  // MARK: Initializing

  override init(frame: CGRect) {
    super.init(frame: frame)

    self.backgroundColor = .staticWhite

    if UIDevice.current.userInterfaceIdiom == .pad {
      defineIPadLayout()
    } else {
      defineIPhoneLayout()
    }
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }


  // MARK: Configuring

  func configure(withLink link: Link) {
    folderTitleLabel.attributedText = link.folderName.styled(font: .captionRegular, color: .gray600)

    if let thumbnailURL = link.thumbnailURL, !thumbnailURL.isEmpty {
      thumbnail.sd_setImage(with: URL(string: thumbnailURL), placeholderImage: DesignSystemAsset.homeLinkEmptyImage.image)
    } else {
      thumbnail.image = DesignSystemAsset.homeLinkEmptyImage.image
    }

    urlLabel.attributedText = link.url.styled(font: .captionRegular, color: .gray600)

    linkTitleLabel.attributedText = link.title.styled(font: .subTitleBold, color: .gray900)

    // Date
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"

    let date = dateFormatter.date(from: link.createdAt)
    dateFormatter.dateFormat = "yy년 MM월 dd일"

    let stringFromDate = dateFormatter.string(from: date ?? Date())

    if link.readCount > 0 {
      captionLabel.attributedText = "\(stringFromDate)에 주섬주섬 | \(link.readCount)회 읽음"
        .styled(font: .captionRegular, color: .gray600)
    } else {
      captionLabel.attributedText = "\(stringFromDate)에 주섬주섬 | 읽지 않음".styled(font: .captionRegular, color: .gray600)
    }


    tagView.applyTag(by: link.tags)
  }

  func configureFolder(withFolder folder: Folder) {
    folderTitleLabel.attributedText = folder.title.styled(font: .captionRegular, color: .gray600)
  }


  // MARK: Layout

  private func defineIPhoneLayout() {
    [folderTitleContainer, thumbnail, urlContainer, linkTitleLabel, captionLabel, tagView, bottomView].forEach { addSubview($0) }
    [folderTitleIcon, folderTitleLabel].forEach { folderTitleContainer.addSubview($0) }
    [urlIcon, urlLabel].forEach { urlContainer.addSubview($0) }

    folderTitleContainer.snp.makeConstraints {
      $0.top.equalTo(safeAreaLayoutGuide)
      $0.centerX.equalToSuperview()
    }

    folderTitleIcon.snp.makeConstraints {
      $0.left.top.bottom.equalToSuperview()
      $0.size.equalTo(16.0)
    }

    folderTitleLabel.snp.makeConstraints {
      $0.right.centerY.equalToSuperview()
      $0.left.equalTo(folderTitleIcon.snp.right).offset(4.0)
    }

    thumbnail.snp.makeConstraints {
      $0.top.equalTo(folderTitleLabel.snp.bottom).offset(24.0)
      $0.left.right.equalToSuperview().inset(20.0)
      $0.height.equalTo((UIScreen.main.bounds.width - 40) * 9.0 / 16.0)
    }

    urlContainer.snp.makeConstraints {
      $0.top.equalTo(thumbnail.snp.bottom).offset(8.0)
      $0.left.right.equalToSuperview().inset(20.0)
    }

    urlIcon.snp.makeConstraints {
      $0.left.bottom.equalToSuperview()
      $0.width.equalTo(18.65)
      $0.height.equalTo(13)
    }

    urlLabel.snp.makeConstraints {
      $0.top.bottom.right.equalToSuperview()
      $0.left.equalTo(urlIcon.snp.right).offset(4.0)
    }

    linkTitleLabel.snp.makeConstraints {
      $0.top.equalTo(urlLabel.snp.bottom).offset(16.0)
      $0.left.right.equalToSuperview().inset(20.0)
    }

    captionLabel.snp.makeConstraints {
      $0.top.equalTo(linkTitleLabel.snp.bottom).offset(8.0)
      $0.left.right.equalToSuperview().inset(20.0)
    }

    tagView.snp.makeConstraints {
      $0.top.equalTo(captionLabel.snp.bottom).offset(28.0)
      $0.left.right.equalToSuperview().inset(20.0)
    }

    bottomView.snp.makeConstraints {
      $0.top.equalTo(tagView.snp.bottom).offset(8.0)
      $0.left.right.equalToSuperview().inset(20.0)
      $0.bottom.equalTo(safeAreaLayoutGuide).inset(40.0)
    }
  }

  private func defineIPadLayout() {
    [navigationBar, folderTitleContainer, thumbnail, urlContainer, linkTitleLabel, captionLabel, tagView, bottomView]
      .forEach { addSubview($0) }
    [folderTitleIcon, folderTitleLabel].forEach { folderTitleContainer.addSubview($0) }
    [urlIcon, urlLabel].forEach { urlContainer.addSubview($0) }

    navigationBar.snp.makeConstraints {
      $0.top.left.right.equalToSuperview()
    }

    folderTitleContainer.snp.makeConstraints {
      $0.top.equalTo(navigationBar.snp.bottom).offset(20.0)
      $0.centerX.equalToSuperview()
    }

    folderTitleIcon.snp.makeConstraints {
      $0.left.top.bottom.equalToSuperview()
      $0.size.equalTo(16.0)
    }

    folderTitleLabel.snp.makeConstraints {
      $0.right.centerY.equalToSuperview()
      $0.left.equalTo(folderTitleIcon.snp.right).offset(4.0)
    }

    thumbnail.snp.makeConstraints {
      $0.top.equalTo(folderTitleLabel.snp.bottom).offset(24.0)
      $0.width.equalTo(440.0)
      $0.height.equalTo(440.0 * 9.0 / 16.0)
      $0.centerX.equalToSuperview()
    }

    urlContainer.snp.makeConstraints {
      $0.top.equalTo(thumbnail.snp.bottom).offset(8.0)
      $0.left.right.equalTo(thumbnail)
    }

    urlIcon.snp.makeConstraints {
      $0.left.bottom.equalToSuperview()
      $0.width.equalTo(18.65)
      $0.height.equalTo(13)
    }

    urlLabel.snp.makeConstraints {
      $0.top.bottom.right.equalToSuperview()
      $0.left.equalTo(urlIcon.snp.right).offset(4.0)
    }

    linkTitleLabel.snp.makeConstraints {
      $0.top.equalTo(urlLabel.snp.bottom).offset(16.0)
      $0.left.right.equalTo(thumbnail)
    }

    captionLabel.snp.makeConstraints {
      $0.top.equalTo(linkTitleLabel.snp.bottom).offset(8.0)
      $0.left.right.equalTo(thumbnail)
    }

    tagView.snp.makeConstraints {
      $0.top.equalTo(captionLabel.snp.bottom).offset(28.0)
      $0.left.right.equalTo(thumbnail)
    }

    bottomView.snp.makeConstraints {
      $0.top.equalTo(tagView.snp.bottom).offset(8.0)
      $0.left.right.equalTo(thumbnail)
      $0.bottom.equalTo(safeAreaLayoutGuide).inset(40.0)
    }
  }

  override func layoutSubviews() {
    super.layoutSubviews()
  }
}
