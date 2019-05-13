//
//  IrishAnnotation.swift
//  IriesTrains
//
//  Created by Kavya Muppidi Agrawal on 12/05/19.
//  Copyright © 2019 Kavya Muppidi Agrawal. All rights reserved.
//

import Foundation
import MapKit

class IrishAnnotation: NSObject, MKAnnotation {
    let title: String?
    let locationName: String
    let coordinate: CLLocationCoordinate2D
    
    init(title: String, locationName: String, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.locationName = locationName
        self.coordinate = coordinate
        
        super.init()
    }
    
    var subtitle: String? {
        return locationName
    }
}
