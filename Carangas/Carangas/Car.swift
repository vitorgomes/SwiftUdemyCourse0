//
//  Car.swift
//  Carangas
//
//  Created by Vitor Gomes on 28/07/19.
//  Copyright © 2019 Eric Brito. All rights reserved.
//

import Foundation

class Car: Codable {
    
    // Gambiarra: Colocando valores iniciais nas propriedades para nao precisar usar la na classe AddEdit
    var _id: String?
    var brand: String = ""
    var gasType: Int = 0
    var name: String = ""
    var price: Double = 0.0
    
    var gas: String {
        switch gasType {
            case 0:
                return "Flex"
            case 1:
                return "Álcool"
            default:
                return "Gasolina"
        }
    }
}

struct Brand: Codable {
    let fipe_name: String
}
