//
//  APIManager.swift
//  CryptoX
//
//  Created by Alpay Calalli on 06.09.23.
//

import Foundation

class APIService {
    
    func fetch<T: Decodable>(_ type: T.Type, url: URLRequest) async throws -> T {
        
        let (data, response) = try await URLSession.shared.data(for: url)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.badResponse(statusCode: response.hash)
        }
        
        guard (200...299).contains(httpResponse.statusCode) else {
            throw APIError.badResponse(statusCode: httpResponse.statusCode)
        }
        
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        do {
            let decodedItems = try decoder.decode(type, from: data)
            return decodedItems
        } catch {
            throw APIError.parsing(error as? DecodingError)
        }
    }
}

enum APIError: Error, CustomStringConvertible {
    case badURL
    case badResponse(statusCode: Int)
    case url(URLError?)
    case parsing(DecodingError?)
    case unknown
    
    var localizedDescription: String {
        // for user
        switch self {
        case .badURL, .parsing, .unknown:
            return "Something went wrong"
        case .badResponse(_):
            return "Sorry, your connection lost with our server"
        case .url(let error):
            return error?.localizedDescription ?? "Something went wrong"
        }
    }
    
    var description: String {
        // for debugging
        switch self {
        case .badURL:
            return "Invalid URL"
        case .parsing(let error):
            return "parsing error: \(error?.localizedDescription ?? "")"
        case .badResponse(statusCode: let statusCode):
            return "Bad response with \(statusCode)"
        case .url(let error):
            return error?.localizedDescription ?? "url session over"
        case .unknown:
            return "Something went wrong"
        }
    }
}
