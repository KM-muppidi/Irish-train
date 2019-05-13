//
//  Station.swift
//  IriesTrains
//
//  Created by Kavya Muppidi Agrawal on 11/05/19.
//  Copyright © 2019 Kavya Muppidi Agrawal. All rights reserved.
//

import Foundation

protocol ApiCompletionDelegate {
    func receivedAllData()
}

struct StationDetails {
    var StationDesc: String = ""
    var StationLatitude: String = ""
    var StationLongitude: String = ""
    var StationCode: String = ""
    var StationId: String = ""
}

class StationRoot: NSObject {
    var stations = [StationDetails]()
    fileprivate var stationDetails = StationDetails()
    fileprivate var elementName = ""
    var delegate: ApiCompletionDelegate?
    
    func getAllStationsWithType(stationType: String) {
        ConnectionManager.makeHTTPRequest(url: APIEndPoints.getAllStationsWithStationType, queryParameters: [APIConstants.StationType: stationType], bodyParameters: [:], completionHandler: { (result) in
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
    
    func getAllStations(stationText: String) {
        ConnectionManager.makeHTTPRequest(url: APIEndPoints.getStationWithStationText, queryParameters: [APIConstants.StationText: stationText], bodyParameters: [:], completionHandler: { (result) in
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

extension StationRoot: XMLParserDelegate {
    
    // 1
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        
        if elementName == APIConstants.objStation || elementName == APIConstants.objStationFilter {
            stationDetails = StationDetails()
        }
        self.elementName = elementName
    }
    
    // 2
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == APIConstants.objStation || elementName == APIConstants.objStationFilter {
            stations.append(stationDetails)
        }
    }
    
    // 3
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        let data = string.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        
        if (!data.isEmpty) {
            switch self.elementName {
                case APIConstants.StationDesc:
                   stationDetails.StationDesc += data
                case APIConstants.StationLatitude:
                    stationDetails.StationLatitude += data
                case APIConstants.StationLatitude:
                    stationDetails.StationLongitude += data
                case APIConstants.StationCode:
                    stationDetails.StationCode += data
                case APIConstants.StationId:
                    stationDetails.StationId += data
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
