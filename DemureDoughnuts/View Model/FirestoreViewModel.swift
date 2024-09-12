//
//  FirestoreViewModel.swift
//  DemureDoughnuts
//
//  Created by Kris Sawyerr on 9/11/24.
//

import Foundation
import Firebase

class FirestoreViewModel: ObservableObject {
    @Published var categories: [CategoriesModel] = []
    @Published var donuts: [DonutsModel] = []
    private var db = Firestore.firestore()
    
    init() {
        fetchCategories()
        fetchDonuts()
    }

    func fetchCategories() {
        db.collection("categories").getDocuments { (snapshot, error) in
            if let error = error {
                print("Error getting documents: \(error)")
            } else {
                if let snapshot = snapshot {
                    self.categories = snapshot.documents.compactMap { doc in
                        guard let image = doc["image"] as? String, let id = doc["id"] as? Int, let name = doc["name"] as? String else {
                            return nil
                        }
                        return CategoriesModel(id: id, image: image, name: name)
                    }
                }
            }
        }
    }
    
    func fetchDonuts() {
        db.collection("donuts").getDocuments { (snapshot, error) in
            if let error = error {
                print("Error getting documents: \(error)")
            } else {
                if let snapshot = snapshot {
                    self.donuts = snapshot.documents.compactMap { doc in
                        guard let cost = doc["cost"] as? Double, let image = doc["image"] as? String, let name = doc["name"] as? String, let type = doc["type"] as? String else {
                            return nil
                        }
                        print(name)
                        return DonutsModel(cost: cost, image: image, name: name, type: type)
                    }
                }
            }
        }
    }
}
