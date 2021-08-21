//
//  MapViewController.swift
//  Nudge
//
//  Created by Simranjeet Singh on 10/09/19.
//  Copyright © 2019 Simranjeet Singh. All rights reserved.
//

import UIKit

import GoogleMaps

import CoreLocation

import SDWebImage

import GoogleUtilities



class MapViewController: UIViewController {
    
    //MARK:- IBOutlets
    
    @IBOutlet weak var mapView: GMSMapView!
    
    @IBOutlet weak var cameraButton: UIButton!
    
    private var clusterManager: GMUClusterManager!
    private var locations:[LocationsData] = []
    private var storeLocations:[Offers_Data] = []
    
    
    // MARK:- Controller Life Cycles
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
      //Do All UI or other changes for this viewController in setUpView()
        
        setUpView()
        
        // Set up the cluster manager with the supplied icon generator and
        // renderer.
        let iconGenerator = GMUDefaultClusterIconGenerator(buckets: [5,10,20,50,100], backgroundImages: [#imageLiteral(resourceName: "ballon"),#imageLiteral(resourceName: "ballon"),#imageLiteral(resourceName: "ballon"),#imageLiteral(resourceName: "ballon"),#imageLiteral(resourceName: "ballon")])
        let algorithm = GMUNonHierarchicalDistanceBasedAlgorithm()
        let renderer = GMUDefaultClusterRenderer(mapView: mapView,
                                                 clusterIconGenerator: iconGenerator)
        clusterManager = GMUClusterManager(map: mapView, algorithm: algorithm,
                                           renderer: renderer)
        renderer.delegate = self
        clusterManager.setDelegate(self, mapDelegate: self)
        mapView.delegate = self
        
        // Call cluster() after items have been added to perform the clustering
        // and rendering on map.
        clusterManager.cluster()
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(pushNotificationHandler(_:)) , name: NSNotification.Name(rawValue: "NewNotification"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(pushNotificationHandler1(_:)) , name: NSNotification.Name(rawValue: "GoTo"), object: nil)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    //    locationManager.requestWhenInUseAuthorization()
       
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        
        super.viewDidDisappear(animated)
        
       // locationManager.stopUpdatingLocation()
        
    }
    
    // MARK:- Custom methods
    
    // Setup current view
    func setUpView(){
        
        //hide navigation bar
        self.navigationController?.isNavigationBarHidden = true
        
        getAllPlaces()
      
    }
    @objc func pushNotificationHandler1(_ notification : NSNotification) {
        
        self.hidesBottomBarWhenPushed = true
        
        let cameraVC = self.storyboard?.instantiateViewController(withIdentifier: "ArCameraViewController") as? ArCameraViewController
        
        cameraVC!.isFromCameraButton = true
        
        self.navigationController?.pushViewController(cameraVC!, animated: true)
        
        self.hidesBottomBarWhenPushed = false
        
    }
    
    @objc func pushNotificationHandler(_ notification : NSNotification) {
        
        if let data = notification.userInfo as? [String:String]{
            
            let id = data["offer_Id"]
            
        WebServices.shared.getSingleOfferDetail(offerId: id!) { (status, data, error) in
      
            self.hidesBottomBarWhenPushed = true
            
            let cameraVC = self.storyboard?.instantiateViewController(withIdentifier: "ArCameraViewController") as? ArCameraViewController
            
            HelpingClass.shared.selectedOffer = data.first
            
            cameraVC?.isFromCameraButton = false
            
            cameraVC!.numberOfModels = 1
            
            self.present(cameraVC!, animated: true, completion: nil)
            
            self.hidesBottomBarWhenPushed = false
            
            }
            
        }
        
    }
    
    @IBAction func centerCameraButtonClicked(_ sender: Any) {
        
        let cameraVC = self.storyboard?.instantiateViewController(withIdentifier: "ArCameraViewController") as! ArCameraViewController
        
        cameraVC.isFromCameraButton = true
        
        cameraVC.numberOfModels = HelpingClass.shared.anywhereOffers.count
        
        self.present(cameraVC, animated: true, completion: nil)
        
    }
    
    // Load map
    func loadMap(){
        
        // Create a GMSCameraPosition that tells the map to display the
        if let currentLoc = HelpingClass.shared.currentLocation as? CLLocation{
            
        let camera = GMSCameraPosition.camera(withLatitude:currentLoc.coordinate.latitude, longitude: currentLoc.coordinate.longitude, zoom: 17)
            
        mapView.camera = camera
            
        mapView.isMyLocationEnabled = true
            
        mapView.delegate = self
            
            for (_,loc) in self.locations.enumerated(){
                
                setMarkers(location: CLLocationCoordinate2D(latitude: Double(loc.lat!) as! CLLocationDegrees, longitude: Double(loc.lng!) as! CLLocationDegrees),img:loc.client_details?.count != 0 ?  (loc.client_details?.first!.image)! : "https://nudgear.s3.us-east-2.amazonaws.com/images/subway.png", city: loc.city ?? "", storeName: loc.client_details?.count != 0 ? loc.client_details![0].name! : "", locData: loc)
                
            }
            
        }
        
    }
    
    func loadMapOffers(){
        
        // Create a GMSCameraPosition that tells the map to display the
        if let currentLoc = HelpingClass.shared.currentLocation as? CLLocation{
            
            let camera = GMSCameraPosition.camera(withLatitude:currentLoc.coordinate.latitude, longitude: currentLoc.coordinate.longitude, zoom: 17)
            
            mapView.camera = camera
            
            mapView.isMyLocationEnabled = true
            
            mapView.delegate = self
            
            for (_,loc) in self.storeLocations.enumerated(){
                if loc.offer_type == "Anywhere"{
                    HelpingClass.shared.anywhereOffers.append(loc)
                }else{
                if loc.lat != "" || loc.lng != ""{
                    
                    setMarkerss(location: CLLocationCoordinate2D(latitude: Double(loc.lat!) as! CLLocationDegrees , longitude: Double(loc.lng!) as! CLLocationDegrees) ,img: loc.clientdetails?.first?.image ?? "https://nudgear.s3.us-east-2.amazonaws.com/images/starbucks.png", city: loc.productdetails?.first?.name ?? "", storeName:loc.clientdetails?.first?.name ?? "Store", locData: loc,offerType: loc.offer_type ?? "1")
                    }
                }
            }
        }
    }
    
    func setMarkers(location:CLLocationCoordinate2D,img:String,city:String,storeName:String,locData:LocationsData){
        let url = URL(string: img)
        getData(from: url! ) { data, response, error in
            
            guard let data = data, error == nil else { return }
                        
            print("Download Finished")
            
            DispatchQueue.main.async() {
                
                //Add a pointer in image by merging pointer image and marker image
                let bottomImage = UIImage(named: "icons8-marker-100")
                
                let topImage = UIImage(data: data)!.addShadow()
                
                let size = CGSize(width: 100, height: 100)
                
                UIGraphicsBeginImageContext(size)
                
                let areaSize = CGRect(x: 0, y: 0, width: size.width, height: size.height)
                
                let areaSize2 = CGRect(x: 18, y: 05, width: 70, height: 70)
                
                bottomImage!.draw(in: areaSize)
                
                topImage.draw(in: areaSize2, blendMode: .normal, alpha: 1)
                
                let newImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
                
                UIGraphicsEndImageContext()
       
                // Creates a marker on the location provided on the map.
                let marker = GMSMarker()

                marker.position = location

                marker.title = storeName

                marker.snippet = city

                marker.icon = self.imageWithImage(image:newImage, scaledToSize: CGSize(width: 50, height: 50))//UIImage(data: data)

                marker.userData = locData

                marker.map = self.mapView
                
               
                
            }
            
        }
        
    }
    
    func setMarkerss(location:CLLocationCoordinate2D,img:String,city:String,storeName:String,locData:Offers_Data,offerType:String){
        
        getData(from: URL(string: img)!) { data, response, error in
            
            guard let data = data, error == nil else { return }

            print("Download Finished")
            
            DispatchQueue.main.async() {
                
                // Creates a marker on the location provided on the map.
                
//                let marker = GMSMarker()
//
//                marker.position = location
//
//                marker.title = storeName
//
//                marker.snippet = city
//
//                marker.icon = #imageLiteral(resourceName: "baloonOrange")//self.imageWithImage(image: UIImage(data: data)!, scaledToSize: CGSize(width: 50, height: 50))//UIImage(data: data)
//
//                marker.userData = locData
//
//                marker.map = self.mapView
                
                let item =
                    POIItem(position: location, name: storeName, image: #imageLiteral(resourceName: "ballon"), data: locData)
                
                self.clusterManager.add(item)
                
                if offerType == "Radial"{
                    
                    self.makeCircleRadiusAroundLocation(loc: location, radius: (Double("\(String(describing: locData.radius!))"))!)
                    
                }
                
            }
            
        }
        
    }
    
    func makeCircleRadiusAroundLocation(loc:CLLocationCoordinate2D,radius:Double){
        
        let circle = GMSCircle()
        
        circle.radius = radius // Meters
        
        circle.fillColor = UIColor.red.withAlphaComponent(0.3)
        
        circle.position = loc // Your CLLocationCoordinate2D  position
        
        circle.strokeWidth = 1;
        
        circle.strokeColor = UIColor.orange
        
        circle.map = self.mapView; // Add it to the map
        
    }
    
    func getAllPlaces(){
        
        WebServices.shared.getAllLocations(lat: 23.32, long: 24.23) { (status, data, err) in
            
            switch status{
                
            case true:
                
                self.locations = data!
                
                self.loadMap()
                
            case false: break
                
            }
            
        }
        
        WebServices.shared.getAllStoreLocations(lat: 23.3, long: 23.2) { (status, data, error) in
            
            switch status{
                
            case true:
                
                self.storeLocations = data!
                
                self.loadMapOffers()
                
            case false: break
                
            }
            
        }
        
    }
    
//    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
    
//        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    
//    }
//    
//    func imageWithImage(image:UIImage, scaledToSize newSize:CGSize) -> UIImage{
    
//        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
    
//        image.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
    
//        let newImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
    
//        UIGraphicsEndImageContext()
    
//        return newImage
    
//    }
    
    //MARK:- IBActions
    @IBAction func cameraButtonClicked(_ sender: Any) {
        
        getAllPlaces()
        
//        self.hidesBottomBarWhenPushed = true
        
//        let cameraVC = self.storyboard?.instantiateViewController(withIdentifier: "ArCameraViewController") as? ArCameraViewController
        
//        self.navigationController?.pushViewController(cameraVC!, animated: true)
        
//        self.hidesBottomBarWhenPushed = false
        
    }
    
}

extension MapViewController: GMSMapViewDelegate,GMUClusterManagerDelegate,GMUClusterRendererDelegate{
    
    func clusterManager(_ clusterManager: GMUClusterManager, didTap cluster: GMUCluster) -> Bool {
        let newCamera = GMSCameraPosition.camera(withTarget: cluster.position,
                                                 zoom: mapView.camera.zoom + 1)
        let update = GMSCameraUpdate.setCamera(newCamera)
        mapView.moveCamera(update)
        return true
    }
   
    func renderer(_ renderer: GMUClusterRenderer, willRenderMarker marker: GMSMarker) {
        // if your marker is pointy you can change groundAnchor
        marker.groundAnchor = CGPoint(x: 0.5, y: 1)
        if  let markerData = (marker.userData as? POIItem) {
            let icon = markerData.image.maskWithColor(color: .orange)
            marker.icon = icon
            marker.title = markerData.name
            marker.snippet = markerData.name
            marker.userData = markerData.data
        }
    }
    
    func clusterManager(_ clusterManager: GMUClusterManager, didTap clusterItem: GMUClusterItem) -> Bool {

        return true
    }
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        if let poiItem = marker.userData as? POIItem {
            NSLog("Did tap marker for cluster item \(String(describing: poiItem.name))")
            if (poiItem.data as? Offers_Data) != nil{
            HelpingClass.shared.checkIfLocationIsAccesiblee(myLocation: HelpingClass.shared.currentLocation, otherLocation: poiItem.data) { (status, error) in
                
                switch status{
                    
                case true:
                    
                    self.hidesBottomBarWhenPushed = true
                    
                    let cameraVC = self.storyboard?.instantiateViewController(withIdentifier: "ArCameraViewController") as? ArCameraViewController
                    
                    HelpingClass.shared.selectedOffer = poiItem.data
                    
                    cameraVC!.isFromCameraButton = false
                    
                    self.present(cameraVC!, animated: true, completion: nil)
                    //self.navigationController?.pushViewController(cameraVC!, animated: true)
                    
                    self.hidesBottomBarWhenPushed = false
                    
                case false:
                    
                    self.presentAlertWithTitle(title: "Nudge", message: "Unfortunately you are not in 50 meters of this location to avail your gifts.", options: "Ok") { (option) in
                        
                        print("option: \(option)")
                        
                        switch(option) {
                            
                        case 0:
                            
                            print("option one")
                            
                            break
                            
                        case 1:
                            
                            print("option two")
                            
                        default:
                            
                            break
                            
                        }
                        
                    }
                    
                }
                
            }
            }
            
        } else {
            NSLog("Did tap a normal marker")
        }
        return false
    }
    
    private func clusterManager(clusterManager: GMUClusterManager, didTapCluster cluster: GMUCluster) {
        let newCamera = GMSCameraPosition.camera(withTarget: cluster.position,
                                                           zoom: mapView.camera.zoom + 1)
        let update = GMSCameraUpdate.setCamera(newCamera)
        mapView.moveCamera(update)
    }
    
    func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker) {
    
    if let selectedMarkerData = marker.userData as? LocationsData{
 
    HelpingClass.shared.checkIfLocationIsAccesible(myLocation: HelpingClass.shared.currentLocation, otherLocation: selectedMarkerData) { (status, error) in
        
        switch status{
            
        case true:break
            
//            self.hidesBottomBarWhenPushed = true
            
//            let cameraVC = self.storyboard?.instantiateViewController(withIdentifier: "ArCameraViewController") as? ArCameraViewController
            
//            self.navigationController?.pushViewController(cameraVC!, animated: true)
            
//            self.hidesBottomBarWhenPushed = false
            
        case false:
            
            self.presentAlertWithTitle(title: "Nudge", message: "Unfortunately you are not in 50 meters of this location to avail your gifts.", options: "Ok") { (option) in
                
                print("option: \(option)")
                
                switch(option) {
                    
                case 0:
                    
                    print("option one")
                    
                    break
                    
                case 1:
                    
                    print("option two")
                    
                default:
                    
                    break
                    
                        }
                
                    }
            
                }
        
            }
        
        }
    
    if let selectedMarkerData1 = marker.userData as? Offers_Data{
        
        //let s = selectedMarkerData1
        
        HelpingClass.shared.checkIfLocationIsAccesiblee(myLocation: HelpingClass.shared.currentLocation, otherLocation: selectedMarkerData1) { (status, error) in
            
            switch status{
                
            case true:
                
                self.hidesBottomBarWhenPushed = true
                
                let cameraVC = self.storyboard?.instantiateViewController(withIdentifier: "ArCameraViewController") as? ArCameraViewController
                
                HelpingClass.shared.selectedOffer = selectedMarkerData1
                
                cameraVC!.isFromCameraButton = false
                
                self.present(cameraVC!, animated: true, completion: nil)
                //self.navigationController?.pushViewController(cameraVC!, animated: true)
                
                self.hidesBottomBarWhenPushed = false
                
            case false:
                
                self.presentAlertWithTitle(title: "Nudge", message: "Unfortunately you are not in \(selectedMarkerData1.radius!) meters of this location to avail your gifts.", options: "Ok") { (option) in
                    
                    print("option: \(option)")
                    
                    switch(option) {
                        
                    case 0:
                        
                        print("option one")
                        
                        break
                        
                    case 1:
                        
                        print("option two")
                        
                    default:
                        
                        break
                        
                        }
                    
                    }
                
                }
            
            }
        
        }
    
    }
    
}

/// Point of Interest Item which implements the GMUClusterItem protocol.
class POIItem: NSObject, GMUClusterItem {
    var position: CLLocationCoordinate2D
    var name: String!
    var image: UIImage
    var data: Offers_Data
    
    init(position: CLLocationCoordinate2D, name: String,image:UIImage,data:Offers_Data) {
        self.position = position
        self.name = name
        self.image = image
        self.data = data
    }
}
