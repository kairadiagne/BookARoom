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
    
    private lazy var diffableDataSource = UICollectionViewDiffableDataSource<Section, Room>(collectionView: collectionView) { collectionView, indexPath, room in
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RoomCollectionViewCell", for: indexPath)
        if let roomCell = cell as? RoomCollectionViewCell {
            roomCell.configure(for: RoomCellViewModel(with: room))
        }
        return cell
    }
    
    init(with viewModel: RoomViewModel = RoomViewModel()) {
        layout = RoomViewController.generateLayout()
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        configureCollectionView()
        view.backgroundColor = .white
        viewModel
            .$rooms
            .sink(receiveValue: createSnapshot(with:))
            .store(in: &cancellables)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureCollectionView() {
        collectionView.register(RoomCollectionViewCell.self, forCellWithReuseIdentifier: "RoomCollectionViewCell")
        collectionView.backgroundColor = .clear
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate(
            [
                collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
                collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
                collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
                collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
            ]
        )
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
        roomItem.contentInsets = NSDirectionalEdgeInsets(top: 4, leading: 4, bottom: 4, trailing: 4)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalWidth(2/3)
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

