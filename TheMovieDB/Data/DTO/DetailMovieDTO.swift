struct DetailMovieDTO: Codable {
    let posterPath: String?
    let title: String
    let overview: String?
    let releaseDate: String
    let voteAverage: Double?

    enum CodingKeys: String, CodingKey {
        case posterPath = "poster_path"
        case title
        case overview
        case releaseDate = "release_date"
        case voteAverage = "vote_average"
    }
    
    static func toEntity(dto: DetailMovieDTO) -> DetailMovie {
        return DetailMovie(posterPath: dto.posterPath, originalTitle: dto.title, overview: dto.overview, releaseDate: dto.releaseDate, voteAverage: dto.voteAverage)
    }
}
