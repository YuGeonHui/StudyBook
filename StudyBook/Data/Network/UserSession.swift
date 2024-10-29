//
//  UserSession.swift
//  StudyBook
//
//  Created by geonhui Yu on 10/29/24.
//

import Foundation
import Alamofire

// 네트워크 호출 테스트코드 Mock Session

public protocol SessionProtocol {
    func request(_ convertible: URLConvertible,
                 method: HTTPMethod,
                 parameters: Parameters?,
                 encoding: ParameterEncoding,
                 headers: HTTPHeaders?) -> DataRequest
}

final class UesrSession: SessionProtocol {
    private var session: Session
    init(session: Session) {
        let config = URLSessionConfiguration.default
        config.requestCachePolicy = .returnCacheDataElseLoad
        self.session = Session(configuration: config)
    }
    
    func request(_ convertible: URLConvertible,
                 method: HTTPMethod = .get,
                 parameters: Parameters? = nil,
                 encoding: ParameterEncoding = URLEncoding.default,
                 headers: HTTPHeaders? = nil) -> DataRequest {
        return session.request(convertible, method: method, parameters: parameters, encoding: encoding, headers: headers)
    }
}
