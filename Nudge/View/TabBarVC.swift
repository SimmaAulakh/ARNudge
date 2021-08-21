//
//  TabBarVC.swift
//  Nudge
//
//  Created by Dcube Ventures on 11/09/19.
//  Copyright © 2019 Dcube Ventures. All rights reserved.
//

import UIKit

import SideMenu

class TabBarVC: UITabBarController,UITabBarControllerDelegate {

    static let shared = TabBarVC()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.delegate = self
        
        self.tabBar.tintColor = #colorLiteral(red: 0.4694690108, green: 0.8134422898, blue: 0.7779573798, alpha: 1)
        
        let controller1 = generateNavController(identifier: "MapViewController", image: #imageLiteral(resourceName: "map"), selectedImage: #imageLiteral(resourceName: "map-2"), title: "Map")
        
        let controller2 = generateNavController(identifier: "SearchViewController", image: #imageLiteral(resourceName: "wallet 50X50"), selectedImage: #imageLiteral(resourceName: "wallet-1"), title: "Wallet")
        
        let controller5 = MoreInfoViewController()
        
        controller5.tabBarItem.image = #imageLiteral(resourceName: "more 50X50").withRenderingMode( .alwaysOriginal )
        
        controller5.tabBarItem.selectedImage = #imageLiteral(resourceName: "more-1").withRenderingMode(.alwaysOriginal)
        
        controller5.tabBarItem.title = "More"
        
        let controller3 = NudgeViewController()
        
        controller3.tabBarItem.image = #imageLiteral(resourceName: "camera-1").withRenderingMode( .alwaysOriginal )
        
        controller3.tabBarItem.selectedImage = #imageLiteral(resourceName: "camera-1").withRenderingMode(.alwaysOriginal)
        
        controller3.tabBarItem.imageInsets = UIEdgeInsets(top: -40, left: 0, bottom: -6, right: 0)
        
        let controller4 = MyProfileViewController()
        
        controller4.tabBarItem.image = #imageLiteral(resourceName: "bell-1").withRenderingMode( .alwaysOriginal )
        
        controller4.tabBarItem.selectedImage = #imageLiteral(resourceName: "bell2").withRenderingMode(.alwaysOriginal)
        
        controller4.tabBarItem.title = "Notifications"
        
        viewControllers = [controller1,controller2,controller3,controller4,controller5]
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        NotificationCenter.default.addObserver(self, selector: #selector(changeIndexOfTabbar), name: NSNotification.Name("changeIndexOfTab"), object: nil)
        
    }
    
    @objc func changeIndexOfTabbar(){
        
             self.selectedIndex = 1
       
    }

     func generateNavController(identifier:String,image:UIImage,selectedImage:UIImage,title:String)-> UINavigationController{
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: identifier)
        
        let navigationController = UINavigationController(rootViewController: vc!)
        
        navigationController.tabBarItem.image = image.withRenderingMode( .alwaysOriginal )
        
        navigationController.tabBarItem.selectedImage = selectedImage.withRenderingMode( .alwaysOriginal )
        
        navigationController.tabBarItem.title = title
        
        return navigationController
    }
    
    func setSelectedIndex(index:Int){
        
        self.selectedIndex = index
        
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        
        switch selectedIndex {
            
        case 0:break
            
        case 1:break
            
        case 2:break
            
        case 3:break
            
        default:
            
            break
            
        }
        
    }
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
      
        if viewController.isKind(of: MoreInfoViewController.self){
            
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "SideMenuViewController") as? SideMenuViewController
            
            let menu = SideMenuNavigationController(rootViewController: vc!)
            
            menu.statusBarEndAlpha = 0
            
            menu.enableSwipeToDismissGesture = true
            
            present(menu, animated: true, completion: nil)
            
            viewController.tabBarItem.image = #imageLiteral(resourceName: "more-1").withRenderingMode(.alwaysOriginal)
            
            viewController.tabBarItem.title = ""
            
            return false
            
        }else if viewController.isKind(of: MyProfileViewController.self){
            
             return false
            
        }else if viewController.isKind(of: NudgeViewController.self){
            
            let cameraVC = self.storyboard?.instantiateViewController(withIdentifier: "ArCameraViewController") as! ArCameraViewController
            
            cameraVC.isFromCameraButton = true
            
            cameraVC.numberOfModels = HelpingClass.shared.anywhereOffers.count
            
            self.present(cameraVC, animated: true, completion: nil)
            
            return false
        }
        
        tabBar.items![4].image = #imageLiteral(resourceName: "more 50X50").withRenderingMode(.alwaysOriginal)
        
        return true
        
    }
    
}
