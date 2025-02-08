import UIKit
import Combine

class ViewController: UIViewController {
    private let viewModel = ViewModel()
    private let movieID = 550
    var store = Set<AnyCancellable>()
    
    private let headerHeight: CGFloat = 300
    private let maxHeaderHeight: CGFloat = 600
    
    private lazy var collectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewCompositionalLayout { sectionIndex, _ -> NSCollectionLayoutSection? in
            return self.createSectionLayout(sectionIndex: sectionIndex)
        })
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBindings()
        setupTableView()
        
        viewModel.fetchGenres()
        viewModel.fetchMovieDetails(movieID: movieID)
        viewModel.fetchSimilarMovies(movieID: movieID)
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
    
    func setupTableView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.register(SimilarTableViewCell.self, forCellWithReuseIdentifier: SimilarTableViewCell.identifier)
        collectionView.register(FooterTableViewCell.self, forCellWithReuseIdentifier: FooterTableViewCell.identifier)
        collectionView.register(HighlightTableViewCell.self, forCellWithReuseIdentifier: HighlightTableViewCell.identifier)
        
        collectionView.register(ImageHeaderCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: ImageHeaderCollectionReusableView.identifier)
    }
    
    private func setupBindings() {
        viewModel.$sections.receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                guard let self else { return }
                UIView.performWithoutAnimation {
                    self.collectionView.reloadData()
                }
            }
            .store(in: &store)
    }
    
    func createSectionLayout(sectionIndex: Int) -> NSCollectionLayoutSection {
        let section = self.viewModel.sections[sectionIndex]
        
        switch section {
        case .highlight:
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                  heightDimension: .estimated(44))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                   heightDimension: .estimated(44))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
            
            group.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16)
            
            let section = NSCollectionLayoutSection(group: group)
            section.interGroupSpacing = 16
            
            // Configuração do header
            let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                    heightDimension: .absolute(300))
            let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: headerSize,
                elementKind: UICollectionView.elementKindSectionHeader,
                alignment: .top)
            
            sectionHeader.pinToVisibleBounds = false
            sectionHeader.zIndex = -1
            
            section.boundarySupplementaryItems = [sectionHeader]
            section.contentInsets = NSDirectionalEdgeInsets(top: 20, leading: 0, bottom: 0, trailing: 0)
            
            return section
        default:
            let spacing: CGFloat = 16
            let contentInsets: NSDirectionalEdgeInsets = NSDirectionalEdgeInsets(top: 16, leading: 16, bottom: 16, trailing: 16)
            
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(44))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(44))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
            
            let section = NSCollectionLayoutSection(group: group)
            section.interGroupSpacing = spacing
            section.contentInsets = contentInsets
            
            return section
        }
    }
}

extension ViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if section == 0 {
            return CGSize(width: collectionView.bounds.width, height: headerHeight)
        }
        return .zero
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        
        if let header = collectionView.supplementaryView(forElementKind: UICollectionView.elementKindSectionHeader, at: IndexPath(item: 0, section: 0)) {
            if offsetY < 0 {
                let stretchAmount = min(-offsetY, maxHeaderHeight - headerHeight)
                let scale = 1 + (stretchAmount / headerHeight)
                
                header.frame.origin.y = offsetY
                header.frame.size.height = headerHeight + stretchAmount
                
                let translateY = (header.frame.height - headerHeight) / 2
                if let imageView = header.subviews.first as? UIImageView {
                    imageView.transform = CGAffineTransform(scaleX: scale, y: scale).concatenating(CGAffineTransform(translationX: 0, y: -translateY))
                }
            } else {
                header.frame.size.height = headerHeight
                
                if let imageView = header.subviews.first as? UIImageView {
                    imageView.transform = .identity
                }
            }
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return viewModel.sections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let row = self.viewModel.sections[section]
        
        switch row {
        case .highlight:
            return 1
        case .movie(let movies):
            return movies.count
        case .footer:
            return 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        guard kind == UICollectionView.elementKindSectionHeader else { return UICollectionReusableView() }
        
        let section = self.viewModel.sections[indexPath.section]
        
        switch section {
        case .highlight(let model):
            guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: ImageHeaderCollectionReusableView.identifier, for: indexPath) as? ImageHeaderCollectionReusableView else { return UICollectionReusableView() }
            
            let fullImageURL = "https://image.tmdb.org/t/p/w500\(model.posterPath)"
            header.configure(image: fullImageURL)
            
            return header
        default:
            return UICollectionReusableView()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let row = self.viewModel.sections[indexPath.section]
        
        switch row {
        case .highlight(_):
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HighlightTableViewCell.identifier, for: indexPath) as? HighlightTableViewCell else { return UICollectionViewCell() }
            guard let movie = viewModel.movieDetails else { return UICollectionViewCell() }
            
            let formattedPopularity = viewModel.formatNumber(value: movie.popularity)
            let formattedVoteCount = viewModel.formatNumber(value: movie.voteCount)
            cell.configure(title: movie.title, like: movie.like, popularity: formattedPopularity, voteCount: formattedVoteCount, viewModel: viewModel)
            
            return cell
            
        case .movie(let movies):
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SimilarTableViewCell.identifier, for: indexPath) as? SimilarTableViewCell else { return UICollectionViewCell() }
            let movie = movies[indexPath.row]
            
            let genresString = movie.genres.map { $0.name }.joined(separator: ", ")
            
            if let posterPath = movie.posterPath {
                let fullImageURL = "https://image.tmdb.org/t/p/w500\(posterPath)"
                let formattedYear = viewModel.formatYear(from: movie.releaseDate)
                cell.configure(image: fullImageURL, title: movie.title, details: "\(formattedYear)  \(genresString)")
            }
            
            return cell
            
        case .footer:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FooterTableViewCell.identifier, for: indexPath) as? FooterTableViewCell else { return UICollectionViewCell() }
            guard let movie = viewModel.movieDetails else { return UICollectionViewCell() }
            cell.configure(like: movie.like, viewModel: viewModel)
            return cell
        }
    }
}

extension ViewController {
    class ImageHeaderCollectionReusableView: UICollectionReusableView {
        static let identifier = "ImageHeaderCollectionReusableView"
        
        private let imageView: UIImageView = {
            let image = UIImageView()
            image.contentMode = .scaleAspectFill
            image.clipsToBounds = true
            image.translatesAutoresizingMaskIntoConstraints = false
            return image
        }()
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            addSubview(imageView)
            
            NSLayoutConstraint.activate([
                imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
                imageView.trailingAnchor.constraint(equalTo: trailingAnchor),
                imageView.topAnchor.constraint(equalTo: topAnchor),
                imageView.bottomAnchor.constraint(equalTo: bottomAnchor)
            ])
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        func configure(image: String) {
            imageView.loadImage(from: image)
        }
    }
}

// como arrumar o header
// Fazer animacao
// fazer o botao de adicionar na lista funcionar
