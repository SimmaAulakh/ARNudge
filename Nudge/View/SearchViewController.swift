//
//  SearchViewController.swift
//  Nudge
//
//  Created by Simranjeet Singh on 10/09/19.
//  Copyright © 2019 Simranjeet Singh. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {

    @IBOutlet weak var searchTableView: UITableView!
    
    @IBOutlet weak var searchBarr: UISearchBar!
    
    var myClaimedOffers:[MyOffersData] = []
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.navigationController?.isNavigationBarHidden = true
        
        searchTableView.rowHeight = UITableView.automaticDimension
        
        searchTableView.estimatedRowHeight = 160
        
        searchBarr.delegate = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
         getMyClaimedOffers()
      
    }
    
    func getMyClaimedOffers(){
        
        let deviceId = UIDevice.current.identifierForVendor!.uuidString
        
        WebServices.shared.getMyOffers(deviceId: deviceId) { (status, claimedOffers, error) in
            
            switch status{
                
            case true:
                
                self.myClaimedOffers = claimedOffers
                
                self.searchTableView.reloadData()
                
                HelpingClass.shared.delay(1.0) {
                    
                self.searchTableView.reloadData()
                    
                }
                
            case false:break
                
            }
            
        }
        
    }
    
    @IBAction func centerCameraBtnClicked(_ sender: Any) {
        
        let cameraVC = self.storyboard?.instantiateViewController(withIdentifier: "ArCameraViewController") as! ArCameraViewController
        
        cameraVC.isFromCameraButton = true
        
        cameraVC.numberOfModels = HelpingClass.shared.anywhereOffers.count
        
        self.present(cameraVC, animated: true, completion: nil)
        
    }
    
}

extension SearchViewController:UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
        
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        return "Rewards"
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 1
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchCell", for: indexPath) as? SearchCell
        
        cell!.myOffers = self.myClaimedOffers
        
        cell!.searchCollectionView.reloadData()
        
        return cell!
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableView.automaticDimension
        
    }
    
}

extension SearchViewController:UISearchBarDelegate{
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
     
    }
}
