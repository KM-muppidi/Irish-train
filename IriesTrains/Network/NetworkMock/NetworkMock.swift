//
//  IriesTrains
//
//  Created by Kavya Muppidi Agrawal on 11/05/19.
//  Copyright © 2019 Kavya Muppidi Agrawal. All rights reserved.
//

import Foundation

class URLSessionDataTaskMock: URLSessionDataTask {
    private let closure: () -> Void
    init(closure: @escaping () -> Void) {
        self.closure = closure
    }
    // We override the 'resume' method and simply call our closure
    // instead of actually resuming any task.
    override func resume() {
        closure()
    }
}

enum ResponseCode: Int {
    case success = 200, authenticationFail = 401, internalServerError = 500
}

class URLSessionMock: URLSession {
    static var responseCode: ResponseCode = .success
    private let cannedHeaders = ["Content-Type" : "application/json"]
    typealias CompletionHandler = (Data?, URLResponse?, Error?) -> Void
    
    // we want our mocked URLSession to return for any request.
    var error: Error?
    
    override func dataTask(
        with url: URL,
        completionHandler: @escaping CompletionHandler
        ) -> URLSessionDataTask {
        // Create data and tell the session to always return it
        let data = Mock.find(url)
        let error = self.error
        let response = HTTPURLResponse(url: url, statusCode: URLSessionMock.responseCode.rawValue, httpVersion: "HTTP/1.1", headerFields: cannedHeaders)
        return URLSessionDataTaskMock {
            completionHandler(data, response, error)
        }
    }
}

class RequestManager {
    static let shared = RequestManager()
    fileprivate let liveSession: URLSession
    fileprivate let mockSession: URLSessionMock
    
    init() {
        self.liveSession = URLSession.shared
        self.mockSession = URLSessionMock()
    }
}


enum RequestState {
    case live
    case mock
    
    var session: URLSession {
        switch self {
        case .live: return RequestManager.shared.liveSession
        case .mock: return RequestManager.shared.mockSession
        }
    }
}

struct Mock {
    static func find(_ request: URL ) -> Data? {
        let url = request.absoluteString
        //string separated by question mark, then take the first string. This will contain the url of request upto & from where body parameteres starts. This is the key to refer concerned json data from Test json file.
        guard var pathUrl = url.components(separatedBy: "&").first else {return nil}
        switch URLSessionMock.responseCode {
        case .authenticationFail:
            pathUrl = "Failure4102"
        case .internalServerError:
            pathUrl = "Failure500"
        default:
            break
        }
        let path = Bundle.main.path(forResource: "TestData", ofType: ".json")
        let jsonString = try! String(contentsOfFile: path!, encoding: String.Encoding.utf8)
        let data = jsonString.data(using: String.Encoding.utf8)
        let jsonData = try! JSONSerialization.jsonObject(with: data!, options: [])
        if let jsonDataDict = jsonData as? [String:Any] {
            // json is dictionary
            guard let dataDict = jsonDataDict[pathUrl] else{return nil}
            debugPrint(dataDict)
            return try! JSONSerialization.data(withJSONObject: dataDict, options: [])
        } else {
            debugPrint("JSON is invalid")
        }
        return nil
    }
}
