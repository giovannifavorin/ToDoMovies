import Combine
import UIKit

class ViewModel {
    private let tmdbManager = TMDBManager()
    private var cancellables = Set<AnyCancellable>()
    
    
    @Published var sections: [SectionStructure] = []
    
    var movieDetails: MovieDetail?
    var similarMovies: [SimilarMovie] = []
    var genres: [GenreDTO] = []
    
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
                
                guard let movieDetails = movieDetails else { return }
                
                sections.append(.highlight(movieDetails))
            } catch {
                print("Error with movie details: \(error)")
            }
        }
    }
    
    func fetchSimilarMovies(movieID: Int) {
        Task {
            do {
                let similarMoviesResponseDTO = try await tmdbManager.getSimilarMovies(for: movieID)
                
                var similarMoviesAux: [SimilarMovie] = []
                for similarMovie in similarMoviesResponseDTO.results {
                    var similarMovieGenres: [GenreDTO] = []
                    
                    for genreID in similarMovie.genreIDs {
                        if let genre = genres.filter({ $0.id == genreID }).first {
                            similarMovieGenres.append(genre)
                        }
                    }
                    similarMoviesAux.append(.init(from: similarMovie, from: similarMovieGenres))
                }
                
                similarMovies = similarMoviesAux
                
                sections.append(.movie(similarMovies))
                sections.append(.footer)
                
                
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
        let releaseDate: String
        let posterPath: String
        var like: Bool = false
        
        init(from dto: MovieDetailDTO) {
            self.id = dto.id
            self.title = dto.title
            self.releaseDate = dto.releaseDate
            self.posterPath = dto.posterPath
        }
    }
    
    enum SectionStructure {
        case highlight ( MovieDetail )
        case movie ( [SimilarMovie] )
        case footer
    }

}

//tenho q ajustar a view para apresentar os dados
//Collection view
//Table View V
//
