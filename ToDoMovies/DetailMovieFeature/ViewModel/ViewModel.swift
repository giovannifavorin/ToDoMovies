import Foundation
import UIKit

class MovieDetailViewModel {
    private let tmdbManager = TMDBManager()
    
    var movieDetails: ((MovieDetail) -> Void)?
    var similarMovies: (([String]) -> Void)?
    
    func fetchMovieDetails(movieID: Int) {
        Task {
            do {
                let data = try await tmdbManager.getMovieDetails(for: movieID)
                let movieDetails = try JSONDecoder().decode(MovieDetail.self, from: data)
                DispatchQueue.main.async {
                    self.movieDetails?(movieDetails)
                }
            } catch {
                print("Erro ao buscar detalhes do filme: \(error)")
            }
        }
    }
    
    func fetchSimilarMovies(movieID: Int) {
        Task {
            do {
                let data = try await tmdbManager.getSimilarMovies(for: movieID)
                let similarMoviesResponse = try JSONDecoder().decode(SimilarMoviesResponse.self, from: data)
                
                let similarTitles = similarMoviesResponse.results.prefix(5).map { $0.title }
                DispatchQueue.main.async {
                    self.similarMovies?(similarTitles)
                }
            } catch {
                print("Erro ao buscar filmes similares: \(error)")
            }
        }
    }
}
