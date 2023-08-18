//
//  CartTableViewCell.swift
//  Drinks on me
//
//  Created by JimmyChao on 2023/8/18.
//

import UIKit

class CartTableViewCell: UITableViewCell {

    
    

    @IBOutlet var orderDrinkName: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    
    
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
