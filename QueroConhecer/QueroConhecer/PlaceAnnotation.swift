//
//  PlaceAnnotation.swift
//  QueroConhecer
//
//  Created by Vitor Gomes on 12/06/19.
//  Copyright © 2019 Vitor Gomes. All rights reserved.
//

import Foundation
import MapKit

class PlaceAnnotation: NSObject, MKAnnotation {
    
    enum PlaceType {
        case place
        case poi //poi = points of interest
    }
    
    var coordinate: CLLocationCoordinate2D //Obrigatorio ter quando se implementa o protocolo MKAnnotation
    var title: String?
    var subtitle: String?
    var type: PlaceType  //ENUM criado para dizer que tipo de lugar e
    var address: String?
    
    init(coordinate: CLLocationCoordinate2D, type: PlaceType) {
        self.coordinate = coordinate
        self.type = type
    }
    
}
