//
//  Place.swift
//  QueroConhecer
//
//  Created by Vitor Gomes on 09/06/19.
//  Copyright © 2019 Vitor Gomes. All rights reserved.
//

import Foundation
import MapKit

struct Place: Codable {
    let name: String
    let latitude: CLLocationDegrees
    let longitude: CLLocationDegrees
    let address: String
    
    var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    static func getFormattedAddress(with placemark: CLPlacemark) -> String {
        var address = ""
        if let street = placemark.thoroughfare {
            address += street    //Rua
        }
        if let number = placemark.subThoroughfare {
            address += " \(number)"         //Numero
        }
        if let subLocality = placemark.subLocality {
            address += ", \(subLocality)"     //Bairro
        }
        if let city = placemark.locality {
            address += "\n\(city)"        //Cidade
        }
        if let state = placemark.administrativeArea {
            address += " - \(state)"        //Estado
        }
        if let country = placemark.country {
            address += "\n\(country)"        //Pais
        }
        
        return address
    }
}

//Definindo uma regra atraves de Equatable para comparacao de classes
extension Place: Equatable {
    //Metodo ==() precisa ser implementado, recebendo como argumento lhs que e a classe do lado esquerdo e rhs a classe que vai ser comparada do lado direito
    static func ==(lhs: Place, rhs: Place) -> Bool{
        //Aqui e definida a regra para dizer se elas sao iguais ou nao
        return lhs.latitude == rhs.latitude && lhs.longitude == rhs.longitude //Comparando se a latitude e longitude sao iguais
    }
}
