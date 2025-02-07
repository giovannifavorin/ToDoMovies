import Foundation

struct MovieDetailDTO: Codable {
    let id: Int
    let title: String
    let popularity: Double
    let posterPath: String
    let voteCount: Double

    enum CodingKeys: String, CodingKey {
        case id, title, popularity
        case posterPath = "poster_path"
        case voteCount = "vote_count"
    }
}
