//
//  NearestPointViewController.swift
//  RapidoMapPoc
//
//  Created by Randhir Kumar on 23/07/19.
//  Copyright © 2019 Randhir Kumar. All rights reserved.
//

import UIKit

class NearestPointViewController: UIViewController {
    
    @IBOutlet weak private var aTableView: UITableView!

    var placeViewModel: PlaceViewModel?
    private var nearestViewModel: NearestPoinViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeViewModel()
        setupUI()
        registerCell()
    }
    
    private func setupUI() {
        aTableView.estimatedRowHeight = 100.0
        aTableView.rowHeight = UITableView.automaticDimension
    }
    
    private func registerCell() {
        aTableView.register(UINib(nibName: kNearestPointTVCell, bundle: nil), forCellReuseIdentifier: kNearestPointTVCell)
    }
    
    private func initializeViewModel() {
        if let viewModel = placeViewModel {
            nearestViewModel = NearestPoinViewModel(placeViewModel: viewModel)
        }
    }
    fileprivate func refreshUI() {
        DispatchQueue.main.async {
                self.aTableView.reloadData()
        }
    }
    
}

// MARK: TableView Delegate and Datasource Methods
extension NearestPointViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nearestViewModel.numberOfRow()
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: kNearestPointTVCell, for: indexPath) as! NearestPointTableViewCell
        let data = nearestViewModel.getItem(atIndex: indexPath.item)
        if let cordinate = data {
            cell.configCell(model: cordinate)
        }
        return cell
    }
}
