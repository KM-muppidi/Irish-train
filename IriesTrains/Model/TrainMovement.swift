//
//  TrainMovement.swift
//  IriesTrains
//
//  Created by Kavya Muppidi Agrawal on 11/05/19.
//  Copyright © 2019 Kavya Muppidi Agrawal. All rights reserved.
//

import Foundation

struct TrainMovementDetails {
    var TrainCode: String = ""
    var TrainDate: String = ""
    var LocationCode: String = ""
    var LocationFullName: String = ""
    var LocationOrder: String = ""
    var LocationType: String = ""
    var TrainOrigin = ""
    var TrainDestination: String = ""
    var ScheduledArrival: String = ""
    var ScheduledDeparture: String = ""
    var ExpectedArrival: String = ""
    var ExpectedDeparture: String = ""
    var Arrival: String = ""
    var Departure = ""
    var AutoArrival: String = ""
    var AutoDepart = ""
    var StopType = ""
    
    let count = 17
    
    subscript(index: Int) -> (title:String, desc:String) {
        get {
            switch index {
            case 0:
                return ("Train Code", TrainCode)
            case 1:
                return ("Train Date", TrainDate)
            case 2:
                return ("Location Code", LocationCode)
            case 3:
                return ("Location FullName", LocationFullName)
            case 4:
                return ("Location Order", LocationOrder)
            case 5:
                return ("Location Type", LocationType)
            case 6:
                return ("Train Origin", TrainOrigin)
            case 7:
                return ("Train Destination", TrainDestination)
            case 8:
                return ("Scheduled Arrival", ScheduledArrival)
            case 9:
                return ("Scheduled Departure", ScheduledDeparture)
            case 10:
                return ("Expected Arrival", ExpectedArrival)
            case 11:
                return ("Expected Departure", ExpectedDeparture)
            case 12:
                return ("Arrival", Arrival)
            case 13:
                return ("Departure", Departure)
            case 14:
                return ("Auto Arrival", AutoArrival)
            case 15:
                return ("Auto Depart", AutoDepart)
            case 16:
                return ("Stop Type", StopType)
            default:
                return ("", "")
            }
        }
    }
}

class TrainMovementRoot: NSObject {
    var trainsMovement = [TrainMovementDetails]()
    fileprivate var trainMovementDetails = TrainMovementDetails()
    fileprivate var elementName = ""
    var delegate: ApiCompletionDelegate?
    
    func getAllTrainsMovementWithType(trainId: String, trainDate: String) {
        ConnectionManager.makeHTTPRequest(url: APIEndPoints.getTrainMovement, queryParameters: [APIConstants.TrainId: trainId, APIConstants.TrainDate: trainDate], bodyParameters: [:], completionHandler: { (result) in
            print(result)
            switch result {
            case .success(let xmlData):
                let parser = XMLParser(data: xmlData)
                
                parser.delegate = self;
                
                parser.parse()
            case .failure(_):
                print("Failed: \(APIEndPoints.getAllStationsWithStationType)")
            }
        })
    }
}

extension TrainMovementRoot: XMLParserDelegate {
    
    // 1
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        
        if elementName == APIConstants.objTrainMovements {
            trainMovementDetails = TrainMovementDetails()
        }
        self.elementName = elementName
    }
    
    // 2
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == APIConstants.objTrainMovements {
            trainsMovement.append(trainMovementDetails)
        }
    }
    
    // 3
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        let data = string.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        
        if (!data.isEmpty) {
            switch self.elementName {
            case APIConstants.TrainCode:
                trainMovementDetails.TrainCode += data
            case APIConstants.TrainDate:
                trainMovementDetails.TrainDate += data
            case APIConstants.LocationCode:
                trainMovementDetails.LocationCode += data
            case APIConstants.LocationFullName:
                trainMovementDetails.LocationFullName += data
            case APIConstants.LocationOrder:
                trainMovementDetails.LocationOrder += data
            case APIConstants.LocationType:
                trainMovementDetails.LocationType += data
            case APIConstants.TrainOrigin:
                trainMovementDetails.TrainOrigin += data
            case APIConstants.TrainDestination:
                trainMovementDetails.TrainDestination += data
            case APIConstants.ScheduledArrival:
                trainMovementDetails.ScheduledArrival += data
            case APIConstants.ScheduledDeparture:
                trainMovementDetails.ScheduledDeparture += data
            case APIConstants.ExpectedArrival:
                trainMovementDetails.ExpectedArrival += data
            case APIConstants.ExpectedDeparture:
                trainMovementDetails.ExpectedDeparture += data
            case APIConstants.Arrival:
                trainMovementDetails.Arrival += data
            case APIConstants.Departure:
                trainMovementDetails.Departure += data
            case APIConstants.AutoArrival:
                trainMovementDetails.AutoArrival += data
            case APIConstants.AutoDepart:
                trainMovementDetails.AutoDepart += data
            case APIConstants.StopType:
                trainMovementDetails.StopType += data
            default:
                break
            }
        }
    }
    
    //4
    func parserDidEndDocument(_ parser: XMLParser) {
        delegate?.receivedAllData()
    }
}
