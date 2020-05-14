//
//  StudentClient.swift
//  OnTheMap
//
//  Created by Doyinsola Osanyintolu on 5/5/20.
//  Copyright © 2020 DoyinOsanyintolu. All rights reserved.
//

import Foundation


class ParseClient {
    
   static var postLocation: StudentLocation!
    
    
    struct Auth{
        static var objectId = ""
        static var sessionId = ""
        static var createdAt = ""
        
    }
    enum Endpoint {
        static let getLocation = "https://onthemap-api.udacity.com/v1/StudentLocation?order=-updatedAt"
        static let postLocation = "https://onthemap-api.udacity.com/v1/StudentLocation"
        static let putLocation = "https://onthemap-api.udacity.com/v1/StudentLocation/" + "\(Auth.objectId)"
        static let udacity = "https://www.udacity.com"
        
        case getLocationURL
        case postLocationURL
        case putLocationURL
        case udacityURL
    
    var urlValue: String {
        switch self {
        case .getLocationURL: return Endpoint.getLocation
        case .postLocationURL: return Endpoint.postLocation
        case .putLocationURL: return Endpoint.putLocation
        case .udacityURL: return Endpoint.udacity
            }
        }
        
        var url: URL {
            return URL(string: urlValue)!
        }
    }
    
    
    class func getStudentLocation(completionHandler: @escaping([StudentLocation], Error?) -> Void) {
      taskGETRequest(url: Endpoint.getLocationURL.url, response: Results.self) { (response, error) in
            if let response = response {
                completionHandler(response.results, nil)
                
            } else {
                completionHandler([], error)
            }
        }
    }
    
    class func postStudentLocation(uniquekey: String, firstName: String, lastName: String, mapString: String, mediaURL: String, latitude: Double, longitude: Double, completionHandler: @escaping (Bool, Error?) -> Void){
        taskPOSTRequest(url: Endpoint.postLocationURL.url, body: LocationRequest(uniqueKey: uniquekey, firstName: firstName, lastName: lastName, mapString: mapString, mediaURL: mediaURL, latitude: latitude, longitude: longitude), response: LocationResponse.self) { (response, error) in
            if let response = response {
                Auth.objectId = response.objectId
                Auth.createdAt = response.createdAt
                print("\(Auth.objectId)  ,\(Auth.createdAt)")
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
   
    
class func taskGETRequest<Response: Decodable>(url: URL, response: Response.Type, completionHandler: @escaping (Response?, Error?) -> Void) {
        
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
    task.resume()
    }


class func taskPOSTRequest<Request: Encodable, Response: Decodable>(url: URL, body:Request, response: Response.Type, completionHandler: @escaping (Response?, Error?) -> Void) {
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    
    let enconder = JSONEncoder()
    do {
        request.httpBody = try enconder.encode(body)
    } catch {
        DispatchQueue.main.async {
            completionHandler(nil, error)
        }
    }
    
    let task = URLSession.shared.dataTask(with: request) { (data, _, error) in
        guard let data = data else {
            DispatchQueue.main.async {
                completionHandler(nil, error)
        }
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
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    
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
