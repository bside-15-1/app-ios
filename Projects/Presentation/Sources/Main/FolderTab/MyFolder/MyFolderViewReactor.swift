//
//  MyFolderViewReactor.swift
//  Presentation
//
//  Created by 박천송 on 2023/07/11.
//

import Foundation

import ReactorKit
import RxSwift

import Domain
import PresentationInterface

final class MyFolderViewReactor: Reactor {

  // MARK: Action & Mutation & State

  enum Action {
    case viewDidLoad
    case viewWillAppear
    case searchText(String)
    case createFolderSucceed
    case deleteFolder(Folder)
    case updateSort(FolderSortModel)
    case refresh
  }

  enum Mutation {
    case setFolderList([Folder])
    case setFolderViewModel(MyFolderSectionViewModel)
    case setSortType(FolderSortModel)
    case setEndRefreshing
  }

  struct State {
    var folderList: [Folder] = []
    var folderViewModel: MyFolderSectionViewModel?

    var folderSortType: FolderSortModel = .create

    @Pulse var endRefreshing = false
  }

  // MARK: Properties

  private let disposeBag = DisposeBag()

  let initialState: State

  private let fetchFolderListUseCase: FetchFolderListUseCase
  private let deleteFolderUseCase: DeleteFolderUseCase
  private let getFolderListUseCase: GetFolderListUseCase


  // MARK: initializing

  init(
    fetchFolderListUseCase: FetchFolderListUseCase,
    deleteFolderUseCase: DeleteFolderUseCase,
    getFolderListUseCase: GetFolderListUseCase
  ) {
    defer { _ = self.state }

    self.fetchFolderListUseCase = fetchFolderListUseCase
    self.deleteFolderUseCase = deleteFolderUseCase
    self.getFolderListUseCase = getFolderListUseCase

    self.initialState = State()
  }

  deinit {
    print("🗑️ deinit: \(type(of: self))")
  }


  // MARK: Mutate & Reduce

  func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case .viewDidLoad:
      return fetchFolderList(sort: .createAt)

    case .viewWillAppear:
      var newFolderList = getFolderListUseCase.execute().folders
      newFolderList.insert(.all(count: getFolderListUseCase.execute().totalLinkCount), at: 0)

      let viewModel = makeViewModel(withFolderList: newFolderList)

      return .concat([
        .just(Mutation.setFolderList(newFolderList)),
        .just(Mutation.setFolderViewModel(viewModel)),
      ])


    case .searchText(let text):

      guard !text.isEmpty else {
        let viewModel = makeViewModel(withFolderList: currentState.folderList)

        return .just(Mutation.setFolderViewModel(viewModel))
      }

      let filteredList = currentState.folderList.filter {
        $0.title.range(of: text, options: .caseInsensitive) != nil
      }

      let viewModel = makeViewModel(withFolderList: filteredList)

      return .just(Mutation.setFolderViewModel(viewModel))

    case .createFolderSucceed:
      let sortType: FolderSortingType

      switch currentState.folderSortType {
      case .create:
        sortType = .createAt
      case .naming:
        sortType = .title
      case .update:
        sortType = .lastSavedAt
      }

      return fetchFolderList(sort: sortType)

    case .deleteFolder(let folder):
      return deleteFolder(folder: folder)

    case .updateSort(let type):
      return updateSort(type: type)

    case .refresh:
      let sortType: FolderSortingType

      switch currentState.folderSortType {
      case .create:
        sortType = .createAt
      case .naming:
        sortType = .title
      case .update:
        sortType = .lastSavedAt
      }

      return .concat([
        fetchFolderList(sort: sortType),
        .just(Mutation.setEndRefreshing),
      ])
    }
  }

  func reduce(state: State, mutation: Mutation) -> State {
    var newState = state

    switch mutation {
    case .setFolderList(let list):
      newState.folderList = list

    case .setFolderViewModel(let viewModel):
      newState.folderViewModel = viewModel

    case .setSortType(let type):
      newState.folderSortType = type

    case .setEndRefreshing:
      newState.endRefreshing = true
    }

    return newState
  }
}


// MARK: - Private

extension MyFolderViewReactor {

  private func fetchFolderList(sort: FolderSortingType) -> Observable<Mutation> {
    fetchFolderListUseCase.execute(sort: sort)
      .asObservable()
      .flatMap { [weak self] folderList -> Observable<Mutation> in
        guard let self else { return .empty() }

        var newFolderList = folderList.folders
        newFolderList.insert(.all(count: folderList.totalLinkCount), at: 0)

        let viewModel = makeViewModel(withFolderList: newFolderList)

        return .concat([
          .just(Mutation.setFolderList(newFolderList)),
          .just(Mutation.setFolderViewModel(viewModel)),
        ])
      }
  }

  private func makeViewModel(withFolderList folderList: [Folder]) -> MyFolderSectionViewModel {
    MyFolderSectionViewModel(
      section: .normal,
      items: folderList.map {
        .init(
          id: $0.id,
          coverColor: $0.backgroundColor,
          titleColor: $0.titleColor,
          title: $0.title,
          illust: $0.illustration,
          linkCount: $0.linkCount,
          isDefault: $0.isDefault
        )
      }
    )
  }

  private func deleteFolder(folder: Folder) -> Observable<Mutation> {
    deleteFolderUseCase.execute(id: folder.id)
      .asObservable()
      .flatMap { [weak self] _ -> Observable<Mutation> in
        guard let self else { return .empty() }
        let sortType: FolderSortingType

        switch currentState.folderSortType {
        case .create:
          sortType = .createAt
        case .naming:
          sortType = .title
        case .update:
          sortType = .lastSavedAt
        }

        return fetchFolderList(sort: sortType)
      }
  }

  private func updateSort(type: FolderSortModel) -> Observable<Mutation> {
    let sortType: FolderSortingType

    switch type {
    case .create:
      sortType = .createAt
    case .naming:
      sortType = .title
    case .update:
      sortType = .lastSavedAt
    }

    let fetch: Observable<Mutation> = fetchFolderList(sort: sortType)

    return .concat([
      .just(Mutation.setSortType(type)),
      fetch,
    ])
  }
}
