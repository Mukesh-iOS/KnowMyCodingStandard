//
//  MYTModel.swift
//  MYTPoC
//
//  Created by Mukesh on 27/05/18.
//  Copyright © 2018 com.murugananda. All rights reserved.
//

import UIKit
import SVProgressHUD

typealias MYTListDetailMOBlockWithObject = (_ result: CodableContainer?, _ userInfo: String?) -> Void
typealias MYTListDetailMOBlockWithError = (_ result: NSError?, _ userInfo: String?) -> Void

class CodableContainer: NSObject, Codable {
    
    private enum poiListResponseKey: String, CodingKey {
        case poiList
    }
    
    @objc var poiList: [Lists]?
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: poiListResponseKey.self)
        
        poiList = try! container.decode([Lists]?.self, forKey: .poiList) ?? nil
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: poiListResponseKey.self)
        
        try? container.encode(poiList, forKey: .poiList)
    }
}

class Lists: NSObject, Codable {
    
    private enum ListsKey: String, CodingKey {
        case id
        case fleetType
        case heading
        case coordinate
    }
    
    @objc var id: Int = 0
    @objc var heading: Double = 0
    @objc var fleetType: String?
    @objc var coordinate: CoordinatesObj?
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: ListsKey.self)
        
        id = try! container.decode(Int?.self, forKey: .id) ?? 0
        heading = try! container.decode(Double?.self, forKey: .heading) ?? 0
        fleetType = try? container.decode(String?.self, forKey: .fleetType) ?? ""
        coordinate = (try! container.decode(CoordinatesObj?.self, forKey: .coordinate))!
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: ListsKey.self)
        
        try? container.encode(id , forKey: .id)
        try? container.encode(heading , forKey: .heading)
        try? container.encode(fleetType , forKey: .fleetType)
        try? container.encode(coordinate , forKey: .coordinate)
    }
}

class CoordinatesObj: NSObject, Codable {
    
    private enum CoordinatesKey: String, CodingKey {
        case latitude
        case longitude
    }
    
    @objc var latitude: Double = 0
    @objc var longitude: Double = 0
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CoordinatesKey.self)
        
        latitude = try! container.decode(Double?.self, forKey: .latitude) ?? 0
        longitude = try! container.decode(Double?.self, forKey: .longitude) ?? 0
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CoordinatesKey.self)
        
        try? container.encode(latitude, forKey: .latitude)
        try? container.encode(longitude, forKey: .longitude)
    }
}

@objc class MYTModel: NSObject {
    
    // MARK: Get List Details

     @objc func getListDetailsFromRest(parameter : NSDictionary, withSuccess successBlock: @escaping MYTListDetailMOBlockWithObject, withFail failBlock: @escaping MYTListDetailMOBlockWithError) {
        let listDetailURL = URL.init(string: RequestURLHelper.baseURL)!
        
        SVProgressHUD.setDefaultMaskType(.clear)
        SVProgressHUD.show(withStatus: "Getting vehicle details")
        
        MYTWebManager.sharedManager.getDataBySending(parameter, toURL: listDetailURL , withSuccess: { (response, userInfo) in
            
            SVProgressHUD.dismiss()
            
            guard let response = response else { return }

            let data = try? JSONSerialization.data(withJSONObject: response, options: .prettyPrinted)
            do {
                let decoder = JSONDecoder()
                let listResponse = try decoder.decode(CodableContainer.self, from: data!)
                successBlock(listResponse, "")
            } catch let err {
                print("Err", err)
            }
        }, withFail: { (error, userInfo) in
            
            SVProgressHUD.dismiss()
            failBlock(error, userInfo)
            
        }) { (error, userInfo) in
            
            SVProgressHUD.dismiss()
            failBlock(error, userInfo)
        }
    }
}

