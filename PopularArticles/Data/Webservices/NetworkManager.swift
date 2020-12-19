//
//  ConnectionManager.swift
//  PopularArticles
//
//  Created by Nuzhat Zari on 08/09/20.
//  Copyright © 2020 Nuzhat Zari. All rights reserved.
//

import UIKit

public typealias JSONTaskCompletion = (_ data: [String: Any]?, _ error: NSError?) -> Void
var APIKEY = "015LPo0E1fX4CLcGGM0txNkexg9HZ4Jy"

public protocol NetworkManager {

    var baseUrl: String { get set }
    var route: String { get set }
    var method: String { get set }
    var body: [String: Any]? { get set }
    var headers: [String: String] { get set }
    
    func JSONTaskWithRequest(completion: @escaping JSONTaskCompletion) -> URLSessionDataTask
    func fetchData<T>(parse: @escaping (Any) -> T?, completion: @escaping (Result<T, Error>) -> Void)

}

public extension NetworkManager {
    
    var baseUrl: String {
        get { return Bundle.main.apiBaseURL } set {}
    }
    var headers: [String: String] {
        get { return [:] } set {}
    }
    var route: String {
        get { return "" } set {}
    }
    var method: String {
        get { return "GET" } set {}
    }
    var body: [String : Any]? {
        get { return [:] } set {}
    }
    
    
    func JSONTaskWithRequest(completion: @escaping JSONTaskCompletion) -> URLSessionDataTask {
        
        let url = URL(string: "\(baseUrl.replacingOccurrences(of: "ROUTE", with: route).replacingOccurrences(of: "APIKEY", with: APIKEY))")!
        let urlRequest = NSMutableURLRequest(url: url)

        var jsonData: Data? = nil
        if let requestBody = body, let jsonBody = try? JSONSerialization.data(withJSONObject: requestBody, options: []) {
            jsonData = jsonBody
        }
        
        urlRequest.httpMethod = method
        switch method {
        case "GET":
            break
        default:
            if (jsonData != nil) {
                urlRequest.httpBody = jsonData
            }
        }
        
        for (key, value) in headers {
            urlRequest.setValue(value, forHTTPHeaderField:key)
        }
        urlRequest.setValue("application/json", forHTTPHeaderField: "content-type")
        urlRequest.setValue("application/json", forHTTPHeaderField: "Accept")
        
        let task = URLSession.shared.dataTask(with: urlRequest as URLRequest) { data, response, error in

            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {

                let userInfo = [
                    NSLocalizedDescriptionKey: NSLocalizedString("Error with the response: unexpected status code", comment: "")
                ]
                let error = NSError(domain: "NetworkingErrorDomain", code: 1001, userInfo: userInfo)
                completion(nil, error)
                return
            }

            if data == nil  {
                let defaultError = NSError(domain: "NetworkingErrorDomain", code: 1001, userInfo: [
                    NSLocalizedDescriptionKey: NSLocalizedString("Something went wrong.", comment: "")
                ])
                
                if let error = error {
                    completion(nil, error as NSError?)
                } else {
                    completion(nil, defaultError)
                }

            } else {
                do {
                    let jsonData = try JSONSerialization.jsonObject(with: data!, options: []) as? [String: Any]
                    completion(jsonData, nil)
                } catch let error as NSError {
                    completion(nil, error)
                }
            }
        }
        return task
    }

    func fetchData<T>(parse: @escaping (Any) -> T?, completion: @escaping (Result<T, Error>) -> Void) {
        
        let task = JSONTaskWithRequest { json, error in
            DispatchQueue.main.async {
            guard let json = json else {
                if let error = error {
                    completion(.failure(error))
                } else {
                    let error = "Something went wrong."
                    completion(.failure(error as! Error))
                }
                return
            }
                if let status = json["status"] as? String, status.caseInsensitiveCompare("OK") == ComparisonResult.orderedSame {
                    if let results = json["results"], let value = parse(results) {
                        completion(.success(value))
                    } else {
                        let error = "Something went wrong."
                        completion(.failure(error as! Error))
                    }
                }else {
                    let error = "Something went wrong."
                    completion(.failure(error as! Error))
                }
        }
        }

        task.resume()
    }
    
}

extension Bundle {
    var apiBaseURL: String {
        return object(forInfoDictionaryKey: "serverBaseURL") as? String ?? ""
    }
}
