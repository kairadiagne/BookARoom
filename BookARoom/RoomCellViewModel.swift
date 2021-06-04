import Combine
import Foundation
import UIKit

class RoomCellViewModel {
    
    var name: String
    var spotsLeft: String
    var buttonTitle = "Book"
    @Published var thumbnailImage: UIImage?
    
    var buttonEnabled: Bool
    var buttonBackgroundColor: UIColor {
        buttonEnabled ? .purple : .gray
    }
    
    private var cancellables: Set<AnyCancellable> = []
    
    init(with room: Room) {
        name = room.name
        spotsLeft = "\(room.spots) spots remaining"
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
}
