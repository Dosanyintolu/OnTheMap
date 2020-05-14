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
      static var expiration = ""
        
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
        taskPOSTRequest(url: Endpoint.getSessionIdURL.url, body: Login(udacity: UdacityLoginRequest(username: username, password: password)), response: UdacityLoginResponse.self) { (response, error) in
            if let response = response {
                Auth.sessionId = response.session.id
                Auth.userId = response.account.key
                Auth.expiration = response.session.expiration
                
                print(Auth.userId)
                DispatchQueue.main.async {
                   completionHandler(true, nil)
                }
               } else {
                DispatchQueue.main.async {
                   completionHandler(false, error)
                }
               }
           }
           
       }
    
    class func logout(completioHandler: @escaping (Bool, Error?) -> Void) {
        var request = URLRequest(url: Endpoint.getSessionIdURL.url)
        request.httpMethod = "DELETE"
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        for cookie in sharedCookieStorage.cookies! {
          if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
          request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        let body = Session(id: "\(Auth.sessionId)", expiration: "\(Auth.expiration)")
        do  {
        request.httpBody = try JSONEncoder().encode(body)
            DispatchQueue.main.async {
                completioHandler(true, nil)
            }
        } catch {
            DispatchQueue.main.async {
                print(false, error)
            }
        }
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            if error != nil {
                return
            }
        do {
          let range = (5..<data!.count)
          let newData = data!.subdata(in: range)
                _ = try JSONDecoder().decode(Session.self, from: newData)
                DispatchQueue.main.async {
                completioHandler(true, nil)
            }
            Auth.sessionId = ""
            } catch {
                DispatchQueue.main.async {
                completioHandler(false, error)
            }
            }
        }
        task.resume()
    }
    
    class func getUserData(completionHandler: @escaping (UserData?, Error?) -> Void) {
        taskGETRequest(url: Endpoint.getUserDataURL.url, response: UserData.self) { (response, error) in
            if let response = response {
                DispatchQueue.main.async {
                completionHandler(response, nil)
                }
                print(response)
            } else {
                DispatchQueue.main.async {
                completionHandler(nil, error)
                }
            }
        }
    }
    
    
    
class func taskGETRequest<Response: Decodable>(url: URL, response: Response.Type, completionHandler: @escaping (Response?, Error?) -> Void) {
           
    
    let request = URLRequest(url: url)
       let task =  URLSession.shared.dataTask(with: request) { (data, response, error) in
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
            do {
                let errorResponse = try JSONDecoder().decode(UdacityError.self, from: data)
                DispatchQueue.main.async {
                    completionHandler(nil, errorResponse as? Error)
                }
            }catch {
            DispatchQueue.main.async {
                    completionHandler(nil, error)
            }
               }
           }
       }
    task.resume()
}
    
    class func taskPOSTRequest<Request: Encodable, Response: Decodable>(url: URL, body:Request, response: Response.Type, completionHandler: @escaping (Response?, Error?) -> Void) {
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.addValue("application/json", forHTTPHeaderField: "Accept")
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    let enconder = JSONEncoder()
    do {
        request.httpBody = try enconder.encode(body)
    } catch {
        completionHandler(nil, error)
        print(error)
    }
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
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
                do {
                    let errorResponse = try JSONDecoder().decode(UdacityError.self, from: data)
                DispatchQueue.main.async {
                    completionHandler(nil, errorResponse as? Error)
                    }
                } catch {
                    DispatchQueue.main.async {
                        completionHandler(nil, error)
                    }
                }
            }
        }
    task.resume()
    }
}
