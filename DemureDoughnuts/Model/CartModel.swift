//
//  CartModel.swift
//  DemureDoughnuts
//
//  Created by Kris Sawyerr on 9/12/24.
//

import Foundation

struct CartModel: Identifiable {
    let id: Int
    let name: String
    let image: String
    let cost: Double
    let quantity: Int
}
