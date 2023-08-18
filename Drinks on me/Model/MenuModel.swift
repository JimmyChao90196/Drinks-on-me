//
//  MenuModel.swift
//  Drinks on me
//
//  Created by JimmyChao on 2023/8/16.
//

import Foundation
import UIKit











// MARK: - Decoding and encoding structure

struct SearchRoot:Codable{
    
    let records:[Drinks]
        
    struct Drinks:Codable{
        let id:String
        let fields:Info
        
        struct Info:Codable {
            let name:String
            let description:String
            let category:String
            let image:[ImageInfo]
            let big:Int
            let medium:Int
            let toppings:[String]
            
            struct ImageInfo:Codable{
                let id:String
                let url:String
                let thumbnails:ThumbnailsDetail
                
                struct ThumbnailsDetail:Codable{
                    let small:DetailElement
                    let large:DetailElement
                    struct DetailElement:Codable{
                        let url:String
                    }
                }
            }
        }
    }
}


