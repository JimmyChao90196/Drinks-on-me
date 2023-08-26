//
//  DetailTableViewCell.swift
//  Drinks on me
//
//  Created by JimmyChao on 2023/8/17.
//

import UIKit

class DetailTableViewCell: UITableViewCell {

    
    
    // MARK: - Prepare for reuse

    override func prepareForReuse() {
        
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
        self.textLabel?.text = nil
        self.imageView?.image = nil
        self.backgroundColor = .white
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}



extension UITableViewCell{
    
    static var reusableIdentifier:String {String("\(Self.self)")}
    
}
