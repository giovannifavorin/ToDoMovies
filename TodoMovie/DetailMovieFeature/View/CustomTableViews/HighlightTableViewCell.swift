import UIKit

class HighlightTableViewCell: UICollectionViewCell {
    static let identifier = "HighlightTableViewCell"
    var viewModel: ViewModel?

    private let movieImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let movieTitle: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let likes: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let popularity: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var addLike: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        let heartImage = UIImage(systemName: "heart")?.withRenderingMode(.alwaysTemplate)
        let heartFilledImage = UIImage(systemName: "heart.fill")?.withRenderingMode(.alwaysTemplate)
        button.setImage(heartImage, for: .normal)
        button.setImage(heartFilledImage, for: .selected)
        button.imageView?.contentMode = .scaleAspectFit
        button.contentVerticalAlignment = .fill
        button.contentHorizontalAlignment = .fill
        button.tintColor = .white
        button.addTarget(self, action: #selector(didTapLike), for: .touchUpInside)
        return button
    }()
    
    private let heartIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "heart.fill")?.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = .white
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let eyeIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "eye.fill")?.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = .gray
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private lazy var likesStack: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        stackView.addArrangedSubview(heartIcon)
        stackView.addArrangedSubview(likes)
        
        return stackView
    }()
    
    private lazy var popularityStack: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        stackView.addArrangedSubview(eyeIcon)
        stackView.addArrangedSubview(popularity)
        
        return stackView
    }()
    
    private lazy var infoStack: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 16
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        stackView.addArrangedSubview(likesStack)
        stackView.addArrangedSubview(popularityStack)
        
        return stackView
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        stackView.addArrangedSubview(movieTitle)
        stackView.addArrangedSubview(infoStack)

        
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        contentView.addSubview(stackView)
        contentView.addSubview(addLike)

        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            stackView.trailingAnchor.constraint(equalTo: addLike.leadingAnchor, constant: -8),
            stackView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),

            addLike.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            addLike.centerYAnchor.constraint(equalTo: movieTitle.centerYAnchor),
            addLike.widthAnchor.constraint(equalToConstant: 30),
            addLike.heightAnchor.constraint(equalToConstant: 30),

            contentView.bottomAnchor.constraint(greaterThanOrEqualTo: stackView.bottomAnchor, constant: 8),

            heartIcon.widthAnchor.constraint(equalToConstant: 18),
            heartIcon.heightAnchor.constraint(equalToConstant: 18),

            eyeIcon.widthAnchor.constraint(equalToConstant: 18),
            eyeIcon.heightAnchor.constraint(equalToConstant: 18)
        ])
    }

    func configure(title: String, like: Bool, popularity: String, voteCount: String, viewModel: ViewModel) {
        movieTitle.text = title
        likes.text = voteCount
        self.popularity.text = popularity
        self.viewModel = viewModel

        addLike.isSelected = like
    }

    @objc private func didTapLike() {
        viewModel?.toggleLike()
        addLike.isSelected.toggle()
    }
}
