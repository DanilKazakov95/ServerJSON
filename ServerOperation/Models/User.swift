import Foundation

struct User: Codable {
    var address: Address?
    var email: String
    var id: Int
    var name: String
    var phone: String
    var username: String
    var website: String
    
}

struct Address: Codable {
    var geo: Geo
    var street: String
    var city: String
}

struct Geo: Codable {
    var lat: String
    var lng: String
}

extension User {
    enum CodingKeys: String, CodingKey {
        case email
        case id
        case name
        case phone
        case username
        case website
        case address
    }
}

extension Address {
    enum CodingKeys: String, CodingKey {
        case street
        case city
        case geo
    }
}

extension Geo {
    enum CodingKeys: String, CodingKey {
        case lat
        case lng
    }
}
