import UIKit

class FooterTableViewCell: UICollectionViewCell {
    static let identifier = "FooterTableViewCell"
    var viewModel: ViewModel?
    
    private lazy var likeButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "heart")?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.setImage(UIImage(systemName: "heart.fill")?.withRenderingMode(.alwaysTemplate), for: .selected)
        button.setTitle("Curtir", for: .normal)
        button.setTitle("Curtido", for: .selected)
        button.setTitleColor(.white, for: .normal)
        button.setTitleColor(.black, for: .selected)
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.cornerRadius = 8
        button.backgroundColor = .clear
        button.tintColor = .white
        button.addTarget(self, action: #selector(didTapLike), for: .touchUpInside)
        return button
    }()
    
    private let addToListButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Adicionar às Minhas Listas", for: .normal)
        button.setTitle("Adicionado às Minhas Listas", for: .selected)
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.cornerRadius = 8
        return button
    }()
    
    private let credits: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 12)
        label.text = "Lista enviada por @TodoMoviesApp"
        return label
    }()
    
    private lazy var stackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [likeButton, addToListButton, credits])
        stack.axis = .vertical
        stack.spacing = 8
        stack.alignment = .center
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
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
        
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            
            likeButton.heightAnchor.constraint(equalToConstant: 40),
            addToListButton.heightAnchor.constraint(equalTo: likeButton.heightAnchor),
            
            likeButton.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.98),
            addToListButton.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.98),
        ])
    }
    
    func configure(like: Bool, viewModel: ViewModel) {
        self.viewModel = viewModel
        updateLikeButton()
    }

    @objc private func didTapLike() {
        viewModel?.toggleLike()
        updateLikeButton()
    }
    
    private func updateLikeButton() {
        guard let isLiked = viewModel?.movieDetails?.like else { return }
        likeButton.isSelected = isLiked
        likeButton.backgroundColor = isLiked ? .white : .clear
        likeButton.tintColor = isLiked ? .black : .white
    }
}
