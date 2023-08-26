//
//  CustomSectionView.swift
//  Drinks on me
//
//  Created by JimmyChao on 2023/8/17.
//

import Foundation
import UIKit



// MARK: - Patch structure model

struct PatchRoot: Codable {
    var records:[PatchRecords]
}


struct PatchRecords: Codable {
    var fields: PatchFields
    var id:String
}


struct PatchFields: Codable {

    var cups:Int
}




// MARK: - Post structure model

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
    var clientName: String = "defaul client"
    var notes: String = "none"
    var toppings: String
    var price: Int
    var originPrice:Int
    var size:String
    var cups:Int
    var menuID:String
    
}




// MARK: - Response structure model

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
    var originPrice:Int
    var cups:Int
    var menuID:String
}






// MARK: - Do not use these struct as decoding struct type

struct OrderInfo{
    var sweetness:String
    var ice:String
    var toppings:String
    //var sizeDescription:String
    var price:Int
    var cups:Int
    var size:String
}



struct PatchInfo{
    
    var cups:Int = 0
    var price:Int = 0
}


var totalPrice = 0




