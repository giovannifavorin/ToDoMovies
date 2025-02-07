import Foundation

struct SimilarMoviesResponse: Codable {
    let results: [SimilarMovieDTO]
}

struct SimilarMovieDTO: Codable {
    let id: Int
    let title: String
    let releaseDate: String
    let posterPath: String?
    let genreIDs: [Int]

    enum CodingKeys: String, CodingKey {
        case id, title
        case genreIDs = "genre_ids"
        case releaseDate = "release_date"
        case posterPath = "poster_path"
    }
}

struct GenreDTO: Codable {
    let id: Int
    let name: String
}

struct GenreResponse: Codable {
    let genres: [GenreDTO]
}
