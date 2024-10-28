//
//  UserRepositoryProtocol.swift
//  StudyBook
//
//  Created by geonhui Yu on 10/26/24.
//

import Foundation

public protocol UserRepositoryProtocol {
    func fetchUser(query: String, page: Int) async -> Result<UserListResult, NetworkError>
    func getFavoriteUser() -> Result<[UserListItem], CoreDataError>
    func saveFavoriteUser(user: UserListItem) -> Result<Bool, CoreDataError>
    func deleteFavoriteUser(userID: Int) -> Result<Bool, CoreDataError>
}
