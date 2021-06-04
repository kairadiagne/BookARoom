import Combine
import Foundation
import UIKit

class RoomCellViewModel {
    
    var name: String
    @Published var spotsLeft: String = ""
    var buttonTitle = "Book"
    @Published var thumbnailImage: UIImage?
    
    private var spots: Int {
        didSet {
            spotsLeft = "\(spots) spots remaining"
        }
    }
    var buttonEnabled: Bool
    var buttonBackgroundColor: UIColor {
        buttonEnabled ? .purple : .gray
    }
    
    private var cancellables: Set<AnyCancellable> = []
    
    init(with room: Room) {
        name = room.name
        spots = room.spots
        spotsLeft = "\(spots) spots remaining"
        buttonEnabled = room.spots > 0
        if let url = URL(string: room.thumbnail) {
            loadImage(from: url)
        }
    }
    
    private func loadImage(from url: URL) {
        URLSession.shared.dataTaskPublisher(for: url)
            .map { UIImage(data: $0.data) }
            .replaceError(with: UIImage(named: "thumbnailPlaceholder"))
            .subscribe(on: DispatchQueue.global(qos: .background))
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
            .sink(receiveValue: { [weak self] image in
                self?.thumbnailImage = image
            })
            .store(in: &cancellables)
    }
    
    func bookRoom() {
        guard let url = URL(string: "https://wetransfer.github.io/bookRoom.json") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = try? JSONEncoder().encode(["name": self.name])
        URLSession.shared.dataTaskPublisher(for: request)
            .map(\.response)
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
            .sink(
                receiveCompletion: { _ in },
                receiveValue: { [weak self] _ in
                    self?.spots -= 1
                }
            )
            .store(in: &cancellables)
    }
}
