import Combine
import Foundation

class RoomViewModel {
    
    @Published var rooms: [Room] = []
    private var service: RoomService
    private var cancellables: Set<AnyCancellable> = []
    
    init(with service: RoomService = RoomService()) {
        self.service = service
        service
            .$rooms
            .sink(receiveValue: { [weak self] in
                self?.rooms = $0
            })
            .store(in: &cancellables)
    }
}
