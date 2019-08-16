//
//  PlaceDataModel.swift
//  RapidoMapPoc
//
//  Created by Randhir Kumar on 23/07/19.
//  Copyright © 2019 Randhir Kumar. All rights reserved.
//

import Foundation
import GooglePlaces

struct PlaceDataModel {
    let placeId: String?
    var coordinate: CLLocationCoordinate2D?
    var latitude: Double?
    var longitude: Double?
    var placeName: String?
    var formatAddress: String?
    
    init(place: GMSPlace) {
        placeId = place.placeID
        coordinate = place.coordinate
        latitude = coordinate?.latitude
        longitude = coordinate?.longitude
        placeName = place.name
        formatAddress = place.formattedAddress
    }
    
}
