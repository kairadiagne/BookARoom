import UIKit

class RoomCollectionViewCell: UICollectionViewCell {
    
    private let thumbnailImageView = UIImageView()
    private let nameLabel = UILabel()
    private let spotsLabel = UILabel()
    private let bookButton = UIButton()
    private let stackView = UIStackView()
    
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
    
    func configure(for room: Room) {
        nameLabel.text = room.name
        spotsLabel.text = "\(room.spots) spots remaining"
        bookButton.setTitle("Book", for: .normal)
        bookButton.setTitle("Book", for: .disabled)
        if room.spots == 0 {
            bookButton.isEnabled = false
            bookButton.backgroundColor = .gray
        } else {
            bookButton.isEnabled = true
            bookButton.backgroundColor = .purple
        }
        
        thumbnailImageView.image = UIImage(named: "thumbnailPlaceholder")
    }
}
