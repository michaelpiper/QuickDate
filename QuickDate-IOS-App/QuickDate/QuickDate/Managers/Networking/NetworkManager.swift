//
//  NetworkManager.swift
//  QuickDate
//
//  Created by Nazmi Yavuz on 12.01.2022.
//  Copyright © 2022 ScriptSun. All rights reserved.
//

import Foundation
import Async

/// Body parameters to post
/// - Tag: APIParameters
typealias APIParameters = [String: String]

enum NetworkError: Error {
    case fetchFailed(Error)
    case unknown
}
/// - Tag: SuccessCode
enum SuccessCode: String {
    case code
    case status
}

/// Handle JSON dictionary
/// - Tag: JSON
typealias JSON = [String: Any]

final class NetworkManager {
    
    typealias RemoteDataResult<Value> = Result<Value, RemoteDataError>
    
    // MARK: - HTTPMethods
    /// - Tag: HTTPMethod
    enum HTTPMethod: String {
        case post
        case get
    }
    static let shared = NetworkManager()
    
    private init() {}
    // MARK: - 1. Request
    // 1. Create Request
    private func createRequest(with url: URL, method: HTTPMethod, parameters: APIParameters) -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue.uppercased()
        let body = handleBody(with: parameters)
        request.httpBody = body.data(using: .utf8)
        return request
    }
    
    // MARK: - 2. Data Task
    // Fetch Data and Create Task
    /// Fetch Data and Create Task with URL
    /// - Parameters:
    ///   - url: URL value which is URL.
    ///   - method: [HTTPMethod](x-source-tag://HTTPMethod)
    ///   - parameters: [APIParameters](x-source-tag://APIParameters).
    ///   - completion: (Result<Data, NetworkError>) -> Void.
    func fetchData(with url: URL, method: HTTPMethod, parameters: APIParameters,
                         completionHandler: @escaping (Result<Data, NetworkError>) -> Void) {
        Async.main({
            let request = self.createRequest(with: url, method: method, parameters: parameters)
            
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                let dataTaskError = error.map { NetworkError.fetchFailed($0)}
                let result = Result<Data, NetworkError>(value: data, error: dataTaskError)
                completionHandler(result)
            }
            task.resume()
        })
    }
    
    /// Fetch Data and Create Task with urlString
    /// - Parameters:
    ///   - urlString: URL value which is string.
    ///   - method: [HTTPMethod](x-source-tag://HTTPMethod)
    ///   - parameters: [APIParameters](x-source-tag://APIParameters).
    ///   - completion: (Result<Data, NetworkError>) -> Void.
    func fetchData(with urlString: String, method: HTTPMethod, parameters: APIParameters,
                   completionHandler: @escaping (Result<Data, NetworkError>) -> Void) {
        Async.main({
            guard let url = URL(string: urlString) else {
                completionHandler(.failure(NetworkError.unknown)); return
            }
            let request = self.createRequest(with: url, method: method, parameters: parameters)
            
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                let dataTaskError = error.map { NetworkError.fetchFailed($0)}
                let result = Result<Data, NetworkError>(value: data, error: dataTaskError)
                completionHandler(result)
            }
            task.resume()
        })
    }
    
    // MARK: - 3. Fetch Result
    private func fetchResult(urlString: String, method: HTTPMethod, parameters: APIParameters,
                             completion: @escaping (RemoteDataResult<JSON>) -> Void) {
        guard let url = URL(string: urlString) else {
            completion(.failure(RemoteDataError.unknown)); return
        }
        
        fetchData(with: url, method: method, parameters: parameters) { result in
            let convertedResult: RemoteDataResult<JSON> = result
                .map { (data: Data) -> JSON in
                    guard let json = try? JSONSerialization.jsonObject(with: data, options: []),
                          let jsonDictionary = json as? JSON else {
                              return [:]
                          }
                    return jsonDictionary
                }
            // Transform NetworkError to SearchResultError
                .mapError { (networkError: NetworkError) -> RemoteDataError in
                    return RemoteDataError.known(networkError.localizedDescription)
                    // Handle error from lower layer
                }
            
            completion(convertedResult)
        }
    }
    
    // MARK: - 4. Fetch JSON
    // 4. Fetch JSON Data
    
    /// Generic function to fetch data from .json file which is come from server.
    ///
    /// - Parameters:
    ///   - urlString: URL value which is string.
    ///   - method: [HTTPMethod](x-source-tag://HTTPMethod)
    ///   - parameters: [APIParameters](x-source-tag://APIParameters).
    ///   - completion: (Result<[JSON](x-source-tag://JSON), Error>) -> Void.
    func fetchDataWithRequest(urlString: String,
                              method: HTTPMethod,
                              parameters: APIParameters,
                              completion: @escaping (Result<JSON, Error>) -> Void) {
        fetchResult(urlString: urlString, method: method, parameters: parameters) { result in
            
            switch result {
                
            case .failure(let error):
                completion(.failure(error))
                
            case .success(let json):
                guard let code = json["code"] as? Int else {
                    completion(.failure(RemoteDataError.unknown)); return
                }
                if code == 200 {
                    completion(.success(json))
                } else {
                    let error = json["errors"] as? JSON
                    guard let errorText = error?["error_text"] as? String else {
                        completion(.failure(RemoteDataError.unknown)); return
                    }
                    completion(.failure(RemoteDataError.known(errorText)))
                }
            }
        }
    }
    
    /// Generic function to fetch data from .json file which is come from server.
    ///
    /// - Parameters:
    ///   - urlString: URL value which is string.
    ///   - method: [HTTPMethod](x-source-tag://HTTPMethod)
    ///   - parameters: [APIParameters](x-source-tag://APIParameters).
    ///   - completion: (Result<[JSON](x-source-tag://JSON), Error>) -> Void.
    ///   - successCode: [SuccessCode](x-source-tag://SuccessCode) to handle different json keys
    func fetchDataWithRequest(urlString: String,
                              method: HTTPMethod,
                              parameters: APIParameters,
                              successCode: SuccessCode,
                              completion: @escaping (Result<JSON, Error>) -> Void) {
        
        fetchResult(urlString: urlString, method: method, parameters: parameters) { result in
            switch result {
            case .failure(let error):
                completion(.failure(error))
            case .success(let json):
                guard let code = json[successCode.rawValue] as? Int else {
                    completion(.failure(RemoteDataError.unknown)); return
                }
                if code == 200 {
                    completion(.success(json))
                } else {
                    let error = json["errors"] as? JSON
                    guard let errorText = error?["error_text"] as? String else {
                        completion(.failure(RemoteDataError.unknown)); return
                    }
                    completion(.failure(RemoteDataError.known(errorText)))
                }
            }
        }
    }
    
    // MARK: - Parameters
    
    /// Creates a percent-escaped, URL encoded query string components from the given key-value pair recursively.
    ///
    /// - Parameters:
    ///   - key:   Key of the query component.
    ///   - value: Value of the query component.
    ///
    /// - Returns: The percent-escaped, URL encoded query string components.
    private func queryComponents(from dictionary: APIParameters) -> [(String, String)] {
        return dictionary.map { (escape($0.key), escape("\($0.value)")) }
    }
    
    /// Creates a percent-escaped string following RFC 3986 for a query string key or value.
    ///
    /// - Parameter string: `String` to be percent-escaped.
    ///
    /// - Returns:          The percent-escaped `String`.
    public func escape(_ string: String) -> String {
        string.addingPercentEncoding(withAllowedCharacters: .afURLQueryAllowed) ?? string
    }
    
    private func handleBody(with parameters: APIParameters) -> String {
        return queryComponents(from: parameters).map { "\($0)=\($1)" }.joined(separator: "&")
    }
    
}

// MARK: - CharacterSet
extension CharacterSet {
    /// Creates a CharacterSet from RFC 3986 allowed characters.
    ///
    /// RFC 3986 states that the following characters are "reserved" characters.
    ///
    /// - General Delimiters: ":", "#", "[", "]", "@", "?", "/"
    /// - Sub-Delimiters: "!", "$", "&", "'", "(", ")", "*", "+", ",", ";", "="
    ///
    /// In RFC 3986 - Section 3.4, it states that the "?" and "/" characters should not be escaped to allow
    /// query strings to include a URL. Therefore, all "reserved" characters with the exception of "?" and "/"
    /// should be percent-escaped in the query string.
    public static let afURLQueryAllowed: CharacterSet = {
        let generalDelimitersToEncode = ":#[]@" // does not include "?" or "/" due to RFC 3986 - Section 3.4
        let subDelimitersToEncode = "!$&'()*+,;="
        let encodableDelimiters = CharacterSet(charactersIn: "\(generalDelimitersToEncode)\(subDelimitersToEncode)")

        return CharacterSet.urlQueryAllowed.subtracting(encodableDelimiters)
    }()
}

// MARK: - Swift.Result
extension Swift.Result {
      // ... snip
    init(value: Success?, error: Failure?) {
        if let error = error {
            self = .failure(error)
        } else if let value = value {
            self = .success(value)
        } else {
            fatalError("Could not create Result")
        }
    }
}
