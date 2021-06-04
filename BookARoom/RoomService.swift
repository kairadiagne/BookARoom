import Foundation

struct RoomService {
    var roomsPublisher: URLSession.DataTaskPublisher? {
        guard let url = URL(string: "https://wetransfer.github.io/rooms.json") else { return nil }
        return URLSession.shared.dataTaskPublisher(for: url)
    }
}
