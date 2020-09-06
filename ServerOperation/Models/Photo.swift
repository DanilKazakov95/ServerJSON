//
//  Photos.swift
//  ServerOperation
//
//  Created by Данил Казаков on 29/11/2018.
//  Copyright © 2018 Danil Moguchiy. All rights reserved.
//

import Foundation


struct UserPhoto: Codable {
    let data: [Photo]
}

struct Photo: Codable {
    var albumId: Int
    var id: Int
    var title: String
    var url: String
}

extension UserPhoto {
    enum CodingKeys: String, CodingKey {
        case data
    }
}

extension Photo {
    enum CodingKeys: String, CodingKey {
        case albumId
        case id
        case title
        case url
    }
}
