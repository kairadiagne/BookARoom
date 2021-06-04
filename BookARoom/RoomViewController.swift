import Combine
import UIKit

class RoomViewController: UIViewController {
    
    private enum Section: Hashable {
        case rooms
    }
    
    private let collectionView: UICollectionView
    private let layout: UICollectionViewCompositionalLayout
    private var cancellables: Set<AnyCancellable> = []
    
    private var viewModel: RoomViewModel
    
    private lazy var diffableDataSource = UICollectionViewDiffableDataSource<Section, Room>(collectionView: collectionView) { collectionView, IndexPath, room in
        return UICollectionViewCell()
    }
    
    init(with viewModel: RoomViewModel = RoomViewModel()) {
        layout = RoomViewController.generateLayout()
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        viewModel
            .$rooms
            .sink(receiveValue: createSnapshot(with:))
            .store(in: &cancellables)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.loadRooms()
    }
    
    func configure() {
        
    }
    
    private func createSnapshot(with rooms: [Room]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Room>()
        snapshot.appendSections([.rooms])
        snapshot.appendItems(rooms, toSection: .rooms)
        diffableDataSource.apply(snapshot)
    }
    
    private static func generateLayout() -> UICollectionViewCompositionalLayout {
        let roomSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0)
        )
        
        let roomItem = NSCollectionLayoutItem(layoutSize: roomSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalWidth(1.0)
        )
        
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitem: roomItem,
            count: 2
        )
        
        let section = NSCollectionLayoutSection(group: group)
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
}

