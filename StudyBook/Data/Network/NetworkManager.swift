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
    private lazy var apikey: String = getAPIKey()
        
    private var headers: HTTPHeaders {
        let header = HTTPHeader(name: "Authorization", value: "Bearer \(apikey)")
        return HTTPHeaders([header])
    }

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
                let decodedData = try JSONDecoder().decode(T.self, from: data)
                return .success(decodedData)
            } catch {
                return .failure(.failToDecode(error.localizedDescription))
            }
            
        default: return .failure(.serverError(response.statusCode))
        }
    }
}

extension NetworkManager {
    private func getAPIKey() -> String {
        guard let apiKey = Bundle.main.object(forInfoDictionaryKey: "API_KEY") as? String else { return "" }
        return apiKey
    }
}
