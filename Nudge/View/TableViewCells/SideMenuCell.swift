//
//  SideMenuCell.swift
//  Nudge
//
//  Created by Dcube Ventures on 30/09/19.
//  Copyright © 2019 Dcube Ventures. All rights reserved.
//

import UIKit

class SideMenuCell: UITableViewCell {

    @IBOutlet weak var iconImgView: UIImageView!
    
    @IBOutlet weak var titleLbl: UILabel!
    
  
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
