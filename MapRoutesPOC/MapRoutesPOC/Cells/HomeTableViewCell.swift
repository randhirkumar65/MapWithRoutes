//
//  HomeTableViewCell.swift
//  RapidoMapPoc
//
//  Created by Randhir Kumar on 22/07/19.
//  Copyright © 2019 Randhir Kumar. All rights reserved.
//

import UIKit

class HomeTableViewCell: UITableViewCell {

    @IBOutlet weak private var aAddressLabel: UILabel!
    @IBOutlet weak private var aContainerView: UIView!
    @IBOutlet weak private var aLatLongLabel: UILabel!
    @IBOutlet weak private var aDeleteButton: UIButton!
    
    var deleteActionClousure: (() -> Void) = { }
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    private func setupUI() {
        aDeleteButton.imageView?.contentMode = .scaleAspectFit
        aContainerView.setCornerRadius(value: 5.0)
        aContainerView.setBorder(color: .black, size: 1.0)
    }
    
    func configCell(model: PlaceDataModel) {
        self.aAddressLabel.text = model.formatAddress
        if let latVal = model.latitude,let longVal = model.longitude {
            self.aLatLongLabel.text = "lat: \(latVal) long: \(longVal)"
        }
    }
  
    @IBAction func deleteButtonAction(_ sender: UIButton) {
        deleteActionClousure()
    }
}
