import UIKit

class FooterTableViewCell: UITableViewCell {
    static let identifier = "FooterTableViewCell"
    var viewModel: ViewModel?
    
    private let likeButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "heart"), for: .normal)
        button.setImage(UIImage(systemName: "heart.fill"), for: .selected)
        button.setTitle("Curtir", for: .normal)
        button.setTitle("Curtido", for: .selected)
        button.setTitleColor(.black, for: .normal)
        button.setTitleColor(.white, for: .selected)
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.cornerRadius = 8
        button.addTarget(FooterTableViewCell.self, action: #selector(didTapLike), for: .touchUpInside)
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
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
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
            
            likeButton.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.95),
            addToListButton.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.95)
        ])
    }
    
    func configure(like: Bool, viewModel: ViewModel) {
        self.viewModel = viewModel
        likeButton.isSelected = like
    }
    
    @objc private func didTapLike() {
        viewModel?.toggleLike()
        likeButton.isSelected.toggle()
    }
}
