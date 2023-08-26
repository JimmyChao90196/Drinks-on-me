//
//  CartTableViewCell.swift
//  Drinks on me
//
//  Created by JimmyChao on 2023/8/18.
//

import UIKit

class CartTableViewCell: UITableViewCell {

    
    


    @IBOutlet var clientNameLabel: UILabel!
    @IBOutlet var orderedBGView: UIView!
    @IBOutlet var priceLable: UILabel!
    @IBOutlet var cupStepper: UIStepper!
    @IBOutlet var orderDrinkName: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialize  bg code
        orderedBGView.layer.cornerRadius = 20
        orderedBGView.backgroundColor = .lightGray
        orderedBGView.layer.opacity = 0.9
        orderedBGView.layer.borderWidth = 2
        orderedBGView.layer.borderColor = .init(red: 0.8, green: 0.75, blue: 0.4, alpha: 0.95)
        
        
        
        //Initialize stepper value
        cupStepper.value = 0
        
        //Initialize stepper appearance
        cupStepper.layer.cornerRadius = 10
        cupStepper.layer.backgroundColor = UIColor.lightGray.cgColor
        
    }

    
    
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
