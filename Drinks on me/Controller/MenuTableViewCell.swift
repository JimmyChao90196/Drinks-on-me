//
//  MenuTableViewCell.swift
//  Drinks on me
//
//  Created by JimmyChao on 2023/8/16.
//

import UIKit

class MenuTableViewCell: UITableViewCell {

    @IBOutlet var imageOfDrink: UIImageView!
    @IBOutlet var nameOfDrink: UILabel!
    
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
    
    static var reuseIdentifier:String {String("\(Self.self)")}
    
}
