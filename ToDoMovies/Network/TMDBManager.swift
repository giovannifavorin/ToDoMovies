import Foundation

struct TMDBManager {
    private let baseURL = "https://api.themoviedb.org/3"
    private let apiKey = "dadd177eaeebc3c53fcfc68cfcfb2bd3"
    private let session = URLSession.shared

    func getSimilarMovies(for movieID: Int, language: String = "en-US", page: Int = 1) async throws -> Data {
        guard var components = URLComponents(string: "\(baseURL)/movie/\(movieID)/similar") else {
            throw URLError(.badURL)
        }

        components.queryItems = [
            URLQueryItem(name: "api_key", value: apiKey),
            URLQueryItem(name: "language", value: language),
            URLQueryItem(name: "page", value: "\(page)")
        ]

        guard let url = components.url else {
            throw URLError(.badURL)
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.timeoutInterval = 10
        request.setValue("application/json", forHTTPHeaderField: "Accept")

        let (data, _) = try await session.data(for: request)
        return data
    }
    
    func getMovieDetails(for movieID: Int, language: String = "en-US") async throws -> Data {
            guard var components = URLComponents(string: "\(baseURL)/movie/\(movieID)") else {
                throw URLError(.badURL)
            }

            components.queryItems = [
                URLQueryItem(name: "api_key", value: apiKey),
                URLQueryItem(name: "language", value: language)
            ]

            guard let url = components.url else {
                throw URLError(.badURL)
            }

            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            request.timeoutInterval = 10
            request.setValue("application/json", forHTTPHeaderField: "Accept")

            let (data, _) = try await session.data(for: request)
            return data
        }
}
