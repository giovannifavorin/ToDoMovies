import Foundation

struct MovieDetailDTO: Codable {
    let id: Int
    let title: String
    let releaseDate: String
    let posterPath: String

    enum CodingKeys: String, CodingKey {
        case id, title
        case releaseDate = "release_date"
        case posterPath = "poster_path"
    }
}
