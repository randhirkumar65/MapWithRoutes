//
//  PlaceViewModel.swift
//  RapidoMapPoc
//
//  Created by Randhir Kumar on 23/07/19.
//  Copyright © 2019 Randhir Kumar. All rights reserved.
//

import Foundation
import GooglePlaces

class PlaceViewModel {
    
    var dataReceivedClousure: (() -> Void) = { }
    var dataOverFlowClousure: (() -> Void) = { }
    
    private var dataSourceArray = [PlaceDataModel]() {
        didSet {
            dataReceivedClousure()
        }
    }
    
    func setPlaceViewModel(place: GMSPlace) {
        guard dataSourceArray.count < kMaxRowCount else {
            dataOverFlowClousure()
            return
        }
        dataSourceArray.insert(PlaceDataModel(place: place), at: 0)
    }
    
    func numberOfRows() -> Int {
        guard dataSourceArray.count < kMaxRowCount else {
            return kMaxRowCount
        }
        return dataSourceArray.count
    }
    func getItem(atIndex index: Int) -> PlaceDataModel? {
        guard index < dataSourceArray.count else {
            return nil
        }
        return dataSourceArray[index]
    }
    func deleteItem(atIndex index: Int) {
        guard index < dataSourceArray.count else {
            return
        }
        dataSourceArray.remove(at: index)
    }
    func getAllCordinateLocation() -> [Cordinates]? {
        var cordinateArray = [Cordinates]()
        guard dataSourceArray.count > 0 else {
            return nil
        }
        for data in dataSourceArray {
            if let cord = data.coordinate {
                cordinateArray.append(Cordinates(lat: cord.latitude, long: cord.longitude, name: data.placeName ?? ""))
            }
        }
        return cordinateArray
    }
    
    func getAllCordinateLocation2d() -> [CLLocationCoordinate2D]? {
        var cordinateArray = [CLLocationCoordinate2D]()
        guard dataSourceArray.count > 0 else {
            return nil
        }
        for data in dataSourceArray {
            if let cord = data.coordinate {
                cordinateArray.append(cord)
            }
        }
        return cordinateArray
    }
}
