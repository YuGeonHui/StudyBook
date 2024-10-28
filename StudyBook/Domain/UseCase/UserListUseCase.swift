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
}
