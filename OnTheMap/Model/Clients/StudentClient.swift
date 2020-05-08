//
//  StudentClient.swift
//  OnTheMap
//
//  Created by Doyinsola Osanyintolu on 5/5/20.
//  Copyright © 2020 DoyinOsanyintolu. All rights reserved.
//

import Foundation


class StudentClient {
    
   static var postLocation: StudentLocation!
    
    
    struct Auth{
        static var objectId = ""
        static var sessionId = ""
        
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
    
    class func postStudentLocation(completionHandler: @escaping (Bool, Error?) -> Void){
        taskPOSTRequest(url: Endpoint.postLocationURL.url, body: LocationRequest(uniqueKey: postLocation.uniqueKey , firstName: postLocation.firstName, lastName: postLocation.lastName, mapString: postLocation.mapString, mediaURL: postLocation.mediaURL, latitude: postLocation.latitude, longitude: postLocation.longitude), response: LocationResponse.self) { (response, error) in
            if let response = response {
                Auth.objectId = response.objectId
                completionHandler(true, nil)
            }else {
                completionHandler(false, error)
            }
        }
    }
    
    class func overwriteStudentLocation(completionHandler: @escaping (Bool, Error?) -> Void) {
        taskPUTRequest(url: Endpoint.putLocationURL.url, body: LocationRequest(uniqueKey: postLocation.uniqueKey , firstName: postLocation.firstName, lastName: postLocation.lastName, mapString: postLocation.mapString, mediaURL: postLocation.mediaURL, latitude: postLocation.latitude, longitude: postLocation.longitude), response: PutResponse.self) { (response, error) in
            
            if let response = response {
                print(response)
                completionHandler(true, nil)
            } else {
                completionHandler(false, error)
            }
        }
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
            let object = try decoder.decode(response.self, from: data)
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
