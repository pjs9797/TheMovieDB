import Foundation
import Moya

enum MovieAPIService {
    case sortByPopularity(page: Int)
    case sortByRating(page: Int)
    case sortByNew(page: Int)
    case searchMovies(title: String, page: Int)
    case detailMoive(id: Int)
    case youtubeList(id: Int)
}

extension MovieAPIService: TargetType {
    var baseURL: URL { return URL(string: "https://api.themoviedb.org/3")! }
    var path: String {
        switch self {
        case .sortByPopularity:
            return "movie/popular"
        case .sortByRating:
            return "movie/top_rated"
        case .sortByNew:
            return "movie/now_playing"
        case .searchMovies:
            return "search/movie"
        case .detailMoive(let id):
            return "movie/\(id)"
        case .youtubeList(let id):
            return "movie/\(id)/videos"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .sortByPopularity:
            return .get
        case .sortByRating:
            return .get
        case .sortByNew:
            return .get
        case .searchMovies:
            return .get
        case .detailMoive:
            return .get
        case .youtubeList:
            return .get
        }
    }
    
    var task: Task {
        switch self {
        case .sortByPopularity(let page):
            return .requestParameters(parameters: ["language": "en-US", "page": page], encoding: URLEncoding.queryString)
        case .sortByRating(let page):
            return .requestParameters(parameters: ["language": "en-US", "page": page], encoding: URLEncoding.queryString)
        case .sortByNew(let page):
            return .requestParameters(parameters: ["language": "en-US", "page": page], encoding: URLEncoding.queryString)
        case .searchMovies(let title, let page):
            return .requestParameters(parameters: ["query": title, "include_adult": "false", "language": "en-US", "page": page], encoding: URLEncoding.queryString)
        case .detailMoive:
            return .requestParameters(parameters: ["language": "en-US"], encoding: URLEncoding.queryString)
        case .youtubeList:
            return .requestParameters(parameters: ["language": "en-US"], encoding: URLEncoding.queryString)
        }
    }
    
    var headers: [String : String]? {
        let token = "eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiIxZjZlNTQ3MjNhYjc2NzkyOTdlOWFhODlmMGQ4YWMwOCIsInN1YiI6IjY2MWUxNDM5NmEzMDBiMDE0YjMyMTIzYSIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.pWPaoNXrfK-Rs0d5rHVxxtBqithVBx4X1zZF4NL2X0k"
        return ["Content-Type": "application/json", "Authorization": "Bearer \(token)"]
    }
}
