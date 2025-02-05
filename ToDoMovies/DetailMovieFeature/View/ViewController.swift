import UIKit

class ViewController: UIViewController {
    private let viewModel = MovieDetailViewModel()
    private let movieID = 550 // Fight Club
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let movieDetailView = MovieDetailView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBindings()
        viewModel.fetchMovieDetails(movieID: movieID)
        viewModel.fetchSimilarMovies(movieID: movieID)
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        movieDetailView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(movieDetailView)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            movieDetailView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            movieDetailView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            movieDetailView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            movieDetailView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20)
        ])
    }
    
    private func setupBindings() {
        viewModel.movieDetails = { [weak self] movieDetails in
            self?.movieDetailView.titleLabel.text = movieDetails.title
            self?.movieDetailView.overviewLabel.text = movieDetails.overview
            if let posterPath = movieDetails.poster_path {
                self?.movieDetailView.posterImageView.loadImage(from: "https://image.tmdb.org/t/p/w500\(posterPath)")
            }
        }
        
        viewModel.similarMovies = { [weak self] similarTitles in
            self?.movieDetailView.similarMoviesLabel.text = "Filmes Similares: \(similarTitles.joined(separator: ", "))"
        }
    }
}

