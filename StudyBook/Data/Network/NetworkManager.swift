//
//  NetworkManager.swift
//  StudyBook
//
//  Created by geonhui Yu on 10/29/24.
//

import Foundation
import Alamofire

public class NetworkManager {
    private let headers: HTTPHeaders = {
        let header = HTTPHeader(name: "Authorization", value: "")
        return HTTPHeaders([header])
    }()
    private let session: SessionProtocol
    
    init(session: SessionProtocol) {
        self.session = session
    }
    
    func fetchData<T: Decodable>(url: String,
                               method: HTTPMethod,
                               parameters: Parameters?) async -> Result<T, NetworkError> {
        
        guard let url = URL(string: url) else {
            return .failure(.urlError)
        }
        
        let result = await session.request(url, method: method, parameters: parameters, encoding: URLEncoding.default, headers: headers).serializingData().response
        if let error = result.error {
            return .failure(.requestFailed(error.localizedDescription))
        }
        
        guard let data = result.data else {
            return .failure(.dataNil)
        }
        
        guard let response = result.response else {
            return .failure(.invalidResponse)
        }
        
        switch response.statusCode {
        case 200...300:
            do {
                let data = try JSONDecoder().decode(T.self, from: data)
                return .success(data)
            } catch {
                return .failure(.failToDecode(error.localizedDescription))
            }
            
        default: return .failure(.serverError(response.statusCode))
        }
    }
}
