//
//  SideMenuViewController.swift
//  Nudge
//
//  Created by Simranjeet Singh on 10/09/19.
//  Copyright © 2019 Simranjeet Singh. All rights reserved.
//

import UIKit

class SideMenuViewController: UIViewController {
    
    @IBOutlet weak var sideMenuTableView: UITableView!
    
    @IBOutlet weak var userImageView: UIImageView!
    
    @IBOutlet weak var userDetailView: UIView!
    
    let titles = ["Payments","Invite friends","Get help","Settings","Privacy"]
    
      let icons = [#imageLiteral(resourceName: "payment"),#imageLiteral(resourceName: "profile 50X50"),#imageLiteral(resourceName: "help"),#imageLiteral(resourceName: "setting"),#imageLiteral(resourceName: "privacy")]
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        //Add shadow to userImage
        userImageView.dropShadow(color: .gray, opacity: 0.5, offSet: CGSize(width: -1, height: 1), radius: 20, scale: true)
        
       self.navigationController?.isNavigationBarHidden = true
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        
        print("dismissed")
        
        let application = UIApplication.shared.delegate as! AppDelegate
        
        let tabbarController = application.window?.rootViewController as! UITabBarController
        
        tabbarController.tabBar.items![4].image = #imageLiteral(resourceName: "more 50X50").withRenderingMode(.alwaysOriginal)
        
        tabbarController.tabBar.items![4].title = "More"
        
    }
    
}

extension SideMenuViewController:UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return titles.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "SideMenuCell", for: indexPath) as? SideMenuCell
        
        cell?.titleLbl.text = titles[indexPath.row]
        
        cell?.iconImgView.image = icons[indexPath.row]
        
        return cell!
    }
    
}
