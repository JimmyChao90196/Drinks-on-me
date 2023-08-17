//
//  CustomSectionView.swift
//  Drinks on me
//
//  Created by JimmyChao on 2023/8/17.
//

import Foundation
import UIKit

struct Root: Codable {
    let records: [Record]
}

struct Record: Codable {
    let fields: Fields
}

struct Fields: Codable {
    let name: String
    let sweetness: String
    let ice: String
    let clientName: String
    let notes: String
    let toppings: String
    let price: Int
}


