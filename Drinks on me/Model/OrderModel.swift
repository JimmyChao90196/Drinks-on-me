//
//  CustomSectionView.swift
//  Drinks on me
//
//  Created by JimmyChao on 2023/8/17.
//

import Foundation
import UIKit

struct PostRoot: Codable {
    var records:[PostRecords]
}


struct PostRecords: Codable {
    var fields: PostFields
}


struct PostFields: Codable {
    var orderedDrinkName: String
    var sweetness: String
    var ice: String
    var clientName: String
    var notes: String
    var toppings: String
    var price: Int
    var size:String
}






struct ResponseRoot: Codable {
    var records: [ResponseRecords]
}

struct ResponseRecords: Codable {
    var id: String
    var createdTime: String
    var fields: ResponseFields
}

struct ResponseFields: Codable {
    var orderedDrinkName: String
    var notes: String
    var clientName: String
    var sweetness: String
    var ice: String
    var toppings: String
    var price: Int
}






// MARK: - Do not use this struct as decoding struct type

struct OrderInfo{
    var sweetness:String
    var ice:String
    var toppings:String
    var sizeDescription:String
    var price:Int
    var size:String {
        
        switch sizeDescription{
        case "中杯" : return "medium"
        case "大杯" : return "big"
        default : return "medium"
        }
    }
    
}
