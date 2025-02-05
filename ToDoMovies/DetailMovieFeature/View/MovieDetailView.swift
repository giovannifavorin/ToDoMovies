import UIKit

class MovieDetailView: UIView {
    let titleLabel = UILabel()
    let overviewLabel = UILabel()
    let posterImageView = UIImageView()
    let similarMoviesLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    private func setupUI() {
        backgroundColor = .white
        
        titleLabel.font = UIFont.boldSystemFont(ofSize: 24)
        titleLabel.textAlignment = .center
        
        overviewLabel.font = UIFont.systemFont(ofSize: 16)
        overviewLabel.numberOfLines = 0
        
        similarMoviesLabel.font = UIFont.boldSystemFont(ofSize: 18)
        
        posterImageView.contentMode = .scaleAspectFit
        posterImageView.translatesAutoresizingMaskIntoConstraints = false
        posterImageView.heightAnchor.constraint(equalToConstant: 300).isActive = true
        
        let stackView = UIStackView(arrangedSubviews: [titleLabel, posterImageView, overviewLabel, similarMoviesLabel])
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20)
        ])
    }
}
