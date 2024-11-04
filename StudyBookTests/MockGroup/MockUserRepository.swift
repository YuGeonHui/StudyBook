//
//  MockUserRepository.swift
//  StudyBookTests
//
//  Created by geonhui Yu on 11/4/24.
//

import Foundation
@testable import StudyBook

public struct MockUserRepository: UserRepositoryProtocol {
    public func fetchUser(query: String, page: Int) async -> Result<StudyBook.UserListResult, StudyBook.NetworkError> {
        return .failure(.dataNil)
    }
    
    public func getFavoriteUser() -> Result<[StudyBook.UserListItem], StudyBook.CoreDataError> {
        return .failure(.entityNotFound(""))
    }
    
    public func saveFavoriteUser(user: StudyBook.UserListItem) -> Result<Bool, StudyBook.CoreDataError> {
        return .failure(.entityNotFound(""))
    }
    
    public func deleteFavoriteUser(userID: Int) -> Result<Bool, StudyBook.CoreDataError> {
        return .failure(.entityNotFound(""))
    }
}
