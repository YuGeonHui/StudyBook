//
//  UserRepository.swift
//  StudyBook
//
//  Created by geonhui Yu on 11/2/24.
//

import Foundation

public struct UserRepository: UserRepositoryProtocol {
    private let coreData: UserCoreDataProtocol
    private let network: UserNetworkProtocol
    
    init(coreData: UserCoreDataProtocol, network: UserNetworkProtocol) {
        self.coreData = coreData
        self.network = network
    }
    
    public func fetchUser(query: String, page: Int) async -> Result<UserListResult, NetworkError> {
        return await network.fetchUser(query: query, page: page)
    }
    
    public func getFavoriteUser() -> Result<[UserListItem], CoreDataError> {
        return coreData.getFavoriteUser()
    }
    
    public func saveFavoriteUser(user: UserListItem) -> Result<Bool, CoreDataError> {
        return coreData.saveFavoriteUser(user: user)
    }
    
    public func deleteFavoriteUser(userID: Int) -> Result<Bool, CoreDataError> {
        return coreData.deleteFavoriteUser(userID: userID)
    }
}
