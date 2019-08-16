//
//  Extensions.swift
//  RapidoMapPoc
//
//  Created by Randhir Kumar on 22/07/19.
//  Copyright © 2019 Randhir Kumar. All rights reserved.
//

import Foundation
import UIKit

struct Cordinates {
    var lat: Double
    var long: Double
    var name: String
    
    func distance(to p: Cordinates) -> Double {
        let x = pow(p.lat - self.lat, 2)
        let y = pow(p.long - self.long, 2)
        
        return (x + y).squareRoot()
    }
}

// MARK: Extension UIView
extension UIView {
    
    // MARK: Load Nib from bundle
    class func loadNib<T: UIView>() -> T {
        return Bundle.main.loadNibNamed(String(describing: T.self), owner: nil, options: nil)!.first as! T
    }
    
    func setCornerRadius(value: CGFloat) {
        layer.masksToBounds = true
        layer.cornerRadius = value
    }
    
    func setBorder(color: UIColor, size: CGFloat) {
        layer.borderWidth = size
        layer.borderColor = color.cgColor
    }
}

// MARK: Extension Collection
extension Collection where Element == Cordinates {
    func closestPair() -> (Cordinates, Cordinates)? {
        let (xP, xY) = (sorted(by: { $0.lat < $1.lat }), sorted(by: { $0.long < $1.long }))
        return Self.closestPair(xP, xY)?.1
    }
    
    static func closestPair(_ xP: [Element], _ yP: [Element]) -> (Double, (Cordinates, Cordinates))? {
        guard xP.count > 3 else { return xP.closestPairBruteForce() }
        
        let half = xP.count / 2
        let xl = Array(xP[..<half])
        let xr = Array(xP[half...])
        let xm = xl.last!.lat
        let (yl, yr) = yP.reduce(into: ([Element](), [Element]()), {cur, el in
            if el.lat > xm {
                cur.1.append(el)
            } else {
                cur.0.append(el)
            }
        })
        
        guard let (distanceL, pairL) = closestPair(xl, yl) else { return nil }
        guard let (distanceR, pairR) = closestPair(xr, yr) else { return nil }
        
        let (dMin, pairMin) = distanceL > distanceR ? (distanceR, pairR) : (distanceL, pairL)
        
        let ys = yP.filter({ abs(xm - $0.lat) < dMin })
        
        var (closest, pairClosest) = (dMin, pairMin)
        
        for i in 0..<ys.count {
            let p1 = ys[i]
            
            for k in i+1..<ys.count {
                let p2 = ys[k]
                
                guard abs(p2.long - p1.long) < dMin else { break }
                
                let distance = abs(p1.distance(to: p2))
                
                if distance < closest {
                    print(i,closest,pairClosest)
                    print("closest \(i) k \(k)")
                    (closest, pairClosest) = (distance, (p1, p2))
                }
            }
        }
        
        return (closest, pairClosest)
    }
    
    func closestPairBruteForce() -> (Double, (Cordinates, Cordinates))? {
        guard count >= 2 else { return nil }
        
        var closestPoints = (self.first!, self[index(after: startIndex)])
        var minDistance = abs(closestPoints.0.distance(to: closestPoints.1))
        
        guard count != 2 else { return (minDistance, closestPoints) }
        
        for i in 0..<count {
            for j in i+1..<count {
                let (iIndex, jIndex) = (index(startIndex, offsetBy: i), index(startIndex, offsetBy: j))
                let (p1, p2) = (self[iIndex], self[jIndex])
                
                let distance = abs(p1.distance(to: p2))
                
                if distance < minDistance {
                    minDistance = distance
                    closestPoints = (p1, p2)
                }
            }
        }
        return (minDistance, closestPoints)
    }
}
