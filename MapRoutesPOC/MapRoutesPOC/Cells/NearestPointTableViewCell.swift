//
//  NearestPointTableViewCell.swift
//  RapidoMapPoc
//
//  Created by Randhir Kumar on 23/07/19.
//  Copyright © 2019 Randhir Kumar. All rights reserved.
//

import UIKit

class NearestPointTableViewCell: UITableViewCell {
    
    @IBOutlet weak private var aAddressLabel: UILabel!
    @IBOutlet weak private var aLatLongLabel: UILabel!
    @IBOutlet weak private var aContainerView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    private func setupUI() {
        aContainerView.setCornerRadius(value: 10)
    }
    
    func configCell(model: Cordinates) {
        self.aAddressLabel.text = model.name
        self.aLatLongLabel.text = "lat:\(model.lat) long:\(model.long)"
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
