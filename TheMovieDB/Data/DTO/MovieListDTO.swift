struct MovieListDTO: Codable {
    let page: Int
    let results: [MovieDTO]
    let totalPages: Int
    let total_results: Int
    
    enum CodingKeys: String, CodingKey {
        case page, results,total_results
        case totalPages = "total_pages"
    }
    
    static func toEntity(dto: MovieListDTO) -> ([Movie], Int) {
        let movies = dto.results.map { $0.toEntity() }
        return (movies, dto.totalPages)
    }
}

struct MovieDTO: Codable {
    let id: Int
    let title: String
    let posterPath: String?
    
    enum CodingKeys: String, CodingKey {
        case id, title
        case posterPath = "poster_path"
    }
    
    func toEntity() -> Movie {
        return Movie(id: id, title: title, posterPath: posterPath)
    }
}
