//
//  Const.swift
//  gglads
//
//  Created by Паша on 04.02.17.
//  Copyright © 2017 Паша. All rights reserved.
//

import Foundation
import Alamofire

let baseUrl = "https://api.producthunt.com"

let access_token = "591f99547f569b05ba7d8777e2e0824eea16c440292cce1f8dfb3952cc9937ff"

let headers: HTTPHeaders = [
    "Accept": "application/json",
    "Content-Type": "application/json",
    "Authorization": "Bearer \(access_token)",
    "Host": "api.producthunt.com"
]
