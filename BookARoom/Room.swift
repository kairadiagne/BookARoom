import Foundation

struct RoomResponse: Codable {
    var rooms: [Room]
}

struct Room: Codable, Hashable {
    var name: String
    var spots: Int
    var thumbnail: String
}
