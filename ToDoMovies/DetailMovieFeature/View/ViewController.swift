import UIKit
import Combine

class ViewController: UIViewController {
    private let viewModel = ViewModel()
    private let movieID = 550
    
    private let tableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.showsHorizontalScrollIndicator = false
        tableView.separatorStyle = .none
        tableView.estimatedRowHeight = 44
        tableView.rowHeight = UITableView.automaticDimension
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    var store = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        //        setupBindings()
        setupTableView()
        viewModel.fetchGenres()
        viewModel.fetchMovieDetails(movieID: movieID)
        viewModel.fetchSimilarMovies(movieID: movieID)
        
        viewModel.$sections.receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                guard let self else { return }
                UIView.performWithoutAnimation {
                    self.tableView.reloadData()
                }
            }
            .store(in: &store)
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
    
    func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.register(SimilarTableViewCell.self, forCellReuseIdentifier: SimilarTableViewCell.identifier)
        //        tableView.register(FooterTableViewCell.self, forCellReuseIdentifier: FooterTableViewCell.identifier)
        //        tableView.register(HighlightTableViewCell.self, forCellReuseIdentifier: HighlightTableViewCell.identifier)
    }
    
    //    private func setupBindings() {
    //        viewModel.movieDetails = { [weak self] movieDetails in
    //            self?.movieDetailView.titleLabel.text = movieDetails.title
    //            if let posterPath = movieDetails.posterPath {
    //                self?.movieDetailView.posterImageView.loadImage(from: "https://image.tmdb.org/t/p/w500\(posterPath)")
    //            }
    //        }
    //
    //        viewModel.similarMovies = { [weak self] similarTitles in
    //            self?.movieDetailView.updateSimilarMovies(similarTitles)
    //        }
    //    }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
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
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = self.viewModel.sections[indexPath.section]
        
        switch row {
        case .highlight(_):
            return UITableViewCell()
        case .movie(let movies):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SimilarTableViewCell.identifier, for: indexPath) as? SimilarTableViewCell else { return UITableViewCell() }
            let movie = movies[indexPath.row]
            
            let genresString = movie.genres.map { $0.name }.joined(separator: ", ")
            if let posterPath = movie.posterPath {
                let fullImageURL = "https://image.tmdb.org/t/p/w500\(posterPath)"
                cell.configure(image: fullImageURL, title: movie.title, details: "\(movie.releaseDate) | \(genresString)")
            }
            
            
            return cell
        case .footer:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}
