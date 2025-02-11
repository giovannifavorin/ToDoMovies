import Combine
import UIKit

class ViewModel {
    private let tmdbManager = TMDBManager()
    private var cancellables = Set<AnyCancellable>()
    
    @Published var sections: [SectionStructure] = []
    
    var movieDetails: MovieDetail?
    var similarMovies: [SimilarMovie] = []
    var genres: [GenreDTO] = []
    
    func updateSections() {
        sections = []
        
        if let movieDetails = movieDetails {
            sections.append(.highlight(movieDetails))
        }
        
        if !similarMovies.isEmpty {
            sections.append(.movie(similarMovies))
        }
        
        sections.append(.footer)
    }
    
    func fetchAllMovieData(movieID: Int) {
        Task {
            do {
                genres = try await tmdbManager.getGenres().genres
                
                let movieDetailDTO = try await tmdbManager.getMovieDetails(for: movieID)
                movieDetails = .init(from: movieDetailDTO)
                
                let similarMoviesResponseDTO = try await tmdbManager.getSimilarMovies(for: movieID)
                similarMovies = similarMoviesResponseDTO.results.compactMap { similarMovie in
                    let similarMovieGenres = genres.filter { similarMovie.genreIDs.contains($0.id) }
                    
                    guard similarMovie.posterPath != nil else { return nil }
                    
                    return SimilarMovie(from: similarMovie, from: similarMovieGenres)
                }
                
                updateSections()
            } catch {
                print("Error fetching movie data: \(error)")
            }
        }
    }
    
    func fetchGenres() {
        Task {
            do {
                genres = try await tmdbManager.getGenres().genres
            } catch {
                print("Error with genres: \(error)")
            }
        }
    }
    
    func fetchMovieDetails(movieID: Int) {
        Task {
            do {
                let movieDetailDTO = try await tmdbManager.getMovieDetails(for: movieID)
                movieDetails = .init(from: movieDetailDTO)
                
            } catch {
                print("Error with movie details: \(error)")
            }
        }
    }

    func fetchSimilarMovies(movieID: Int) {
        Task {
            do {
                let similarMoviesResponseDTO = try await tmdbManager.getSimilarMovies(for: movieID)
                
                similarMovies = similarMoviesResponseDTO.results.compactMap { similarMovie in
                    let similarMovieGenres = genres.filter { similarMovie.genreIDs.contains($0.id) }
                    
                    guard similarMovie.posterPath != nil else { return nil }
                    
                    return SimilarMovie(from: similarMovie, from: similarMovieGenres)
                }
                
            } catch {
                print("Error with similar movies: \(error)")
            }
        }
    }
}

extension ViewModel {
    struct SimilarMovie {
        let id: Int
        let title: String
        let releaseDate: String
        let posterPath: String?
        let genres: [GenreDTO]
        
        init(from dto: SimilarMovieDTO, from genres: [GenreDTO]) {
            self.id = dto.id
            self.title = dto.title
            self.releaseDate = dto.releaseDate
            self.posterPath = dto.posterPath
            self.genres = genres
        }
    }
    
    struct MovieDetail {
        let id: Int
        let title: String
        let posterPath: String
        var like: Bool = false
        let popularity: Double
        let voteCount: Double
        
        init(from dto: MovieDetailDTO) {
            self.id = dto.id
            self.title = dto.title
            self.posterPath = dto.posterPath
            self.popularity = dto.popularity
            self.voteCount = dto.voteCount
        }
    }
    
    enum SectionStructure {
        case highlight ( MovieDetail )
        case movie ( [SimilarMovie] )
        case footer
    }
}

extension ViewModel {
    func formatNumber(value: Double) -> String {
        if value >= 1_000_000 {
            return String(format: "%.1fM", Double(value) / 1_000_000)
        } else if value >= 1_000 {
            return String(format: "%.1fk", Double(value) / 1_000)
        } else {
            return String(format: "%.1f", value) + "k"
        }
    }
    
    func formatYear(from dateString: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        
        if let date = dateFormatter.date(from: dateString) {
            let yearFormatter = DateFormatter()
            yearFormatter.dateFormat = "yyyy"
            return yearFormatter.string(from: date)
        }
        
        return dateString
    }
    
    func toggleLike() {
        movieDetails?.like.toggle()
    }
}
