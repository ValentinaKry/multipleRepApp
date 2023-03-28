
import Foundation

struct BitBucketModel: Codable {
    let values: [Value]
}

struct Value: Codable {
    let name, description: String
    let owner: Owner
}

struct Owner: Codable {
    let displayName: String
    let links: Links
    let type: TypeEnum
    let uuid: String
    let accountID, nickname, username: String?

    enum CodingKeys: String, CodingKey {
        case displayName = "display_name"
        case links, type, uuid
        case accountID = "account_id"
        case nickname, username
    }
}

struct Links: Codable {
    let linksSelf, avatar, html: Avatar

    enum CodingKeys: String, CodingKey {
        case linksSelf = "self"
        case avatar, html
    }
}

struct Avatar: Codable {
    let href: String
}

enum TypeEnum: String, Codable {
    case team = "team"
    case user = "user"
}
