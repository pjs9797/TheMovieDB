struct YoutubeListDTO: Codable {
    let id: Int
    let results: [YoutubeDTO]
    
    static func toEntity(dto: YoutubeListDTO) -> [Youtube] {
        return dto.results
            .filter { $0.site == "YouTube" }
            .map { Youtube(name: $0.name, key: $0.key) }
    }
}

struct YoutubeDTO: Codable {
    let name: String
    let key: String
    let site: String
    
    enum CodingKeys: String, CodingKey {
        case name
        case key
        case site
    }
}
