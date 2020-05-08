//
//  Results.swift
//  OnTheMap
//
//  Created by Doyinsola Osanyintolu on 5/5/20.
//  Copyright © 2020 DoyinOsanyintolu. All rights reserved.
//

import Foundation

struct Results: Codable {
    
    let results: [StudentLocation]
    
    enum Codingkeys: String, CodingKey {
        case results
    }
}
