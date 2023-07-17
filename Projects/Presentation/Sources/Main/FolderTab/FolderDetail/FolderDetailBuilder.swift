//
//  FolderDetailBuilder.swift
//  Presentation
//
//  Created by 박천송 on 2023/07/17.
//

import UIKit
import Foundation

import Domain
import PresentationInterface

struct FolderDetailDependency {
  let linkRepository: LinkRepository
  let linkSortBuilder: LinkSortBuildable
}

final class FolderDetailBuilder: FolderDetailBuildable {

  private let dependency: FolderDetailDependency

  init(dependency: FolderDetailDependency) {
    self.dependency = dependency
  }

  func build(payload: FolderDetailPayload) -> UIViewController {
    let reactor = FolderDetailViewReactor(
      fetchAllLinkUseCase: FetchAllLinksUseCaseImpl(linkRepository: dependency.linkRepository),
      fetchLinkInFolderUseCase: FetchLinksInFolderUseCaseImpl(linkRepository: dependency.linkRepository),
      folderList: payload.folderList,
      selectedFolder: payload.selectedFolder
    )

    let viewController = FolderDetailViewController(
      reactor: reactor,
      linkSortBuilder: dependency.linkSortBuilder
    )

    return viewController
  }
}
