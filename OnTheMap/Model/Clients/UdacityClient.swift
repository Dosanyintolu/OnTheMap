//
//  UdacityClient.swift
//  OnTheMap
//
//  Created by Doyinsola Osanyintolu on 5/7/20.
//  Copyright © 2020 DoyinOsanyintolu. All rights reserved.
//

import Foundation


class UdacityClient {
    
    struct Auth {
      static var sessionId = ""
      static var userId = ""
        
    }
    
    
    enum Endpoint {
        static let sessionURL = "https://onthemap-api.udacity.com/v1/session"
        static let studentLocationURL = "https://onthemap-api.udacity.com/v1/StudentLocation"
        static let userdataURL = "https://onthemap-api.udacity.com/v1/users/\(Auth.userId)"
        
        case getSessionIdURL
        case getStudentLocationURL
        case getUserDataURL
        
        var urlValue: String{
            switch self {
            case .getSessionIdURL: return Endpoint.sessionURL
            case .getStudentLocationURL: return Endpoint.studentLocationURL
            case .getUserDataURL: return Endpoint.userdataURL
            }
        }
        
        var url: URL {
            return URL(string: urlValue)!
        }
    }
    
    
    class func login(username: String, password: String, completionHandler: @escaping (Bool, Error?) -> Void) {
           taskPOSTRequest(url: Endpoint.getStudentLocationURL.url, body: Login(udacity: UdacityLoginRequest(username: username, password: password)), response: UdacityLoginResponse.self) { (response, error) in
               if let response = response {
                Auth.sessionId = response.session.id
                Auth.userId = response.account.key
                   completionHandler(true, nil)
               } else {
                   completionHandler(false, error)
               }
           }
           
       }
    
    class func logout(completioHandler: @escaping (Bool, Error?) -> Void) {
        taskDELETErequest(url: Endpoint.getSessionIdURL.url, response: Session.self) { (_, error) in
            if error != nil {
                print(error?.localizedDescription ?? "Something went wrong")
            } else {
                 Auth.sessionId = ""
                 completioHandler(true, nil)
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
                let range = (5..<data.count)
                let newData = data.subdata(in: range)
               let object = try decoder.decode(Response.self, from: newData)
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
    request.addValue("application/json", forHTTPHeaderField: "Accept")
    request.addValue("application/json", forHTTPHeaderField: "Conetent-Type")
    
    
    let enconder = JSONEncoder()
    do {
        request.httpBody = try enconder.encode(body)
    } catch {
        completionHandler(nil, error)
    }
    
    let task = URLSession.shared.dataTask(with: request) { (data, _, error) in
        guard let data = data else {
            return
        }
        
        let decoder = JSONDecoder()
        do {
            let range = (5..<data.count)
            let newData = data.subdata(in: range)
            let object = try decoder.decode(Response.self, from: newData)
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
    
    class func taskDELETErequest<Response: Decodable>(url: URL, response: Response.Type, completionHandler: @escaping (Data?, Error?) -> Void) {
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        for cookie in sharedCookieStorage.cookies! {
          if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
          request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
          if error != nil {
            completionHandler(nil, error)
              return
          }
          let range = (5..<data!.count)
          let newData = data?.subdata(in: range)
          print(String(data: newData!, encoding: .utf8)!)
        }
        task.resume()
    }
    
}
