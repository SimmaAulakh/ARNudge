//
//  OfferViewController.swift
//  Nudge
//
//  Created by Simranjeet Singh on 10/09/19.
//  Copyright © 2019 Simranjeet Singh. All rights reserved.
//

import UIKit
import SDWebImage

class OfferViewController: UIViewController {

    @IBOutlet weak var backgroundBlurView: UIVisualEffectView!
    
    @IBOutlet weak var clientNameLbl: UILabel!
    
    @IBOutlet weak var clientImageView: UIImageView!
    
    @IBOutlet weak var productImageView: UIImageView!
    
    var isFromCameraButton = false
    
    override func viewDidLoad() {
        
        super.viewDidLoad()

        setUpUI()
        claimOffer()
        
    }
    
    func setUpUI(){
        
        if isFromCameraButton{
            configureView(offerDetails:HelpingClass.shared.anywhereOffers[0])
        }else{
        if let offerDetails = HelpingClass.shared.selectedOffer{
          configureView(offerDetails:offerDetails)
            }
        }
    }
    
    func configureView(offerDetails:Offers_Data){
        self.productImageView.sd_setImage(with: URL(string:(offerDetails.productdetails?.first!.image)!) , placeholderImage: nil)
        
        self.clientImageView.sd_setImage(with: URL(string:(offerDetails.clientdetails?.first!.image)!) , placeholderImage: nil)
        
        self.clientNameLbl.text = "Reward from \(String(describing: (offerDetails.clientdetails?.first?.name!)!))"
    }
    
    func claimOffer(){
        
        //Make the entry in database to save claimed offer
        
        if isFromCameraButton{
            if HelpingClass.shared.anywhereOffers.count >= 1{
                claimOfferService(offer:HelpingClass.shared.anywhereOffers[0])
            }
            
        }else{
        
        if let offer = HelpingClass.shared.selectedOffer{
            claimOfferService(offer:offer)
        }
        }
    }
    
    func claimOfferService(offer:Offers_Data){
        let deviceId = UIDevice.current.identifierForVendor!.uuidString
        
        WebServices.shared.claimOffer(user_id: "1", device_id: deviceId, client_id: (offer.client_id)!, product_id: (offer.product_id!), offer_id: (offer._id!)) { (status, message, error) in
            
        }
    }

    @IBAction func gotoWalletBtnPressed(_ sender: Any) {
        
        //Set the root view controller as tabbar
        let tabBar = self.storyboard?.instantiateViewController(withIdentifier: "TabBarVC") as? TabBarVC
        
        tabBar?.selectedIndex = 1
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        appDelegate.window = UIWindow(frame: UIScreen.main.bounds)
        
        appDelegate.window?.rootViewController = tabBar
        
        appDelegate.window?.makeKeyAndVisible()
        
        // Notification is fired to make the index of tab to 1
        NotificationCenter.default.post(name: NSNotification.Name("changeIndexOfTab"), object: nil)
        
        //Pause AR session
        NotificationCenter.default.post(name: NSNotification.Name("InvalidateARSession"), object: nil)
       
    }
    
    @IBAction func dismissButtonClicked(_ sender: Any) {
        
        NotificationCenter.default.post(name: NSNotification.Name("ResetTracking"), object: nil, userInfo: nil)
        self.dismiss(animated: true) {
            
        }
    }
}
