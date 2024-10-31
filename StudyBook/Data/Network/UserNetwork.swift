//
//  UserNetwork.swift
//  StudyBook
//
//  Created by geonhui Yu on 10/31/24.
//

import Foundation

final public class UserNetwork {
    private let manager: NetworkManagerProtocol
    init(manager: NetworkManagerProtocol) {
        self.manager = manager
    }
    
    func fetchUser(query: String, page: Int) async -> Result<UserListResult, NetworkError> {
        let url = "https:\\api.github.com/search/uses?q=\(query)&page=\(page)"
        return manager.fetchData(url: url, method: .get, parameters: nil)
    }
}
