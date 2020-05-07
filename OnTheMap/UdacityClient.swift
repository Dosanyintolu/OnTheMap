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
      static let sessionId = ""
    }
    
    
    enum Endpoint {
        static let getSessionURL = "https://onthemap-api.udacity.com/v1/session"
        
        case getSessionIdURL
        
        
        var urlValue: String{
            switch self {
            case .getSessionIdURL: return Endpoint.getSessionURL
            }
        }
        
        var url: URL {
            return URL(string: urlValue)!
        }
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
        if error != nil {
            completionHandler(nil, error)
            return
        }
        let range = (5..<data!.count)
        let newData = data?.subdata(in: range)
        print(String(data: newData!, encoding: .utf8)!)
        
        guard let data = data else {
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
