//
//  StationDataNameAndTime.swift
//  IriesTrains
//
//  Created by Kavya Muppidi Agrawal on 11/05/19.
//  Copyright © 2019 Kavya Muppidi Agrawal. All rights reserved.
//

import Foundation

enum GetStationData {
    case stationDes(des: String), stationDesAndTime(des: String, time: String), stationCode(code: String), stationCodeAndTime(code: String, time: String)
    
    func getApiEndPoint() -> String {
        switch self {
        case .stationDes(_):
            return APIEndPoints.getStationDataWithName
        case .stationDesAndTime(_):
            return APIEndPoints.getStationDataWithNameAndTime
        case .stationCode(_):
            return APIEndPoints.getStationDataWithCode
        case .stationCodeAndTime(_):
            return APIEndPoints.getStationDataWithCodeAndTime
        }
    }
    
    func getQueryParameter() -> [String: String] {
        var queryParam = [String: String]()
        switch self {
        case .stationDes(let desc):
            queryParam[APIConstants.StationDesc] = desc
        case .stationDesAndTime(let desc, let time):
            queryParam[APIConstants.StationDesc] = desc
            queryParam[APIConstants.NumMins] = time
        case .stationCode(let code):
            queryParam[APIConstants.StationCode] = code
        case .stationCodeAndTime(let code, let time):
            queryParam[APIConstants.StationCode] = code
            queryParam[APIConstants.NumMins] = time
       
        }
        return queryParam
    }
}

struct StationDataDetails {
    var Traincode: String = ""
    var Stationfullname: String = ""
    var Stationcode: String = ""
    var Traindate: String = ""
    var Origin = ""
    var Destination: String = ""
    var Origintime: String = ""
    var Destinationtime: String = ""
    var Status: String = ""
    var Lastlocation: String = ""
    var Duein: String = ""
    var Late = ""
    var Exparrival: String = ""
    var Expdepart: String = ""
    var Scharrival: String = ""
    var Schdepart: String = ""
    var Direction: String = ""
    var Traintype: String = ""
    var Locationtype = ""
    
    let count = 19
    
    subscript(index: Int) -> (title:String, desc:String) {
        get {
            switch index {
            case 0:
                return ("Train code", Traincode)
            case 1:
                return ("Station fullname", Stationfullname)
            case 2:
                return ("Station code", Stationcode)
            case 3:
                return ("Train date", Traindate)
            case 4:
                return ("Origin", Origin)
            case 5:
                return ("Destination", Destination)
            case 6:
                return ("Origin time", Origintime)
            case 7:
                return ("Destination time", Destinationtime)
            case 8:
                return ("Status", Status)
            case 9:
                return ("Last location", Lastlocation)
            case 10:
                return ("Due in", Duein)
            case 11:
                return ("Late", Late)
            case 12:
                return ("Exp. arrival", Exparrival)
            case 13:
                return ("Exp. depart", Expdepart)
            case 14:
                return ("Sch. arrival", Scharrival)
            case 15:
                return ("Schdepart", Schdepart)
            case 16:
                return ("Direction", Direction)
            case 17:
                return ("Train type", Traintype)
            case 18:
                return ("Location type", Locationtype)
            default:
                return ("", "")
            }
        }
    }
}

class StationDataRoot: NSObject {
    var stationData = [StationDataDetails]()
    fileprivate var stationDataDetails = StationDataDetails()
    fileprivate var elementName = ""
    var delegate: ApiCompletionDelegate?
    
    func getAllStationData(stationDataType: GetStationData) {
        let serviceEndPoint = stationDataType.getApiEndPoint()
        let queryParams = stationDataType.getQueryParameter()
        ConnectionManager.makeHTTPRequest(url: serviceEndPoint, queryParameters: queryParams, bodyParameters: [:], completionHandler: { (result) in
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

extension StationDataRoot: XMLParserDelegate {
    
    // 1
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        
        if elementName == APIConstants.objStationData {
            stationDataDetails = StationDataDetails()
        }
        self.elementName = elementName
    }
    
    // 2
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == APIConstants.objStationData {
            stationData.append(stationDataDetails)
        }
    }
    
    // 3
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        let data = string.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        
        if (!data.isEmpty) {
            switch self.elementName {
            case APIConstants.Traincode:
                stationDataDetails.Traincode += data
            case APIConstants.Stationfullname:
                stationDataDetails.Stationfullname += data
            case APIConstants.Stationcode:
                stationDataDetails.Stationcode += data
            case APIConstants.Traindate:
                stationDataDetails.Traindate += data
            case APIConstants.Origin:
                stationDataDetails.Origin += data
            case APIConstants.Destination:
                stationDataDetails.Destination += data
            case APIConstants.Origintime:
                stationDataDetails.Origintime += data
            case APIConstants.Destinationtime:
                stationDataDetails.Destinationtime += data
            case APIConstants.Lastlocation:
                stationDataDetails.Lastlocation += data
            case APIConstants.Duein:
                stationDataDetails.Duein += data
            case APIConstants.Late:
                stationDataDetails.Late += data
            case APIConstants.Exparrival:
                stationDataDetails.Exparrival += data
            case APIConstants.Expdepart:
                stationDataDetails.Expdepart += data
            case APIConstants.Scharrival:
                stationDataDetails.Scharrival += data
            case APIConstants.Schdepart:
                stationDataDetails.Schdepart += data
            case APIConstants.Direction:
                stationDataDetails.Direction += data
            case APIConstants.Traintype:
                stationDataDetails.Traintype += data
            case APIConstants.Locationtype:
                stationDataDetails.Locationtype += data
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
