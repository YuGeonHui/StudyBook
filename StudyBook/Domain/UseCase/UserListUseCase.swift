//
//  UserListUseCase.swift
//  StudyBook
//
//  Created by geonhui Yu on 10/28/24.
//

import Foundation

public protocol UserListUseCaseProtocol {
    func fetchUser(query: String, page: Int) async -> Result<UserListResult, NetworkError>
    func getFavoriteUser() -> Result<[UserListItem], CoreDataError>
    func saveFavoriteUser(user: UserListItem) -> Result<Bool, CoreDataError>
    func deleteFavoriteUser(userID: Int) -> Result<Bool, CoreDataError>
    func checkFavoriteState(userList: [UserListItem], favoriteUsers: [UserListItem]) -> [(user: UserListItem, isFavorite: Bool)]
    func converListToDictionary(favoriteUsers: [UserListItem]) -> [String: [UserListItem]] // 초성검색 
}

public struct UserListUseCase: UserListUseCaseProtocol {
    private let repository: UserRepositoryProtocol
    init(repository: UserRepositoryProtocol) {
        self.repository = repository
    }
    
    public func fetchUser(query: String, page: Int) async -> Result<UserListResult, NetworkError> {
        return await repository.fetchUser(query: query, page: page)
    }
    
    public func getFavoriteUser() -> Result<[UserListItem], CoreDataError> {
        return repository.getFavoriteUser()
    }
    
    public func saveFavoriteUser(user: UserListItem) -> Result<Bool, CoreDataError> {
        return repository.saveFavoriteUser(user: user)
    }
    
    public func deleteFavoriteUser(userID: Int) -> Result<Bool, CoreDataError> {
        return repository.deleteFavoriteUser(userID: userID)
    }
    
    public func checkFavoriteState(userList: [UserListItem], favoriteUsers: [UserListItem]) -> [(user: UserListItem, isFavorite: Bool)] {
        let favoriteSet = Set(favoriteUsers)
        return userList.map { user in
            let isFavorite: Bool = favoriteSet.contains(user)
            return (user: user, isFavorite: isFavorite)
        }
    }
    
    public func converListToDictionary(favoriteUsers: [UserListItem]) -> [String : [UserListItem]] {
        return favoriteUsers.reduce(into: [String: [UserListItem]]()) { dict, user in
            if let firstString = user.login.first {
                let key = String(firstString).uppercased()
                dict[key, default: []].append(user)
            }
        }
    }
}
