//
//  Quote.swift
//  Pensamentos
//
//  Created by Vitor Gomes on 24/05/19.
//  Copyright © 2019 Vitor Gomes. All rights reserved.
//

import Foundation

struct Quote: Codable { //Protocolo Codable na verdade implementa Encodable and Decodable
    let quote: String
    let author: String
    let image: String
    
    var quoteFormatted: String {
        return "“" + quote + "”"
    }
    
    var authorFormatted: String {
        return "- " + author + " -"
    }
}
