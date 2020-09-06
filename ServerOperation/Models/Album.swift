//
//  Album.swift
//  ServerOperation
//
//  Created by Данил Казаков on 26/11/2018.
//  Copyright © 2018 Danil Moguchiy. All rights reserved.
//

import Foundation

struct UserAlbum: Codable {
    let data: [Album]
    
}

struct Album: Codable {
    var id: Int
    var userId: Int
    var title: String
}

struct FailableDecodable<Base : Decodable> : Decodable {
    
    let base: Base?
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        self.base = try? container.decode(Base.self)
    }
}

struct FailableCodableArray<Element : Codable> : Codable {
    
    var elements: [Element]
    
    init(from decoder: Decoder) throws {
        
        var container = try decoder.unkeyedContainer()
        
        var elements = [Element]()
        if let count = container.count {
            elements.reserveCapacity(count)
        }
        
        while !container.isAtEnd {
            if let element = try container
                .decode(FailableDecodable<Element>.self).base {
                
                elements.append(element)
            }
        }
        
        self.elements = elements
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(elements)
    }
}

extension Album {
    enum CodingKeys: String, CodingKey {
        case id
        case userId
        case title
    }
}

extension UserAlbum {
    enum CodingKeys: String, CodingKey {
        case data
    }
}
