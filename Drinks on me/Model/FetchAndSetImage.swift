//
//  unpackImage.swift
//  Drinks on me
//
//  Created by JimmyChao on 2023/8/16.
//

import Foundation
import UIKit


// MARK: - Unpack info
func fetchAndSet(info:SearchRecords.Drinks?, completion: @escaping((_ imageData:Data)->Void)){

    guard let info else{ return }
    //Attempt to load the drink's image.
    if let urlStr = info.fields.image.first?.thumbnails.large.url,
        let imageURL = URL(string: urlStr) {

        //Fetch the image data asynchronously.
        URLSession.shared.dataTask(with: imageURL) { data, _, _ in
            // Ensure the data is not nil.
            guard let imageData = data else {
                return
            }
            
            
            DispatchQueue.main.async {
                //Convert the data to a UIImage and set it to the cell's image view.
                completion(imageData)
                //self.drinksImageView.image = UIImage(data: imageData)
            }
        }.resume()
    }
}

