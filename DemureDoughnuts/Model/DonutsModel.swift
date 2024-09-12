//
//  DonutsModel.swift
//  DemureDoughnuts
//
//  Created by Kris Sawyerr on 9/11/24.
//

import Foundation

struct DonutsModel: Identifiable {
    var id: String {
        name
    }
    
    let cost: Double
    let image: String
    let name: String
    let type: String
}
