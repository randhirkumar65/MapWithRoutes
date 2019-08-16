//
//  AnimateOnMapViewController.swift
//  RapidoMapPoc
//
//  Created by Randhir Kumar on 23/07/19.
//  Copyright © 2019 Randhir Kumar. All rights reserved.
//

import UIKit
import GoogleMaps
import Alamofire

class AnimateOnMapViewController: UIViewController {
    
    @IBOutlet weak private var aMapView: GMSMapView!
    
    var cordinateArray = [CLLocationCoordinate2D]()
    private var polyline = GMSPolyline()
    private var animationPolyline = GMSPolyline()
    private var path = GMSPath()
    private var animationPath = GMSMutablePath()
    private var i: UInt = 0
    private var timer: Timer?
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setCameraPosition()
        changeMapStyle()
        
//                drawRoute()
        // MARK: Comment this line and enable drawRoute() for plotting coordinates among the places.
        // This method will draw Direction routes
        drawpath(coordArray: cordinateArray)
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        stopAnimatePolylinePath()
    }
    
    fileprivate func setCameraPosition() {
        var bounds = GMSCoordinateBounds()
        for cordinates in cordinateArray {
            bounds = bounds.includingCoordinate(cordinates)
        }
        let update = GMSCameraUpdate.fit(bounds, withPadding: 60)
        aMapView.animate(with: update)
    }
    
    fileprivate func changeMapStyle() {
        do {
            if let styleURL = Bundle.main.url(forResource: "Style", withExtension: "json") {
                aMapView.mapStyle = try GMSMapStyle(contentsOfFileURL: styleURL)
            } else {
                NSLog("Unable to find style.json")
            }
        } catch {
            NSLog("One or more of the map styles failed to load. \(error)")
        }
    }
    
    func drawRoute() {
        if cordinateArray.count > 0 {
            cordinateArray.reverse()
            let path = GMSMutablePath()
            
            for coord in cordinateArray {
                let gmsMarker = GMSMarker(position: coord)
                gmsMarker.map = aMapView
                gmsMarker.icon = UIImage(named: "whiteCircle")
                gmsMarker.groundAnchor = CGPoint(x: 0.5, y: 0.5)
                path.add(coord)
            }
            self.path = GMSPath(path: path)
            self.polyline.path = path
            self.polyline.strokeColor = UIColor.lightGray
            self.polyline.strokeWidth = 3.0
            self.polyline.map = self.aMapView
            self.timer = Timer.scheduledTimer(timeInterval: 0.8, target: self, selector: #selector(animatePolylinePath), userInfo: nil, repeats: true)
        }
    }
    
    @objc func animatePolylinePath() {
        if (self.i < self.path.count()) {
            self.animationPath.add(self.path.coordinate(at: self.i))
            self.animationPolyline.path = self.animationPath
            self.animationPolyline.strokeColor = UIColor.green
            self.animationPolyline.strokeWidth = 3
            self.animationPolyline.map = self.aMapView
            self.i += 1
        } else {
//            self.i = 0
//            self.animationPath = GMSMutablePath()
//            self.animationPolyline.map = nil
            stopAnimatePolylinePath()
        }
    }
    
    func stopAnimatePolylinePath() {
        if let timer = timer {
            timer.invalidate()
        }
    }
    
    func drawpath(coordArray: [CLLocationCoordinate2D]) {
        guard let firstOrigin = coordArray.first, let destOrigin = coordArray.last else { return }
        var wayPoints = ""
        let origin = firstOrigin
        let destination = destOrigin
        
        for coord in coordArray {
            wayPoints = wayPoints.count == 0 ? "\(coord.latitude),\(coord.longitude)" : "\(wayPoints)%7C\(coord.latitude),\(coord.longitude)"
        }
        
        let url = "https://maps.googleapis.com/maps/api/directions/json?origin=\(origin.latitude),\(origin.longitude)&destination=\(destination.latitude),\(destination.longitude)&mode=driving&waypoints=\(wayPoints)&key=\(kgoogleAPIkey)"
        
        Alamofire.request(url).responseJSON { response in
            do {
                guard let data = response.data else {
                    return
                }
                if let json : [String:Any] = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] {
                    guard let routes = json["routes"] as? NSArray else {
                        return
                    }
                    if (routes.count > 0) {
                        let overview_polyline = routes[0] as? NSDictionary
                        let dictPolyline = overview_polyline?["overview_polyline"] as? NSDictionary
                        let points = dictPolyline?.object(forKey: "points") as? String
                        let path = GMSPath.init(fromEncodedPath: points ?? "")
                        let polyline = GMSPolyline.init(path: path)
                        if let path = path {
                            self.path = path
                        }
                        polyline.strokeWidth = 3
                        polyline.strokeColor = UIColor.lightGray
                        polyline.map = self.aMapView
                        self.timer = Timer.scheduledTimer(timeInterval: 0.003, target: self, selector: #selector(self.animatePolylinePath), userInfo: nil, repeats: true)
                    }
                }
            } catch {
                print("Exception occur while making request to Direction API")
            }
        }
    }
}
