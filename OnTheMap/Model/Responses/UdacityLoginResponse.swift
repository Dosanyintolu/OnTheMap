//
//  UdacityLoginRespone.swift
//  OnTheMap
//
//  Created by Doyinsola Osanyintolu on 5/6/20.
//  Copyright © 2020 DoyinOsanyintolu. All rights reserved.
//

import Foundation


struct UdacityLoginResponse: Codable {
    let account: Account
    let session: Session
    
    
    enum CodingKeys:String, CodingKey {
        case account
        case session
    }
}
