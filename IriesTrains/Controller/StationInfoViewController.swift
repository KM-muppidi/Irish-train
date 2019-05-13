//
//  StationInfoViewController.swift
//  IriesTrains
//
//  Created by Kavya Muppidi Agrawal on 12/05/19.
//  Copyright © 2019 Kavya Muppidi Agrawal. All rights reserved.
//

import UIKit

enum StationInfoMenuItems: Int {
    case stationName = 0, stationNameTime, stationCode, stationCodeTime
    
    func rawValue() -> String {
        switch self {
        case .stationName:
            return "Station Name"
        case .stationNameTime:
            return "Station Name and Time"
        case .stationCode:
            return "Station Code"
        case .stationCodeTime:
            return "Station Code and Time"
        }
    }
    
    func intValue() -> Int {
        switch self {
        case .stationName:
            return 0
        case .stationNameTime:
            return 1
        case .stationCode:
            return 2
        case .stationCodeTime:
            return 3
        }
    }
    
    func getPlaceholder() -> String {
        switch self {
        case .stationName, .stationNameTime:
            return "Enter Station Name"
        case .stationCode, .stationCodeTime:
            return "Enter Station Code"
        }
    }
    func getCellTitle() -> String {
        switch self {
        case .stationName, .stationNameTime:
            return "Station Name"
        case .stationCode, .stationCodeTime:
            return "Station Code"
        }
    }
    func getCellDescription(stationDetails: StationDetails) -> String {
        switch self {
        case .stationName, .stationNameTime:
            return stationDetails.StationDesc
        case .stationCode, .stationCodeTime:
            return stationDetails.StationCode
        }
    }
    func shouldHidePickerView() -> Bool {
        switch self {
        case .stationName, .stationCode:
            return true
        case .stationNameTime, .stationCodeTime:
            return false
        }
    }
}

class StationInfoViewController: UIViewController {
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var searchResultTableView: UITableView!
    @IBOutlet weak var pickerView: UIPickerView!
    
    lazy var pickerItems = ["5 minutes", "10 minutes", "15 minutes", "30 minutes", "45 minutes", "60 minutes", "70 minutes", "80 minutes", "90 minutes"]
    lazy var stationRoot: StationRoot = {
        let station = StationRoot()
        station.delegate = self
        return station
    }()
    
    var selectedStationInfoType = StationInfoMenuItems(rawValue: 0)
    var selectedTime = "90"
    override func viewDidLoad() {
        super.viewDidLoad()
        title = selectedStationInfoType?.rawValue()
        searchBar.placeholder = selectedStationInfoType?.getPlaceholder()
        pickerView.isHidden = selectedStationInfoType?.shouldHidePickerView() ?? true
    }
}

extension StationInfoViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        stationRoot.getAllStations(stationText: searchBar.text ?? "A" )
    }
}

extension StationInfoViewController: ApiCompletionDelegate {
    func receivedAllData() {
        DispatchQueue.main.async {
            self.searchResultTableView.reloadData()
        }
    }
}

extension StationInfoViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return stationRoot.stations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "StationDetailsTableViewCell", for: indexPath) as? StationDetailsTableViewCell else {
            return UITableViewCell()
        }
        let row = stationRoot.stations[indexPath.row]
        cell.titleLabel.text = selectedStationInfoType?.getCellTitle()
        cell.descriptionLabel.text = selectedStationInfoType?.getCellDescription(stationDetails: row)
        return cell
    }
}

extension StationInfoViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "StationDetailsViewController") as? StationDetailsViewController else {return}
        vc.selectedMenuItem = .allTrain
        vc.selectedStationInfoType = selectedStationInfoType
        vc.selectedTime = selectedTime
        vc.stationDetails = stationRoot.stations[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension StationInfoViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerItems.count
    }
}

extension StationInfoViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerItems[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedTime = "\(pickerItems[row].split(separator: " ").first ?? "90")"
        pickerView.isHidden = true
    }
}
