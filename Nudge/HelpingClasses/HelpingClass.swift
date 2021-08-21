//
//  HelpingClass.swift
//  Nudge
//
//  Created by Simranjeet Singh on 13/09/19.
//  Copyright © 2019 Simranjeet Singh. All rights reserved.
//

import UIKit
import CoreLocation

class HelpingClass: NSObject {
    
static let shared = HelpingClass()
    
    let baseURL = ""
    
    var currentLocation = CLLocation()
    
    var selectedOffer: Offers_Data?
    
    var anywhereOffers:[Offers_Data] = []
    
    //This function is used for delay purposes
    func delay(_ delay:Double, closure:@escaping ()->()) {
        
        let when = DispatchTime.now() + delay
        
        DispatchQueue.main.asyncAfter(deadline: when, execute: closure)
        
    }
    
    //This functions calculates users distance from any offer nearby
    func getNearbyLocations(location:CLLocation,responseBack:@escaping ((Bool, NSError?) -> ())) {
     
        let locations = WebServices.shared.offersLocations
        
        let offerLocations = WebServices.shared.storeOfferLoc
       
        for loc in locations{
            
            let storeLocation = CLLocation(latitude: Double(loc.lat!) as! CLLocationDegrees, longitude: Double(loc.lng!) as! CLLocationDegrees)

            let distanceInMeters = storeLocation.distance(from: location)
            
            if distanceInMeters <= 50{
                
                responseBack(true, nil)
                
            }else{
                
                responseBack(false, nil)
            }
            
        }
        
        for loc in offerLocations{
            
            if loc.lng != "" || loc.lat != ""{
                
            let storeLocation = CLLocation(latitude: Double(loc.lat!) as! CLLocationDegrees, longitude: Double(loc.lng!) as! CLLocationDegrees)
            
            let distanceInMeters = storeLocation.distance(from: location)
                
            if distanceInMeters <= 50{
                
                responseBack(true, nil)
                
            }else{
                
                responseBack(false, nil)
                
                }
                
            }
        
        }
        
    }
    
    func checkIfLocationIsAccesible(myLocation:CLLocation,otherLocation:LocationsData,responseBack:@escaping ((Bool, NSError?) -> ())) {
        //Convert otherLocation to type CLLocation
        let storeLocation = CLLocation(latitude: Double(otherLocation.lat!) as! CLLocationDegrees, longitude: Double(otherLocation.lng!) as! CLLocationDegrees)
        
         //Get distance within both locations in Meters
            let distanceInMeters = storeLocation.distance(from: myLocation)
        
            if distanceInMeters <= 50{  //check if location is within 50meters from store location
                
                responseBack(true, nil)
                
            }else{
                
                responseBack(false, nil)
                
        }
        
    }
    
    func checkIfLocationIsAccesiblee(myLocation:CLLocation,otherLocation:Offers_Data,responseBack:@escaping ((Bool, NSError?) -> ())) {
        
        //Convert otherLocation to type CLLocation
        let storeLocation = CLLocation(latitude: Double(otherLocation.lat!) as! CLLocationDegrees, longitude: Double(otherLocation.lng!) as! CLLocationDegrees)
        
        //Get distance within both locations in Meters
        let distanceInMeters = storeLocation.distance(from: myLocation)
        
        if distanceInMeters <= Double(otherLocation.radius!)!{  //check if location is within radius from store location
            
            responseBack(true, nil)
            
        }else{
            
            responseBack(false, nil)
            
        }
        
    }
    
}

extension UIViewController {
    
    func presentAlertWithTitle(title: String, message: String, options: String..., completion: @escaping (Int) -> Void) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        for (index, option) in options.enumerated() {
            
            alertController.addAction(UIAlertAction.init(title: option, style: .default, handler: { (action) in
                completion(index)
                
            }))
            
        }
        
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
        
    }
    
    func imageWithImage(image:UIImage, scaledToSize newSize:CGSize) -> UIImage{
        
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
        
        image.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        
        let newImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        
        UIGraphicsEndImageContext()
        
        return newImage
        
    }
}
extension UIView {
    
    // OUTPUT 1
    func dropShadow(scale: Bool = true) {
        
        layer.masksToBounds = false
        
        layer.shadowColor = UIColor.black.cgColor
        
        layer.shadowOpacity = 0.5
        
        layer.shadowOffset = CGSize(width: -1, height: 1)
        
        layer.shadowRadius = 1
        
        layer.shadowPath = UIBezierPath(rect: bounds).cgPath
        
        layer.shouldRasterize = true
        
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
        
    }
    
    // OUTPUT 2
    func dropShadow(color: UIColor, opacity: Float = 0.5, offSet: CGSize, radius: CGFloat = 1, scale: Bool = true) {
        
        layer.masksToBounds = false
        
        layer.shadowColor = color.cgColor
        
        layer.shadowOpacity = opacity
        
        layer.shadowOffset = offSet
        
        layer.shadowRadius = radius
        
        layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        
        layer.shouldRasterize = true
        
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
        
    }
}
extension UIImage {
    
    func addShadow(blurSize: CGFloat = 15.0) -> UIImage {
        
        let shadowColor = UIColor(white:0.5, alpha:0.8).cgColor
        
        let context = CGContext(data: nil,
                                width: Int(self.size.width + blurSize),
                                height: Int(self.size.height + blurSize),
                                bitsPerComponent: self.cgImage!.bitsPerComponent,
                                bytesPerRow: 0,
                                space: CGColorSpaceCreateDeviceRGB(),
                                bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue)!
        
        context.setShadow(offset: CGSize(width: blurSize/2,height: -blurSize/2),
                          blur: blurSize,
                          color: shadowColor)
        
        context.draw(self.cgImage!,
                     in: CGRect(x: 0, y: blurSize, width: self.size.width, height: self.size.height),
                     byTiling:false)
        
        return UIImage(cgImage: context.makeImage()!)
    }
}
extension UIImage {
    
    func maskWithColor(color: UIColor) -> UIImage? {
        let maskImage = cgImage!
        
        let width = size.width
        let height = size.height
        let bounds = CGRect(x: 0, y: 0, width: width, height: height)
        
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue)
        let context = CGContext(data: nil, width: Int(width), height: Int(height), bitsPerComponent: 8, bytesPerRow: 0, space: colorSpace, bitmapInfo: bitmapInfo.rawValue)!
        
        context.clip(to: bounds, mask: maskImage)
        context.setFillColor(color.cgColor)
        context.fill(bounds)
        
        if let cgImage = context.makeImage() {
            let coloredImage = UIImage(cgImage: cgImage)
            return coloredImage
        } else {
            return nil
        }
    }
    
}
