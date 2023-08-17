//
//  DetailTableViewCell.swift
//  Drinks on me
//
//  Created by JimmyChao on 2023/8/17.
//

import UIKit

class DetailTableViewCell: UITableViewCell {


    @IBOutlet var minPrice: UILabel!
    @IBOutlet var drinkDescription: UITextView!
    @IBOutlet var drinkName: UILabel!
    @IBOutlet var drinkImage: UIImageView!
    
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}



extension UITableViewCell{
    
    static var reusableIdentifier:String {String("\(Self.self)")}
    
}
