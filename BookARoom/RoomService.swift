import Combine
import Foundation

class RoomService {
    private static let userDefaultsKey = "rooms"
    
    @Published var rooms: [Room] = []
    private var cancellables: Set<AnyCancellable> = []
    
    private var cachedRooms: [Room] {
        if
            let data = UserDefaults.standard.value(forKey: RoomService.userDefaultsKey) as? Data,
            let cachedRooms = try? JSONDecoder().decode([Room].self, from: data)
        {
            return cachedRooms
        } else {
            return []
        }
    }
    
    init() {
        loadRooms()
    }
    
    private func loadRooms() {
        guard let url = URL(string: "https://wetransfer.github.io/rooms.json") else { return }
        URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(
                type: RoomResponse.self,
                decoder: JSONDecoder()
            )
            .receive(on: DispatchQueue.main)
            .map { $0.rooms }
            .replaceError(with: cachedRooms)
            .eraseToAnyPublisher()
            .sink(receiveValue: { [weak self] in
                self?.rooms = $0
                self?.saveRooms($0)
            })
            .store(in: &cancellables)
    }
    
    private func saveRooms(_ rooms: [Room]) {
        UserDefaults.standard.set(try? JSONEncoder().encode(rooms), forKey: RoomService.userDefaultsKey)
    }
}
