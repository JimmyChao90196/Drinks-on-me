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
        
        imageOfDrink.layer.shadowRadius = 15
        imageOfDrink.layer.cornerRadius = 10
        imageOfDrink.layer.opacity = 0.85
        imageOfDrink.layer.borderWidth = 2
        imageOfDrink.layer.borderColor = UIColor.init(red: 0.8, green: 0.75, blue: 0.3, alpha: 0.95).cgColor
            
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageOfDrink.image = UIImage(systemName: "photo")
    }
    
    

}







extension UITableViewCell{
    
    static var reuseIdentifier:String {String("\(Self.self)")}
    
}
