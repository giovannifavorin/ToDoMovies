import Foundation

struct SimilarMoviesResponse: Codable {
    let results: [SimilarMovie]
}

struct SimilarMovie: Codable {
    let id: Int
    let title: String
    let overview: String
    let release_date: String
    let vote_average: Double
    let vote_count: Int
    let poster_path: String?
//    let backdrop_path: String
    let genre_ids: [Int]
    
}
