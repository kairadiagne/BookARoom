import Combine
import UIKit

class RoomCollectionViewCell: UICollectionViewCell {
    
    private let thumbnailImageView = UIImageView()
    private let nameLabel = UILabel()
    private let spotsLabel = UILabel()
    private let bookButton = UIButton()
    private let stackView = UIStackView()
    
    private var cancellables: Set<AnyCancellable> = []
    private var viewModel: RoomCellViewModel?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        clipsToBounds = true
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.spacing = 6
        
        thumbnailImageView.translatesAutoresizingMaskIntoConstraints = false
        thumbnailImageView.contentMode = .scaleAspectFill
        thumbnailImageView.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
        thumbnailImageView.layer.cornerRadius = 8
        thumbnailImageView.layer.masksToBounds = true
        
        stackView.addArrangedSubview(thumbnailImageView)
        
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        stackView.addArrangedSubview(nameLabel)
        
        spotsLabel.translatesAutoresizingMaskIntoConstraints = false
        stackView.addArrangedSubview(spotsLabel)
        
        bookButton.translatesAutoresizingMaskIntoConstraints = false
        bookButton.layer.cornerRadius = 4
        stackView.addArrangedSubview(bookButton)
        
        contentView.addSubview(stackView)
        NSLayoutConstraint.activate(
            [
                bookButton.heightAnchor.constraint(equalToConstant: 32),
                stackView.topAnchor.constraint(equalTo: contentView.topAnchor),
                stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
                stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
                stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
            ]
        )
        contentView.backgroundColor = .white
    }
    
    func configure(for viewModel: RoomCellViewModel) {
        self.viewModel = viewModel
        nameLabel.text = viewModel.name
        spotsLabel.text = viewModel.spotsLeft
        bookButton.setTitle(viewModel.buttonTitle, for: .normal)
        bookButton.setTitle(viewModel.buttonTitle, for: .disabled)
        bookButton.isEnabled = viewModel.buttonEnabled
        bookButton.backgroundColor = viewModel.buttonBackgroundColor
        
        viewModel
            .$thumbnailImage
            .sink { [weak self] image in
                self?.thumbnailImageView.image = image
            }
            .store(in: &cancellables)
    }
}
