//
//  IriesTrains
//
//  Created by Kavya Muppidi Agrawal on 11/05/19.
//  Copyright © 2019 Kavya Muppidi Agrawal. All rights reserved.
//

import Foundation
import UIKit

/**
 *This class holds all kinds of contants used through out the app.
 */

struct AppConstants {
    static let ScreenWidth = UIScreen.main.bounds.width
}

struct APIConstants {
    //getAllStationsWithStationType
    static let StationType = "StationType"
    
    static let objStation = "objStation"
    static let StationDesc = "StationDesc"
    static let StationLatitude = "StationLatitude"
    static let StationLongitude = "StationLongitude"
    static let StationCode = "StationCode"
    static let StationId = "StationId"
    
    //getCurrentTrains
    static let TrainType = "TrainType"
    static let objTrainPositions = "objTrainPositions"
    static let TrainStatus = "TrainStatus"
    static let TrainLatitude = "TrainLatitude"
    static let TrainLongitude = "TrainLongitude"
    static let TrainCode = "TrainCode"
    static let TrainDate = "TrainDate"
    static let PublicMessage = "PublicMessage"
    static let Direction = "Direction"
    
    //getStationDataWithNameAndTime
    static let NumMins = "NumMins"
    static let objStationData = "objStationData"
    static let Servertime = "Servertime"
    static let Traincode = "Traincode"
    static let Stationfullname = "Stationfullname"
    static let Stationcode = "Stationcode"
    static let Querytime = "Querytime"
    static let Traindate = "Traindate"
    static let Origin = "Origin"
    static let Destination = "Destination"
    static let Origintime = "Origintime"
    static let Destinationtime = "Destinationtime"
    static let Status = "Status"
    static let Lastlocation = "Lastlocation"
    static let Duein = "Duein"
    static let Late = "Late"
    static let Exparrival = "Exparrival"
    static let Expdepart = "Expdepart"
    static let Scharrival = "Scharrival"
    static let Schdepart = "Schdepart"
    static let Traintype = "Traintype"
    static let Locationtype = "Locationtype"
    
    //getTrainMovement
    static let TrainId = "TrainId"
    static let objTrainMovements = "objTrainMovements"
    static let LocationCode = "LocationCode"
    static let LocationFullName = "LocationFullName"
    static let LocationOrder = "LocationOrder"
    static let LocationType = "LocationType"
    static let TrainOrigin = "TrainOrigin"
    static let TrainDestination = "TrainDestination"
    static let ScheduledArrival = "ScheduledArrival"
    static let ScheduledDeparture = "ScheduledDeparture"
    static let ExpectedArrival = "ExpectedArrival"
    static let ExpectedDeparture = "ExpectedDeparture"
    static let Arrival = "Arrival"
    static let Departure = "Departure"
    static let AutoArrival = "AutoArrival"
    static let AutoDepart = "AutoDepart"
    static let StopType = "StopType"
    
    //getStationWithStationText
    static let StationText = "StationText"
    static let objStationFilter = "objStationFilter"
}

struct APIEndPoints {
    //static let getAllStations = "getAllStationsXML"
    static let getAllStationsWithStationType = "getAllStationsXML_WithStationType"
    static let getCurrentTrains = "getCurrentTrainsXML"
    static let getCurrentTrainsWithTrainType = "getCurrentTrainsXML_WithTrainType"
    static let getStationDataWithName = "getStationDataByNameXML"
    static let getStationDataWithNameAndTime = "getStationDataByNameXML_withNumMins"
    static let getStationDataWithCode = "getStationDataByCodeXML"
    static let getStationDataWithCodeAndTime = "getStationDataByCodeXML_WithNumMins"
    static let getStationWithStationText = "getStationsFilterXML"
    static let getTrainMovement = "getTrainMovementsXML"
}

struct APIKeys {
    static let BaseURL = "http://api.irishrail.ie/realtime/realtime.asmx/"
}

struct ErrorMessages {
    static let NoInternet = "No internet. Please check your connection."
    static let Default = "Something went wrong. Please try again later."
    static let Server = "Internal server error. Please contact to administration."
    static let Client = "Something went wrong. Please check whether the details provided are correct."
}
