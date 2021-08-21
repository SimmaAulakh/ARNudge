//
//  WebServices.swift
//  Nudge
//
//  Created by Simranjeet Singh on 10/09/19.
//  Copyright © 2019 Simranjeet Singh. All rights reserved.
//

import UIKit

import Alamofire

import ObjectMapper

typealias responseCallBack = ((Bool, [LocationsData]?, NSError?) -> ())

class WebServices: NSObject {

    static let shared = WebServices()
    
    let BaseURL = "http://ec2-3-15-174-53.us-east-2.compute.amazonaws.com/"//old
    let BaseURLnew = "http://ec2-3-14-81-98.us-east-2.compute.amazonaws.com:5000/"//new
    var offersLocations: [LocationsData] = []
    
    var storeOfferLoc:[Offers_Data] = []
    
    var myClaimedOffers:[MyOffersData] = []
    
    //Web service to get all locations of stores
    func getAllLocations(lat:Double,long:Double,responseBack:@escaping responseCallBack) {
       
        let url = BaseURLnew + "client-location"//"get-locations"
        
        Alamofire.request(URL(string: url)!, method: .post, parameters: nil, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            
            print(response)
            
            switch(response.result) {
                
            case .success( _):
                
                if let jsonString = String(data: response.data!, encoding: String.Encoding.utf8) {
                    
                    // here `content` is the JSON data decoded as a String
               let locationsData = Mapper<GetLocations_Base>().map(JSONString: jsonString)
                    
                    switch locationsData?.status{
                        
                    case "true":
                        
                        self.offersLocations = (locationsData?.data)!
                        
                        responseBack(true, locationsData?.data, nil)
                        
                    case "false":
                        
                        responseBack(false, [], nil)
                        
                    case .none:
                        
                        break
                        
                    case .some(_):
                        
                        break
                        
                    }
                    
                }
                
            case .failure(let error):
                
                print(error)
                
                responseBack(false, nil, error as NSError)
                
                break
                
            }
            
        }
        
    }
    
    //API to get all offers locations
    func getAllStoreLocations(lat:Double,long:Double,responseBack:@escaping (Bool, [Offers_Data]?, NSError?) -> ()) {
        
        let url = BaseURLnew + "get-all-offers"//"getofferlocation"
        
        Alamofire.request(URL(string: url)!, method: .post, parameters: nil, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            
            print(response)
            
            switch(response.result) {
                
            case .success( _):
                
                if let jsonString = String(data: response.data!, encoding: String.Encoding.utf8) {
                    
                    // here `content` is the JSON data decoded as a String
                    let locationsData = Mapper<Offers_Base>().map(JSONString: jsonString)
                    
                    switch locationsData?.status{
                        
                    case "true":
                        
                        self.storeOfferLoc = (locationsData?.data)!
                        
                        responseBack(true, locationsData?.data, nil)
                        
                    case "false":
                        
                        responseBack(false, [], nil)
                        
                    case .none:
                        
                        break
                        
                    case .some(_):
                        
                        break
                        
                    }
                   
                }
                
            case .failure(let error):
                
                print(error)
                
                responseBack(false, nil, error as NSError)
                
                break
                
            }
            
        }
        
    }
    
    //API to claim offers
    func claimOffer(user_id:String,device_id:String,client_id:String,product_id:String,offer_id:String,responseBack:@escaping ((Bool, String, NSError?) -> ()) ){
        
        let parameter: [String:Any] = ["user_id":user_id,
                                       
                                       "device_id":device_id,
                                       
                                       "client_id":client_id,
                                       
                                       "product_id":product_id,
                                       
                                       "offer_id":offer_id ]
        
        let url = BaseURLnew + "claim-myoffer"//"claimoffer"
        
        Alamofire.request(URL(string: url)!, method: .post, parameters: parameter, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            
            print(response)
            
            switch(response.result) {
                
            case .success( _):
                
                if String(data: response.data!, encoding: String.Encoding.utf8) != nil {
                    
                    // here `content` is the JSON data decoded as a String
                    responseBack(true, "Done", nil)
                    
                }
                
            case .failure(let error):
                
                print(error)
                
                responseBack(false, "", error as NSError)
                
                
                break
                
            }
            
        }
        
    }
    
    //API to get all my claimed offers
    func getMyOffers(deviceId:String,responseBack:@escaping ((Bool,[MyOffersData], NSError?) -> ()) ){
        
        let parameter: [String:Any] = ["device_id":deviceId]
        
        let url = BaseURLnew + "get-myoffers"//"getmyoffer"
        
        Alamofire.request(URL(string: url)!, method: .post, parameters: parameter, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            
            print(response)
            
            switch(response.result) {
                
            case .success( _):
                
                if let jsonString = String(data: response.data!, encoding: String.Encoding.utf8) {
                    // here `content` is the JSON data decoded as a String
                    
                    let offersData = Mapper<MyOffersBase>().map(JSONString: jsonString)
                    
                    switch offersData?.status{
                        
                    case "true":
                        
                        self.myClaimedOffers = (offersData?.data)!
                        
                        responseBack(true, (offersData?.data)!, nil)
                        
                    case "false":
                        
                         responseBack(false, [], nil)
                        
                    case .none:
                        
                        break
                        
                    case .some(_):
                        
                        break
                        
                    }
                    
                }
                
            case .failure(let error):
                
                print(error)
                
                responseBack(false, [], error as NSError)
                
                break
                
            }
        }
    }
    
    //API to get detail of any particular offer
    func getSingleOfferDetail(offerId:String,responseBack:@escaping ((Bool, [Offers_Data], NSError?) -> ()) ){
        
        let parameter: [String:Any] = ["offer_id":offerId]
        
        let url = BaseURLnew + "get-offer-byid"//"getofferdetails"
        
        Alamofire.request(URL(string: url)!, method: .post, parameters: parameter, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            
            print(response)
            
            switch(response.result) {
                
            case .success( _):
                
                if let jsonString = String(data: response.data!, encoding: String.Encoding.utf8) {
                    
                    // here `content` is the JSON data decoded as a String
                    let locationsData = Mapper<Offers_Base>().map(JSONString: jsonString)
                    
                    switch locationsData?.status{
                        
                    case "true":
                        
                          responseBack(true, (locationsData?.data)!, nil)
                        
                    case "false":
                        
                        responseBack(false, [], nil)
                        
                    case .none:
                        
                        break
                        
                    case .some(_):
                        
                        break
                        
                    }
                    
                }
                
            case .failure(let error):
                
                print(error)
                
                responseBack(false, [], error as NSError)
                
                break
            }
        }
    }
    
    //API to get push notification when a offer is nearby
    func getPush(lat:Double,long:Double,token:String,responseBack:@escaping ((Bool, String, NSError?) -> ()) ){
        
         let parameter: [String:Any] = ["lat":lat,
                                        
                                        "lng":long,
                                        
                                        "token":token]
        
        let url = BaseURLnew + "send-push"
        
        Alamofire.request(URL(string: url)!, method: .post, parameters: parameter, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            
            print(response)
            
            switch(response.result) {
                
            case .success( _):
                
                if String(data: response.data!, encoding: String.Encoding.utf8) != nil {
                    
                    // here `content` is the JSON data decoded as a String
                    responseBack(true, "Done", nil)
                    
                }
                
            case .failure(let error):
                
                print(error)
                
                responseBack(false, "", error as NSError)
                
                break
                
            }
        }
    }
}
