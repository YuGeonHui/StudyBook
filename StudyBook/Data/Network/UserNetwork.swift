//
//  UserNetwork.swift
//  StudyBook
//
//  Created by geonhui Yu on 10/31/24.
//

import Foundation

public protocol UserNetworkProtocol {
    func fetchUser(query: String, page: Int) async -> Result<UserListResult, NetworkError>
}

final public class UserNetwork: UserNetworkProtocol {
    private let manager: NetworkManagerProtocol
    init(manager: NetworkManagerProtocol) {
        self.manager = manager
    }
    
    public func fetchUser(query: String, page: Int) async -> Result<UserListResult, NetworkError> {
        let url = "https:\\api.github.com/search/uses?q=\(query)&page=\(page)"
        return manager.fetchData(url: url, method: .get, parameters: nil)
    }
}
