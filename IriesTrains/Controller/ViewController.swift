//
//  ViewController.swift
//  IriesTrains
//
//  Created by Kavya Muppidi Agrawal on 11/05/19.
//  Copyright © 2019 Kavya Muppidi Agrawal. All rights reserved.
//

import UIKit

enum MenuItems: Int {
    case allTrain = 0, currentTrain, stationInformation, trainMovement
    
    func rawValue() -> String {
        switch self {
        case .allTrain:
            return "All Stations"
        case .currentTrain:
            return "Current Train"
        case .stationInformation:
            return "Station Information"
        case .trainMovement:
            return "Train Movement"
        }
    }
    
    func intValue() -> Int {
        switch self {
        case .allTrain:
            return 0
        case .currentTrain:
            return 1
        case .stationInformation:
            return 2
        case .trainMovement:
            return 3
        }
    }
    
    func getRows() -> [String] {
        switch self {
        case .allTrain, .currentTrain:
            return ["All", "Mainline", "Suburban", "DART"]
        case .stationInformation:
            return ["Name for next 90 minutes", "Name and Minutes", "Code for next 90 minutes", "Code and Minutes"]
        case .trainMovement:
            return ["Train ID", "Train Date"]
        }
    }
}

class ViewController: UIViewController {
    @IBOutlet weak var irishRailsTableView: UITableView!
    var menuItems: [MenuItems] = [.allTrain, .currentTrain, .stationInformation, .trainMovement]
    var selectedSection: MenuItems? = nil
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Irish Rails"
    }
}

extension ViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return menuItems.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let rows = selectedSection?.getRows()
        let rowsCount = MenuItems(rawValue: section) == selectedSection ? (rows?.count ?? 0) : 0
        return rowsCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let rows = menuItems[indexPath.section].getRows()
        let row = rows[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCellID", for: indexPath)
        cell.textLabel?.text = row
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UINib(nibName: "IrishRailsSectionView", bundle: nil).instantiate(withOwner: self, options: nil).first as? IrishRailsSectionView
        headerView?.tag = section
        headerView?.delegate = self
        let sectionTitle = menuItems[section].rawValue()
        headerView?.sectionTitle.text = sectionTitle
        
        if MenuItems(rawValue: section) == selectedSection {
            headerView?.arrowButton.setImage(#imageLiteral(resourceName: "upArrow"), for: .normal)
        } else {
            headerView?.arrowButton.setImage(#imageLiteral(resourceName: "downArrow"), for: .normal)
        }
        return headerView
    }
    
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let selectedSection = selectedSection else { return }
        let row = selectedSection.getRows()[indexPath.row]
        switch selectedSection {
        case .allTrain, .currentTrain:
            guard let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "StationsViewController") as? StationsViewController else {return}
            vc.selectedType = row
            vc.selectedMenuItem = selectedSection
            navigationController?.pushViewController(vc, animated: true)
        case .stationInformation:
            guard let selectedStationInfoType = StationInfoMenuItems(rawValue: indexPath.row) else {return}
            guard let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "StationInfoViewController") as? StationInfoViewController else {return}
            vc.selectedStationInfoType = selectedStationInfoType
            navigationController?.pushViewController(vc, animated: true)
        default:
            break
        }
    }
}

extension ViewController: IrishRailsSectionViewProtocol {
    func selectedSection(sectionNumber: Int) {
        guard let section = MenuItems(rawValue: sectionNumber) else {
            return
        }
        
        irishRailsTableView.beginUpdates()
        if let tempselectedSection = selectedSection, section != tempselectedSection {
            selectedSection = section == selectedSection ? nil : section
            let previousSection = tempselectedSection.intValue()
            irishRailsTableView.reloadSections(IndexSet(arrayLiteral: previousSection, sectionNumber), with: .automatic)
        } else {
            selectedSection = section == selectedSection ? nil : section
            irishRailsTableView.reloadSections(IndexSet(integer: sectionNumber), with: .automatic)
        }
        irishRailsTableView.endUpdates()
    }
    
}
