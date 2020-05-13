//
//  UdacityErrorResponse.swift
//  OnTheMap
//
//  Created by Doyinsola Osanyintolu on 5/12/20.
//  Copyright © 2020 DoyinOsanyintolu. All rights reserved.
//

import Foundation


struct UdacityError: Codable {
    let status: Int
    let error: String
}
