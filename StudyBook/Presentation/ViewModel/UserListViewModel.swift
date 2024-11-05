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
    private let usecase: UserListResult
    private let erorr = PublishRelay<String>()
    
    private let fetchUserList = BehaviorRelay<[UserListItem]>(value: [])
    private let allFavoriteUserList = BehaviorRelay<[UserListItem]>(value: [])
    private let favoriteUserList = BehaviorRelay<[UserListItem]>(value: [])
    
    public init(usecase: UserListResult) {
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
            .bind(onNext: { $0.0.fetchUserInfo(query: $0.1) })
            .disposed(by: disposedBag)
        
        input.saveFavorite
            .withUnretained(self)
            .bind(onNext: { $0.0.saveFavoriteUser(user: $0.1) })
            .disposed(by: disposedBag)
        
        input.deleteFavorite
            .withUnretained(self)
            .bind(onNext: { $0.0.deleteFavoriteUser(id: $0.1) })
            .disposed(by: disposedBag)
        
        input.fetchMore
            .withUnretained(self)
            .bind(onNext: { $0.0.fetchMore() })
            .disposed(by: disposedBag)
        
        let cellData: Observable<[UserListCellData]> = Observable.combineLatest(input.tabbuttonType, fetchUserList).map { buttonType, userListItems in
            let cellData: [UserListCellData] = []
            return cellData
        }
        
        return Output(cellData: cellData, error: erorr.asObservable())
    }
    
    private func fetchMore() {
        
    }
    
    private func deleteFavoriteUser(id: Int) {
        
    }
    
    private func saveFavoriteUser(user: UserListItem) {
        
    }
    
    private func fetchUserInfo(query: String) {
        
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
