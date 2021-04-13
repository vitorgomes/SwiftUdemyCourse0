//
//  QuotesManager.swift
//  Pensamentos
//
//  Created by Vitor Gomes on 24/05/19.
//  Copyright © 2019 Vitor Gomes. All rights reserved.
//

import Foundation

class QuotesManager {
    let quotes: [Quote]
    
    init() {
        let fileURL = Bundle.main.url(forResource: "quotes", withExtension: "json")!
        //Bundle.main.url(forResource: "quotes.json", withExtension: nil)! Outra forma de usar o Bundle
        let jsonData = try! Data(contentsOf: fileURL)
        let jsonDecoder = JSONDecoder()
        quotes = try! jsonDecoder.decode([Quote].self, from: jsonData)
    }
    
    func getRandomQuote() -> Quote {
        let index = Int(arc4random_uniform(UInt32(quotes.count)))
        return quotes[index]
    }
}
