//
//  Tasks.swift
//  ServerOperation
//
//  Created by Данил Казаков on 03/12/2018.
//  Copyright © 2018 Danil Moguchiy. All rights reserved.
//

import Foundation

struct Task: Codable {
    var id: Int
    var title: String
    var body: String
}

extension Task {
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case body
    }
}
