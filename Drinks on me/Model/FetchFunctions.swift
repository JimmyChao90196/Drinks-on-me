//
//  unpackImage.swift
//  Drinks on me
//
//  Created by JimmyChao on 2023/8/16.
//

import Foundation
import UIKit


// MARK: - Unpack info

func fetchAndSet(info:SearchRoot.Drinks?, completion: @escaping((_ imageData:Data, _ name:String, _ desc:String, _ price:Int)->Void)){

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
            
            let description = info.fields.description
            let name = info.fields.name
            let price = info.fields.medium
            
            
            DispatchQueue.main.async {
                //Convert the data to a UIImage and set it to the cell's image view.
                completion(imageData,name,description,price)
                //self.drinksImageView.image = UIImage(data: imageData)
            }
        }.resume()
    }
}




// MARK: - Fetch and unwrap API

func fetchOrder(_ completion: @escaping ((_ fetchedOrderRoot:ResponseRoot) -> Void)){
    
    let urlStr = "https://api.airtable.com/v0/appN21f5f7mgnzUIi/order"
    
    if let url = URL(string: urlStr){
        var urlRequest = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData)
        urlRequest.httpMethod = "GET"
        urlRequest.setValue("Bearer patVvuJLhCGDlIA5N.bb43e3d5bf2d60015a897eff3ed89c044143a0c5fc967a59bcb9d20d8cc5043a", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: urlRequest) { data, _, _ in
            if let data{
                let decoder = JSONDecoder()
                //decoder.dateDecodingStrategy = .iso8601
                
                do {
                    let orderRoot = try decoder.decode(ResponseRoot.self, from: data)
                    
                    DispatchQueue.main.async {
                        
                        completion(orderRoot)
                        
                        //self.resultRecords = responseRecords
                        //self.tableView.reloadData()
                    }
                    
                } catch  {
                    print(error)
                }
            }
        }.resume()
    }
}

