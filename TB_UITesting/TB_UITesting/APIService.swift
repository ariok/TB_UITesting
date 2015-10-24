//
//  Network.swift
//  NetworkExample
//
//  Created by Yari D'areglia on 25/09/15.
//  Copyright © 2015 Yari Dareglia. All rights reserved.
//

import UIKit

typealias JSONData = [String:AnyObject]
typealias APICompletionResponse = (code:StatusCode, JSON:JSONData?)->Void

enum Method: String {
    
    case GET = "GET"
    case POST = "POST"
    case PUT = "PUT"
    case DELETE = "DELETE"
    case PATCH = "PATCH"
    case TRACE = "TRACE"
    case CONNECT = "CONNECT"
    case HEAD = "HEAD"
    case OPTIONS = "OPTIONS"
}

enum StatusCode: Int {
    
    case Ok = 200
    case Created = 201
    case Accepted = 202
    case Unauthorized = 401
    case Forbidden = 403
    case NotFound = 404
    case Unprocessable = 422
    
    func valid() -> Bool{
        return self.rawValue > 199 && self.rawValue < 203
    }
}

struct APICall {
    
    let path: String
    let method: Method
    var parameters: JSONData?
    var headers:[String:String]?
    var authToken:String?
    
    init(path:String, method:Method, parameters:JSONData? = nil){
        self.path = path
        self.method = method
        self.parameters = parameters
    }
}

class APIService {
    
    // MARK: Public Interface
    
    let endPoint:NSURL
    
    var testMode:Bool = false
    var forceStatusCode:StatusCode? = nil
    var forceJSONResponse:JSONData? = nil
    
    init(endPoint:NSURL){
        self.endPoint = endPoint
    }
    
    func request(apiCall: APICall, completion:(APICompletionResponse)){
        guard testMode == false else{
            completion(code: forceStatusCode!, JSON: forceJSONResponse)
            return
        }
        
        let session = buildSession()
        let urlRequest = buildURLRequest(apiCall)
        
        let task = session.dataTaskWithRequest(urlRequest) {
            (data, response, error) -> Void in
            
            print("----> Request: \(urlRequest.HTTPMethod) \(urlRequest.URL!.path!)")
            
            if  let httpResponse = response as? NSHTTPURLResponse,
                let code = StatusCode(rawValue:httpResponse.statusCode)  {
                    
                    print("<---- Response Code: \(code.rawValue)")
                    print("<---- \(NSString(data: data!, encoding: NSISOLatin1StringEncoding))\n\n")
                    
                    guard let responseData = data else {
                        dispatch_async(dispatch_get_main_queue()) {
                            completion(code: code, JSON: nil)
                        }
                        return
                    }
                    
                    guard let JSON = responseData.toJSON() else{
                        dispatch_async(dispatch_get_main_queue()) {
                            completion(code: code, JSON: nil)
                        }
                        return
                    }
                    
                    dispatch_async(dispatch_get_main_queue()) {
                        completion(code: code, JSON: JSON)
                    }
            }else{
                print("!!!Error: \(error)")
                // ERROR HANDLING
            }
        }
        
        task.resume()
    }
    
    
    // MARK: Private
    
    private func buildSession()->NSURLSession{
        
        let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
        return NSURLSession(configuration: configuration)
    }
    
    private func buildURLRequest(apiCall:APICall)->NSMutableURLRequest{
        
        let fullURL = endPoint.URLByAppendingPathComponent(apiCall.path)
        let mutableURLRequest = NSMutableURLRequest(URL: fullURL)
        mutableURLRequest.HTTPMethod = apiCall.method.rawValue
        
        if let headers = apiCall.headers{
            for (header, value) in headers{
                mutableURLRequest.setValue(value, forHTTPHeaderField: header)
            }
        }
        
        if let authToken = apiCall.authToken {
            mutableURLRequest.setValue("Token token=\(authToken)", forHTTPHeaderField: "Authorization")
        }
        
        if let parameters = apiCall.parameters{
            let data = try? NSJSONSerialization.dataWithJSONObject(parameters, options: NSJSONWritingOptions())
            mutableURLRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
            mutableURLRequest.HTTPBody = data
        }
        
        return mutableURLRequest
    }
    
}

extension NSData {
    func toJSON() -> JSONData?{
        
        let JSON = try? NSJSONSerialization.JSONObjectWithData(self, options: NSJSONReadingOptions.AllowFragments)
        
        return JSON as? JSONData
    }
}