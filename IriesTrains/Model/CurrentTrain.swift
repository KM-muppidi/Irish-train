//
//  CurrentTrain.swift
//  IriesTrains
//
//  Created by Kavya Muppidi Agrawal on 11/05/19.
//  Copyright © 2019 Kavya Muppidi Agrawal. All rights reserved.
//

import Foundation

struct TrainDetails {
    var TrainStatus: String = ""
    var TrainLatitude: String = ""
    var TrainLongitude: String = ""
    var TrainCode: String = ""
    var TrainDate: String = ""
    var PublicMessage: String = ""
    var Direction = ""
    
}

class TrainRoot: NSObject {
    var trains = [TrainDetails]()
    fileprivate var trainDetails = TrainDetails()
    fileprivate var elementName = ""
    var delegate: ApiCompletionDelegate?
    
    func getAllTrainsWithType(trainType: String) {
        ConnectionManager.makeHTTPRequest(url: APIEndPoints.getCurrentTrainsWithTrainType, queryParameters: [APIConstants.TrainType: trainType], bodyParameters: [:], completionHandler: { (result) in
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

extension TrainRoot: XMLParserDelegate {
    
    // 1
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        
        if elementName == APIConstants.objTrainPositions {
            trainDetails = TrainDetails()
        }
        self.elementName = elementName
    }
    
    // 2
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == APIConstants.objTrainPositions {
            trains.append(trainDetails)
        }
    }
    
    // 3
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        let data = string.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        
        if (!data.isEmpty) {
            switch self.elementName {
            case APIConstants.TrainStatus:
                trainDetails.TrainStatus += data
            case APIConstants.TrainLatitude:
                trainDetails.TrainLatitude += data
            case APIConstants.TrainLongitude:
                trainDetails.TrainLongitude += data
            case APIConstants.TrainCode:
                trainDetails.TrainCode += data
            case APIConstants.TrainDate:
                trainDetails.TrainDate += data
            case APIConstants.PublicMessage:
                trainDetails.PublicMessage += data
            case APIConstants.Direction:
                trainDetails.Direction += data
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
