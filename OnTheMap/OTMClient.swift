//
//  OTMClient.swift
//  OnTheMap
//
//  Created by Doyinsola Osanyintolu on 5/5/20.
//  Copyright © 2020 DoyinOsanyintolu. All rights reserved.
//

import Foundation


class OTMClient {
    
    struct Auth{
        static let objectId = ""
        
    }
    enum Endpoint {
        static let getLocation = "https://onthemap-api.udacity.com/v1/StudentLocation?limit=50"
        static let postLocation = "https://onthemap-api.udacity.com/v1/StudentLocation"
        static let putLocation = "https://onthemap-api.udacity.com/v1/StudentLocation/" + "\(Auth.objectId)"
        
        case getLocationURL
        case postLocationURL
        case putLocationURL
    
    var urlValue: String {
        switch self {
        case .getLocationURL: return Endpoint.getLocation
        case .postLocationURL: return Endpoint.postLocation
        case .putLocationURL: return Endpoint.putLocation
            }
        }
        
        var url: URL {
            return URL(string: urlValue)!
        }
    }
    
    
    class func getStudentLocation(completionHandler: @escaping([StudentLocation], Error?) -> Void) -> URLSessionTask{
      let task = taskGETRequest(url: Endpoint.getLocationURL.url, response: Results.self) { (response, error) in
            if let response = response {
                completionHandler(response.results, nil)
            } else {
                completionHandler([], error)
            }
        }
        return task
    }
    
   
    
   @discardableResult class func taskGETRequest<Response: Decodable>(url: URL, response: Response.Type, completionHandler: @escaping (Response?, Error?) -> Void) -> URLSessionTask {
        
    let task =  URLSession.shared.dataTask(with: url) { (data, _, error) in
        guard let data = data else {
            completionHandler(nil, error)
            return
        }
        let decoder = JSONDecoder()
        do {
            let object = try decoder.decode(Response.self, from: data)
            DispatchQueue.main.async {
                completionHandler(object, nil)
            }
        } catch {
            DispatchQueue.main.async {
                completionHandler(nil, error)
            }
        }
    }
    return task
    }


class func taskPOSTRequest<Request: Encodable, Response: Decodable>(url: URL, body:Request, response: Response.Type, completionHandler: @escaping (Response?, Error?) -> Void) {
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.addValue("application/json", forHTTPHeaderField: "Conetent-Type")
    
    let enconder = JSONEncoder()
    do {
        request.httpBody = try enconder.encode(body)
    } catch {
        completionHandler(nil, error)
    }
    
    let task = URLSession.shared.dataTask(with: request) { (data, _, error) in
        guard let data = data else {
            completionHandler(nil, error)
            return
        }
        let decoder = JSONDecoder()
        
        do {
            let object = try decoder.decode(Response.self, from: data)
            DispatchQueue.main.async {
                completionHandler(object, nil)
                
            }
        } catch {
            print(error.localizedDescription)
            DispatchQueue.main.async {
                completionHandler(nil, error)
                }
            }
        }
    task.resume()
    }
    
    class func taskPUTRequest<Request: Encodable, Response: Decodable>(url: URL, body:Request, response: Response.Type, completionHandler: @escaping (Response?, Error?) -> Void) {
    var request = URLRequest(url: url)
    request.httpMethod = "PUT"
    request.addValue("application/json", forHTTPHeaderField: "Conetent-Type")
    
    let enconder = JSONEncoder()
    do {
        request.httpBody = try enconder.encode(body)
    } catch {
        completionHandler(nil, error)
    }
    
    let task = URLSession.shared.dataTask(with: request) { (data, _, error) in
        guard let data = data else {
            completionHandler(nil, error)
            return
        }
        let decoder = JSONDecoder()
        
        do {
            let object = try decoder.decode(Response.self, from: data)
            DispatchQueue.main.async {
                completionHandler(object, nil)
                
            }
        } catch {
            print(error.localizedDescription)
            DispatchQueue.main.async {
                completionHandler(nil, error)
                }
            }
        }
    task.resume()
    }
    
}
