//
//  Loader.swift
//  RapidoMapPoc
//
//  Created by Randhir Kumar on 23/07/19.
//  Copyright © 2019 Randhir Kumar. All rights reserved.
//

import UIKit

class Loader: NSObject {
    
    // MARK: Show Toast
    class func showToast(message: String, onView: UIView, bottomMargin: CGFloat) {
        DispatchQueue.main.async {
            APP_DEL.window?.viewWithTag(9999)?.removeFromSuperview()
            let toastLabel = UILabel(frame: CGRect(x: 20, y: ScreenSize.SCREEN_HEIGHT - bottomMargin, width: onView.frame.size.width - 40, height: 40))
            toastLabel.tag = 9999
            toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
            toastLabel.textColor = UIColor.white
            toastLabel.textAlignment = .center
            toastLabel.font = UIFont(name: "AccordAltLight", size: 16.0)
            toastLabel.text = message
            toastLabel.alpha = 1.0
            toastLabel.layer.cornerRadius = 10
            toastLabel.numberOfLines = 0
            toastLabel.clipsToBounds = true
            APP_DEL.window?.addSubview(toastLabel)
            perform(#selector(Loader.removeToast(label:)), with: toastLabel, afterDelay: 2.0)
        }
    }
    
    @objc class func removeToast(label: UILabel) {
        label.removeFromSuperview()
    }
}
