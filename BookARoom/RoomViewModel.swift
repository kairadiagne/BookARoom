import Combine
import Foundation

class RoomViewModel {
 
    @Published var rooms: [Room] = [] {
        didSet {
            print(rooms)
        }
    }
    private var service: RoomService
    private var cancellables: Set<AnyCancellable> = []
    
    init(with service: RoomService = RoomService()) {
        self.service = service
    }
    
    func loadRooms() {
        service
            .roomsPublisher?
            .map(\.data)
            .decode(
                type: RoomResponse.self,
                decoder: JSONDecoder()
            )
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    print("finished")
                    break
                case .failure(let error):
                    print(error.localizedDescription)
                    break
                }
            },
                receiveValue: { [weak self] in
                    self?.rooms = $0.rooms
            })
            .store(in: &cancellables)
    }
}
