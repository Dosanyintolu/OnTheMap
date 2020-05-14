//
//  UdacityUserDataResponse.swift
//  OnTheMap
//
//  Created by Doyinsola Osanyintolu on 5/7/20.
//  Copyright © 2020 DoyinOsanyintolu. All rights reserved.
//

import Foundation

struct UserData: Codable {
    
    let firstName: String
    let lastName: String
    let bio: String?
    let registered: Bool
    let linkedIn: String?
    let location: String?
    let key: String
    let imageUrl: String?
    let nickname: String?
    let website: String?
    let occupation: String?
    
    
    
    enum CodingKeys: String, CodingKey {
        case bio
        case registered = "_registered"
        case linkedIn = "linkedin_url"
        case imageUrl = "_image_url"
        case key
        case location
        case nickname
        case website = "website_url"
        case occupation
        case firstName = "first_name"
        case lastName = "last_name"
    }

}
