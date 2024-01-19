//
//  Model.swift
//  BinetProject
//
//  Created by Вячеслав Вовк on 17.01.2024.
//

import Foundation
import RxDataSources


struct Preparat: Decodable, IdentifiableType, Equatable {
    
    
    
    
    
    
    static func == (lhs: Preparat, rhs: Preparat) -> Bool {
        return true
    }
    
    
    typealias Identity = Int
    var identity: Identity { return id }
    
    let id: Int
    
    let image: String?
    let categories: Categories?
    let name, description: String?
    let documentation: String?
    let fields: [Field]?
    
    // MARK: - Categories
    struct Categories: Decodable {
        let id: Int?
        let icon: String?
        let image: String?
        let name: String?
    }
    
    // MARK: - Field
    struct Field: Decodable {
        let types_id: Int?
        let type, name, value: String?
        let image: String?
        let flags: Flags?
        let show, group: Int?
        
        // MARK: - Flags
        struct Flags: Decodable {
            let html, noValue, noName, noImage: Int?
            let noWrap, noWrapName, system: Int?
        }
    }
    
    
}


struct Preparats: AnimatableSectionModelType {
    var identity: String
    
    typealias Identity = String
    
    var preparats: [Preparat]
}

extension Preparats {
    typealias Item = Preparat

    var items: [Preparat] { return preparats }

    init(original: Preparats, items: [Preparat]) {
        self = original
        preparats = items
    }
}
