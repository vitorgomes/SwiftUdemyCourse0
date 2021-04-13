//
//  Trailer.swift
//  TrailerFlix
//
//  Created by Vitor Gomes on 10/07/19.
//  Copyright © 2019 Vitor Gomes. All rights reserved.
//

import Foundation

struct Trailer: Codable {
    let title: String
    let url: String
    let rating: Int
    let year: Int
    let poster: String
}
