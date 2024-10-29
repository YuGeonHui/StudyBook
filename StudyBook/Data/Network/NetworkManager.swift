//
//  NetworkManager.swift
//  StudyBook
//
//  Created by geonhui Yu on 10/29/24.
//

import Foundation
import Alamofire

public class NetworkManager {
    private let session: SessionProtocol
    init(session: SessionProtocol) {
        self.session = session
    }
}
