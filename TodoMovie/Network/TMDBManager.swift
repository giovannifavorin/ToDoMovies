import Foundation

struct TMDBManager {
    private let baseURL = "https://api.themoviedb.org/3"
    private let apiKey = "dadd177eaeebc3c53fcfc68cfcfb2bd3"
    private let session = URLSession.shared
    
    private func fetchData(endpoint: String, parameters: [String: String]) async throws -> Data {
        guard var components = URLComponents(string: "\(baseURL)\(endpoint)") else {
            throw URLError(.badURL)
        }
        
        var queryItems = [URLQueryItem(name: "api_key", value: apiKey)]
        for (key, value) in parameters {
            queryItems.append(URLQueryItem(name: key, value: value))
        }
        components.queryItems = queryItems
        
        guard let url = components.url else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.timeoutInterval = 10
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        let (data, response) = try await session.data(for: request)
        
        if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != 200 {
            let errorMessage = String(data: data, encoding: .utf8) ?? "Erro desconhecido"
            throw NSError(domain: "TMDBManager", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: errorMessage])
        }
        
        return data
    }
    
    func getGenres(language: String = "en-US") async throws -> GenreResponse {
        let data = try await fetchData(endpoint: "/genre/movie/list", parameters: ["language": language])
        let genreResponse = try JSONDecoder().decode(GenreResponse.self, from: data)
        return genreResponse
    }
    
    func getSimilarMovies(for movieID: Int, language: String = "en-US", page: Int = 1) async throws -> SimilarMoviesResponse {
        let data = try await fetchData(endpoint: "/movie/\(movieID)/similar", parameters: [
            "language": language,
            "page": "\(page)"
        ])
        let movieResponse = try JSONDecoder().decode(SimilarMoviesResponse.self, from: data)
        
        return movieResponse
    }
    
    func getMovieDetails(for movieID: Int, language: String = "en-US") async throws -> MovieDetailDTO {
        let data = try await fetchData(endpoint: "/movie/\(movieID)", parameters: [
            "language": language
        ])
        let movieDetail = try JSONDecoder().decode(MovieDetailDTO.self, from: data)
        return movieDetail
    }
}
