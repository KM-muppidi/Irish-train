//
//  StationsViewController.swift
//  IriesTrains
//
//  Created by Kavya Muppidi Agrawal on 11/05/19.
//  Copyright © 2019 Kavya Muppidi Agrawal. All rights reserved.
//

import UIKit

class StationsViewController: UIViewController {

    @IBOutlet weak var stationsTableView: UITableView!
    var selectedType = ""
    lazy var stationRoot: StationRoot = {
        let station = StationRoot()
        station.delegate = self
        return station
    }()
    lazy var trainRoot: TrainRoot = {
        let train = TrainRoot()
        train.delegate = self
        return train
    }()
    var selectedMenuItem = MenuItems.allTrain
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if selectedMenuItem == .allTrain {
            title = "Stations - \(selectedType)"
            stationRoot.getAllStationsWithType(stationType: selectedType.isEmpty ? "A" : "\(selectedType.first ?? "A")")
        } else if selectedMenuItem == .currentTrain {
            title = "Trains - \(selectedType)"
            trainRoot.getAllTrainsWithType(trainType: selectedType.isEmpty ? "A" : "\(selectedType.first ?? "A")")
        }
    }
}

extension StationsViewController: ApiCompletionDelegate {
    func receivedAllData() {
        DispatchQueue.main.async {
            self.stationsTableView.reloadData()
        }
    }
}

extension StationsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if selectedMenuItem == .allTrain {
            return stationRoot.stations.count
        } else if selectedMenuItem == .currentTrain {
            return trainRoot.trains.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "StationsTableViewCell", for: indexPath) as? StationsTableViewCell else {
            return UITableViewCell()
        }
        if selectedMenuItem == .allTrain {
            let row = stationRoot.stations[indexPath.row]
            cell.configureCell(stationDetails: row)
        } else if selectedMenuItem == .currentTrain {
            let row = trainRoot.trains[indexPath.row]
            cell.configureCell(trainDetails: row)
        }
        return cell
    }

}

extension StationsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if selectedMenuItem == .allTrain {
            return 110
        } else if selectedMenuItem == .currentTrain {
            return 200
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "StationDetailsViewController") as? StationDetailsViewController else {return}
        vc.selectedMenuItem = selectedMenuItem
        if selectedMenuItem == .allTrain {
            vc.stationDetails = stationRoot.stations[indexPath.row]
        } else if selectedMenuItem == .currentTrain {
            vc.trainDetails = trainRoot.trains[indexPath.row]
        }
        navigationController?.pushViewController(vc, animated: true)
    }
}
