import UIKit

class SimilarTableViewCell: UITableViewCell {
    static let identifier = "SimilarTableViewCell"
    
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
    
    private let movieSubtitle: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 10)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let bottomSpacingView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 4
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        stackView.addArrangedSubview(movieTitle)
        stackView.addArrangedSubview(movieSubtitle)
        
        return stackView
    }()
    
    override func prepareForReuse() {
        
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: -
    
    private func setupUI() {
        contentView.addSubview(movieImageView)
        contentView.addSubview(stackView)
        contentView.addSubview(bottomSpacingView)

        NSLayoutConstraint.activate([
            movieImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            movieImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            movieImageView.widthAnchor.constraint(equalToConstant: 60),
            movieImageView.heightAnchor.constraint(equalToConstant: 90),

            stackView.leadingAnchor.constraint(equalTo: movieImageView.trailingAnchor, constant: 8),
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),

            bottomSpacingView.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 42),
            bottomSpacingView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            bottomSpacingView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            bottomSpacingView.heightAnchor.constraint(equalToConstant: 12),
            bottomSpacingView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }

    
    // MARK: -
    
    func configure(image: String?, title: String, details: String) {
        if let image {
            movieImageView.loadImage(from: image)
        }
        movieTitle.text = title
        movieSubtitle.text = details
    }
}
