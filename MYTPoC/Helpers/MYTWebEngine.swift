//
//  MYTWebEngine.swift
//  MYTPoC
//
//  Created by Mukesh on 27/05/18.
//  Copyright © 2018 com.murugananda. All rights reserved.
//

import UIKit
import SystemConfiguration

typealias MYTWebManagerReturnBlockWithObject = (_ result: AnyObject?, _ userInfo: String?) -> Void
typealias MYTWebManagerReturnBlockWithError = (_ result: NSError?, _ userInfo: String?) -> Void
typealias MYTWebManagerReturnBlockWithFail = (_ result: NSError?, _ userInfo: String?) -> Void

class MYTWebManager: NSObject, URLSessionDelegate {
    
    //MARK: - Singleton
    
    static let sharedManager: MYTWebManager = {
        let instance = MYTWebManager()
        return instance
    }()
    
    //MARK: - Helpers
    
    func basicRequestObject(usingURL url : URL) -> URLRequest {
        
        var request = URLRequest(url: url)
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        return request
    }
    
    func loadQueryParams(_ params : NSDictionary?, toURL url : URL) -> URL {
        
        var fullURL = url
        
        if  params != nil && (params?.count)! > 0 {
            
            var urlComponents = URLComponents(string: "\(fullURL)")
            
            var queryItems = [URLQueryItem]()
            
            for (key, value) in params! {
                let queryItem = URLQueryItem(name: key as! String, value: String(describing: value))
                queryItems.append(queryItem)
            }
            
            urlComponents?.queryItems = queryItems
            fullURL = (urlComponents?.url)!
        }
        
        return fullURL
    }
    
    //MARK: - Get function
    
    func getDataBySending(_ parameters : NSDictionary?, toURL url : URL, withSuccess successBlock: @escaping MYTWebManagerReturnBlockWithObject, withFail failBlock: @escaping MYTWebManagerReturnBlockWithFail, withError errorBlock: @escaping MYTWebManagerReturnBlockWithError) -> Void {
        
        
        if MYTWebManager.isNetworkAvailable() == false {
            failBlock(nil,"Network is not available")
            return;
        }
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.3) {
            
            let urlSesionConfigration = URLSessionConfiguration.default
            urlSesionConfigration.allowsCellularAccess = true
            
            let fullURL = self.loadQueryParams(parameters, toURL: url)
            var request = self.basicRequestObject(usingURL: fullURL)
            
            request.httpMethod = HTTPMethod.GET
            
            let urlSession = URLSession.init(configuration: urlSesionConfigration)
            
            urlSession.dataTask(with: request, completionHandler: { (data, response, error) in
                
                OperationQueue.main.addOperation {
                    self.handleServiceResponse(data: data, response: response, error: error, successBlock: successBlock, failBlock: failBlock, errorBlock: errorBlock)
                }
                
            }).resume()
        }
    }
    
    //MARK: - Handle Response
    
    fileprivate func handleServiceResponse(data : Data?, response :URLResponse?,error : Error?, successBlock : MYTWebManagerReturnBlockWithObject, failBlock :MYTWebManagerReturnBlockWithFail, errorBlock : MYTWebManagerReturnBlockWithError) -> Void {
        
        let httpResponse = response as? HTTPURLResponse
        
        if error == nil
        {
            if let dict = NSDictionary().dictionaryWithData(data) {
                
                debugLog("Received (Processed): \n\n \(dict)")
            }
            
            let statusCode = httpResponse?.statusCode
            
            debugLog("\(String(describing: statusCode))")
            
            switch (statusCode) {
            case StatusCode.OK?:
                
                if data != nil {
                    if let dictionary = NSDictionary().dictionaryWithData(data) {
                        successBlock(dictionary, nil)
                    }
                    else {
                        successBlock(nil, "Success")
                    }
                }
                
                break
            default:
                
                if data != nil {
                    if let dictionary = NSDictionary().dictionaryWithData(data) {
                        if let message = dictionary.object(forKey: "message") {
                            failBlock(nil, message as? String)
                        }
                        else {
                            failBlock(nil, "Operation failed")
                        }
                    } else {
                        failBlock(nil, "Operation failed")
                    }
                }
                else {
                    failBlock(nil, "Operation failed")
                }
                
                break
            }
        }
        else {
            debugLog((error?.localizedDescription)!)
            errorBlock(error as NSError?, "")
        }
    }
    
    //MARK: - Check Network
    
    class func isNetworkAvailable() -> Bool {
        
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout<sockaddr_in>.size)
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        guard let defaultRouteReachability = withUnsafePointer(to: &zeroAddress, {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
                SCNetworkReachabilityCreateWithAddress(nil, $0)
            }
        }) else {
            return false
        }
        
        var flags: SCNetworkReachabilityFlags = []
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) {
            return false
        }
        
        let isReachable = flags.contains(.reachable)
        let needsConnection = flags.contains(.connectionRequired)
        
        return (isReachable && !needsConnection)
    }
}

//MARK: - Helpers

public func debugLog(_ logMessage: String, functionName: String = #function, fileName: String = #file) {
    #if DebugRun
    print("File: \(fileName) \n\nFunction: \(functionName):\n\n \(logMessage)\n\n", separator: "\n")
    #endif
}

//MARK: - WEB

public struct HTTPMethod {
    
    static let GET = "GET"
}

struct StatusCode {
    
    static let OK = 200
}

