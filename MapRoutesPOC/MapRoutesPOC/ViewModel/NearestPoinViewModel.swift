//
//  NearestPoinViewModel.swift
//  RapidoMapPoc
//
//  Created by Randhir Kumar on 23/07/19.
//  Copyright © 2019 Randhir Kumar. All rights reserved.
//

import Foundation

class NearestPoinViewModel {
    
    private var viewModel: PlaceViewModel!
    private var dataSourceArray = [Cordinates]()
    
    init(placeViewModel: PlaceViewModel) {
        self.viewModel = placeViewModel
        getClosestPair()
    }
    
    private func getClosestPair() {
        var tempArr = [Cordinates]()
        if let cordinates = viewModel.getAllCordinateLocation(), let pairs = cordinates.closestPair() {
            tempArr.append(pairs.0)
            tempArr.append(pairs.1)
        }
        dataSourceArray = tempArr
    }
    
    func numberOfRow() -> Int{
        guard dataSourceArray.count > 0 else {
            return 0
        }
        return dataSourceArray.count
    }
    
    func getItem(atIndex index: Int) -> Cordinates? {
        guard index < dataSourceArray.count else {
            return nil
        }
        return dataSourceArray[index]
    }
}
