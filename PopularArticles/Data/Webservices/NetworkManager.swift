//
//  ConnectionManager.swift
//  PopularArticles
//
//  Created by Nuzhat Zari on 08/09/20.
//  Copyright © 2020 Nuzhat Zari. All rights reserved.
//

import UIKit

var APIKEY = "015LPo0E1fX4CLcGGM0txNkexg9HZ4Jy"

//APPError enum which shows all possible errors
enum APPError: Error {
    case networkError(Error)
    case dataNotFound
    case jsonParsingError(Error)
    case invalidStatusCode(Int)
}

//Result enum to show success or failure
enum APIResult<T> {
    case success(T)
    case failure(APPError)
}

class Response<T: Decodable>: Decodable {
    let status: String
    let copyright: String
    let num_results: Int
    let results: T
}

protocol NetworkManager {

    var baseUrl: String { get set }
    var route: String { get set }
    var method: String { get set }
    var body: [String: Any]? { get set }
    var headers: [String: String] { get set }
    
    func fetchData<T: Decodable>(objectType: T.Type, completion: @escaping (APIResult<T>) -> Void)

}

extension NetworkManager {
    
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

    func fetchData<T: Decodable>(objectType: T.Type, completion: @escaping (APIResult<T>) -> Void) {
        
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
                completion(.failure(APPError.networkError(error)))
                return
            }

            if data == nil  {
                let defaultError = NSError(domain: "NetworkingErrorDomain", code: 1001, userInfo: [
                    NSLocalizedDescriptionKey: NSLocalizedString("Something went wrong.", comment: "")
                ])
                
                if let error = error {
                    completion(.failure(APPError.networkError(error)))
                } else {
                    completion(.failure(APPError.networkError(defaultError)))
                }

            } else {
                /*do {
                    let jsonData = try JSONSerialization.jsonObject(with: data!, options: []) as? [String: Any]
                    completion(jsonData, nil)
                } catch let error as NSError {
                    completion(nil, error)
                }*/
                
                do {
                    //create decodable object from data
                    let json = try JSONDecoder().decode(Response<T>.self, from: data!)
                    if json.status.caseInsensitiveCompare("OK") == ComparisonResult.orderedSame {
                        completion(.success(json.results))
                    }else {
                        let error = "Something went wrong, please try again later."
                        completion(.failure(APPError.jsonParsingError(error as! Error)))
                    }
                } catch let error as NSError {
                    completion(.failure(APPError.networkError(error)))
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
