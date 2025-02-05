import Foundation

struct MovieDetail: Codable {
    let id: Int
    let title: String
    let tagline: String?
    let overview: String
    let release_date: String
    let runtime: Int
    let budget: Int
    let revenue: Int
//    let genre_ids: [Genre]
    let poster_path: String?
    let backdrop_path: String
    let vote_average: Double
    let vote_count: Int
    let imdbId: String?
    let original_language: String
//    let productionCompanies: [ProductionCompany]
}

struct Genre: Codable {
    let id: Int
    let name: String
}

struct ProductionCompany: Codable {
    let id: Int
    let name: String
    let logoPath: String?
    let originCountry: String
}
