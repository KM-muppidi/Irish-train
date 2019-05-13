//
//  StationDetailsViewController.swift
//  IriesTrains
//
//  Created by Kavya Muppidi Agrawal on 11/05/19.
//  Copyright © 2019 Kavya Muppidi Agrawal. All rights reserved.
//

import UIKit
import MapKit

class StationDetailsViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var aTableView: UITableView!
    
    var stationDetails: StationDetails = StationDetails() {
        didSet {
            switch selectedStationInfoType ?? .stationName {
            case .stationName:
                stationRoot.getAllStationData(stationDataType: .stationDes(des: stationDetails.StationDesc))
            case .stationNameTime:
                stationRoot.getAllStationData(stationDataType: .stationDesAndTime(des: stationDetails.StationDesc, time: selectedTime))
            case .stationCode:
                stationRoot.getAllStationData(stationDataType: .stationCode(code: stationDetails.StationCode))
            case .stationCodeTime:
                stationRoot.getAllStationData(stationDataType: .stationCodeAndTime(code: stationDetails.StationCode, time: selectedTime))
            }
        }
    }
    var trainDetails: TrainDetails = TrainDetails() {
        didSet {
            trainRoot.getAllTrainsMovementWithType(trainId: trainDetails.TrainCode, trainDate: trainDetails.TrainDate)
        }
    }
    
    var selectedMenuItem: MenuItems = .allTrain
    var selectedStationInfoType = StationInfoMenuItems(rawValue: 0)
    var selectedTime = "90" //Default
    
    lazy var stationRoot: StationDataRoot = {
        let station = StationDataRoot()
        station.delegate = self
        return station
    }()
    
    lazy var trainRoot: TrainMovementRoot = {
        let trainMovementRoot = TrainMovementRoot()
        trainMovementRoot.delegate = self
        return trainMovementRoot
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if selectedMenuItem == .allTrain {
            title = stationDetails.StationDesc
        } else if selectedMenuItem == .currentTrain {
            title = trainDetails.TrainCode
        }
        setMapView()
    }
    
    func setMapView() {
        let regionRadius: CLLocationDistance = 1000
        let location = CLLocation(latitude: CLLocationDegrees(Double(selectedMenuItem == .allTrain ? stationDetails.StationLatitude : trainDetails.TrainLatitude) ?? 0.0), longitude: CLLocationDegrees(Double(selectedMenuItem == .allTrain ? stationDetails.StationLongitude : trainDetails.TrainLongitude) ?? 0.0))
        
        let coordinateRegion = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        mapView.setRegion(coordinateRegion, animated: true)
        let title = selectedMenuItem == .allTrain ? stationDetails.StationCode : trainDetails.TrainCode
        
        let annotation = IrishAnnotation(title: title, locationName: stationDetails.StationDesc, coordinate: location.coordinate)
        mapView.addAnnotation(annotation)
    }
}

extension StationDetailsViewController: ApiCompletionDelegate {
    func receivedAllData() {
        DispatchQueue.main.async {
            self.aTableView.reloadData()
        }
    }
}

extension StationDetailsViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        if selectedMenuItem == .allTrain {
            return stationRoot.stationData.count
        } else if selectedMenuItem == .currentTrain {
            return trainRoot.trainsMovement.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if selectedMenuItem == .allTrain {
            return stationRoot.stationData[section].count
        }
        else if selectedMenuItem == .currentTrain {
            return trainRoot.trainsMovement[section].count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "StationDetailsTableViewCell", for: indexPath) as? StationDetailsTableViewCell else {
            return UITableViewCell()
        }
        var row = (title:"", desc:"")
        if selectedMenuItem == .allTrain {
            row = stationRoot.stationData[indexPath.section][indexPath.row]
        } else if selectedMenuItem == .currentTrain {
            row = trainRoot.trainsMovement[indexPath.section][indexPath.row]
        }
        cell.titleLabel.text = row.title
        cell.descriptionLabel.text = row.desc
        return cell
    }
    
}
