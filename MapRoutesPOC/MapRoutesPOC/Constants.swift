//
//  Constants.swift
//  RapidoMapPoc
//
//  Created by Randhir Kumar on 22/07/19.
//  Copyright © 2019 Randhir Kumar. All rights reserved.
//

import Foundation
import UIKit

// MARK: StoryBoard & Cell Identifiers
let kHomeVC = "HomeViewController"
let kHomeCellIdentifier = "HomeTableViewCell"
let kSearchSuggestionCellIdentifier = "SearchSuggestionTVCell"
let kNearestPointVC = "NearestPointViewController"
let kNearestPointTVCell = "NearestPointTableViewCell"
let ksearchToNearestSegue = "searchToNearestVC"
let ksearchToMapSegue = "searchToMapVC"
let kAnimateOnMapViewController = "AnimateOnMapViewController"

// MARK: Constants
let kSearchPlaceholder = "Type a landmark name"
#error("Please add your Google API key")
let kgoogleAPIkey = "@add your APIKey here"
let kMaxRowCount = 10
let kMaxDataReachedMessage = "Please delete any places"

// MARK: Screen Size
struct ScreenSize {
    static let SCREEN_WIDTH = UIScreen.main.bounds.size.width
    static let SCREEN_HEIGHT = UIScreen.main.bounds.size.height
    static let SCREEN_MAX_LENGTH = max(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
    static let SCREEN_MIN_LENGTH = min(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
}
