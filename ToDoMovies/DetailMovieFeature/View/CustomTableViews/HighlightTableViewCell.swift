import UIKit

class HighlightTableViewCell: UITableViewCell {
    static let identifier = "HighlightTableViewCell"
    var viewModel: ViewModel?

    private let movieImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let movieTitle: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let likes: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let popularity: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var addLike: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "heart"), for: .normal)
        button.setImage(UIImage(systemName: "heart.fill"), for: .selected)
        button.addTarget(self, action: #selector(didTapLike), for: .touchUpInside)
        return button
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        stackView.addArrangedSubview(movieTitle)
        stackView.addArrangedSubview(likes)
        stackView.addArrangedSubview(popularity)
        stackView.addArrangedSubview(addLike)
        
        return stackView
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        contentView.addSubview(movieImageView)
        contentView.addSubview(stackView)

        NSLayoutConstraint.activate([
            // Constraints da imagem do filme
            movieImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            movieImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            movieImageView.widthAnchor.constraint(equalToConstant: 100),
            movieImageView.heightAnchor.constraint(equalToConstant: 150),
            
            // Constraints do stackView
            stackView.leadingAnchor.constraint(equalTo: movieImageView.trailingAnchor, constant: 8),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            stackView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            // Ajustando a altura mínima da célula
            contentView.bottomAnchor.constraint(greaterThanOrEqualTo: stackView.bottomAnchor, constant: 8)
        ])
    }


    func configure(image: String, title: String, like: Bool, popularity: String, voteCount: String, viewModel: ViewModel) {
        movieImageView.loadImage(from: image)
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
