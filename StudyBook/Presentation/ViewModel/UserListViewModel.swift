//
//  UserListViewModel.swift
//  StudyBook
//
//  Created by geonhui Yu on 11/5/24.
//

import Foundation
import RxSwift
import RxCocoa

protocol UserListViewModelProtocol {
    
}

// 이벤트(VC) -> 가공 or 외부에서 데이터 호출 or 뷰 데이터를 전달 (VM)  -> VC
public final class UserListViewModel: UserListViewModelProtocol {
    private let disposedBag = DisposeBag()
    private let usecase: UserListUseCase
    private let errorMessage = PublishRelay<String>()
    
    private let fetchUserList = BehaviorRelay<[UserListItem]>(value: [])
    private let allFavoriteUserList = BehaviorRelay<[UserListItem]>(value: [])
    private let favoriteUserList = BehaviorRelay<[UserListItem]>(value: [])
    
    public init(usecase: UserListUseCase) {
        self.usecase = usecase
    }
    
    public struct Input {
        let tabbuttonType: Observable<ButtonType>
        let query: Observable<String>
        let saveFavorite: Observable<UserListItem>
        let deleteFavorite: Observable<Int> // id 값
        let fetchMore: Observable<Void> // pagination
    }
    
    public struct Output {
        let cellData: Observable<[UserListCellData]>
        let error: Observable<String>
    }
    
    public func transform(input: Input) -> Output {
        input.query
            .withUnretained(self)
            .filter { $0.0.validateQuery(query: $0.1) }
            .bind(onNext: {
                $0.0.fetchUserInfo(query: $0.1, page: 0)
                $0.0.getFavoriteUsers(query: $0.1)
            })
            .disposed(by: disposedBag)
        
        input.saveFavorite
            .withLatestFrom(input.query) { ($0, $1) }
            .withUnretained(self)
            .bind(onNext: { $0.saveFavoriteUser(user: $1.0, query: $1.1) })
            .disposed(by: disposedBag)
        
        input.deleteFavorite
            .withLatestFrom(input.query) { ($0, $1) }
            .withUnretained(self)
            .bind(onNext: { $0.deleteFavoriteUser(id: $1.0, query: $1.1)} )
            .disposed(by: disposedBag)
        
        input.fetchMore
            .withUnretained(self)
            .bind(onNext: { $0.0.fetchMore() })
            .disposed(by: disposedBag)
        
        let cellData: Observable<[UserListCellData]> = Observable.combineLatest(input.tabbuttonType, fetchUserList).map { buttonType, userListItems in
            let cellData: [UserListCellData] = []
            return cellData
        }
        
        return Output(cellData: cellData, error: errorMessage.asObservable())
    }
    
    private func fetchMore() {
        
    }
    
    private func deleteFavoriteUser(id: Int, query: String) {
        let result = usecase.deleteFavoriteUser(userID: id)
        switch result {
        case .success(let success):
            getFavoriteUsers(query: query)
        case .failure(let error):
            errorMessage.accept(error.localizedDescription)
        }
    }
    
    private func saveFavoriteUser(user: UserListItem, query: String) {
        let result = usecase.saveFavoriteUser(user: user)
        switch result {
        case .success:
            getFavoriteUsers(query: query)
        case .failure(let error):
            errorMessage.accept(error.localizedDescription)
        }
    }
    
    private func fetchUserInfo(query: String, page: Int) {
        guard let _ = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return }
        Task {
            let result = await usecase.fetchUser(query: query, page: page)
            switch result {
            case .success(let users):
                page == 0 ? fetchUserList.accept(users.items) : fetchUserList.accept(fetchUserList.value + users.items)
            case .failure(let error):
                errorMessage.accept(error.description)
            }
        }
    }
    
    private func getFavoriteUsers(query: String) {
        let result = usecase.getFavoriteUser()
        switch result {
        case .success(let users):
            query.isEmpty ? favoriteUserList.accept(users) : favoriteUserList.accept(users.filter { $0.login.contains(query) })
            allFavoriteUserList.accept(users)
        case .failure(let error):
            errorMessage.accept(error.localizedDescription)
        }
    }
    
    private func validateQuery(query: String) -> Bool {
        return query.isEmpty ? false : true
    }
}

public enum ButtonType {
    case api
    case favorite
}

public enum UserListCellData {
    case user(user: UserListItem, isFavorite: Bool)
    case header(String) // 초성
}
