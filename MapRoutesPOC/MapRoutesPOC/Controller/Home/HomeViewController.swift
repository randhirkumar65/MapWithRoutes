//
//  HomeViewController.swift
//  RapidoMapPoc
//
//  Created by Randhir Kumar on 22/07/19.
//  Copyright © 2019 Randhir Kumar. All rights reserved.
//

import UIKit
import GooglePlaces

class HomeViewController: UIViewController {
    
    @IBOutlet weak private var aSearchLabel: UILabel!
    @IBOutlet weak private var aNearestPointButton: UIButton!
    @IBOutlet weak private var aAnimateonMaptButton: UIButton!
    @IBOutlet weak private var aTableView: UITableView!
    
    private var placeViewModel: PlaceViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        registerCell()
        initializePlaceViewModel()
        setAutomaticDimension()
    }
    
    // MARK: Setup UI
    private func setupUI() {
        aTableView.delegate = self
        aTableView.dataSource = self
        aNearestPointButton.setBorder(color: .black, size: 1.0)
        aAnimateonMaptButton.setBorder(color: .black, size: 1.0)
        aSearchLabel.sizeToFit()
    }
    
    private func setAutomaticDimension() {
        aTableView.estimatedRowHeight = 100.0
        aTableView.rowHeight = UITableView.automaticDimension
    }
    
    private func registerCell() {
        aTableView.register(UINib(nibName: kHomeCellIdentifier, bundle: nil), forCellReuseIdentifier: kHomeCellIdentifier)
    }
    
    fileprivate func refreshUI() {
        DispatchQueue.main.async {
            self.aTableView.reloadData()
        }
    }
    
    private func initializePlaceViewModel() {
        placeViewModel = PlaceViewModel()
        placeViewModel.dataReceivedClousure = { [weak self] in
            if let strongSelf = self {
                strongSelf.refreshUI()
            }
        }
        placeViewModel.dataOverFlowClousure = { [weak self] in
            if let strongSelf = self {
                let alertVc = UIAlertController(title: "Already 10 places added", message: kMaxDataReachedMessage, preferredStyle: .alert)
                let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
                alertVc.addAction(ok)
                strongSelf.present(alertVc, animated: true, completion: nil)
            }
        }
    }
    
    private func deletePlace(index: Int) {
        let alertVC = UIAlertController(title: "Delete", message: "Do you want to delete this place?", preferredStyle: .alert)
        let yesAction = UIAlertAction(title: "Delete", style: .destructive) { (_) in
            self.placeViewModel.deleteItem(atIndex: index)
        }
        let noAction = UIAlertAction(title: "Cancel", style: .default)
        alertVC.addAction(yesAction)
        alertVC.addAction(noAction)
        self.present(alertVC, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == ksearchToNearestSegue {
            if let dest = segue.destination as? NearestPointViewController {
                dest.placeViewModel = placeViewModel
            }
        } else if segue.identifier == ksearchToMapSegue {
            if let dest = segue.destination as? AnimateOnMapViewController, let array = placeViewModel.getAllCordinateLocation2d()  {
                dest.cordinateArray = array
            }
        }
    }
    
    // MARK: Search Placesx
    @IBAction func searchButtonAction(_ sender: UIButton) {
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
        UISearchBar.appearance().barStyle = UIBarStyle.default
        UISearchBar.appearance().tintColor = .orange
        present(autocompleteController, animated: true, completion: nil)
    }
    
    // MARK: Nearest Point among all the location added by user
    @IBAction func nearestButtonAction(_ sender: UIButton) {
        if placeViewModel.numberOfRows() > 1 {
            performSegue(withIdentifier: ksearchToNearestSegue, sender: nil)
        } else {
            Loader.showToast(message: "Please add any place", onView: self.view, bottomMargin: 200)
        }
    }
    
    @IBAction func animateOnMapButtonAction(_ sender: UIButton) {
        if placeViewModel.numberOfRows() > 1 {
            performSegue(withIdentifier: ksearchToMapSegue, sender: nil)
        } else {
            Loader.showToast(message: "Please add any place", onView: self.view, bottomMargin: 200)
        }
    }
}

// MARK: TableView Delegate and Datasource Methods
extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return placeViewModel.numberOfRows()
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: kHomeCellIdentifier, for: indexPath) as! HomeTableViewCell
        let modelData = placeViewModel.getItem(atIndex: indexPath.row)
        if let data = modelData {
            cell.configCell(model: data)
        }
        
        cell.deleteActionClousure = { [weak self] in
            if let strongSelf = self {
                strongSelf.deletePlace(index: indexPath.row)
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            deletePlace(index: indexPath.row)
        }
    }
}

// MARK: TextFied Delegate Method
extension HomeViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return true
    }
}

// MARK: Google Place Delegate Methods
extension HomeViewController: GMSAutocompleteViewControllerDelegate {
    
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        dismiss(animated: true) {
            
        }
        placeViewModel.setPlaceViewModel(place: place)
        //        aSearchLabel.text = "\(place.formattedAddress ?? "") "
        aSearchLabel.text = "Type a landmark name"
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        // TODO: handle the error.
        print("Error: ", error.localizedDescription)
    }
    
    // User canceled the operation.
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
}
