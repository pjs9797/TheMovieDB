import Moya
import RxMoya
import RxSwift

class MovieAPIRepository: MovieAPIRepositoryInterface {
    private let provider = MoyaProvider<MovieAPIService>()
    
    func sortMoviesByPopularity(page: Int) -> RxSwift.Observable<(movies: [Movie], totalPages: Int)> {
        return provider.rx.request(.sortByPopularity(page: page))
            .map(MovieListDTO.self)
            .map{ MovieListDTO.toEntity(dto: $0)}
            .asObservable()
    }
    
    func sortMoviesByRating(page: Int) -> RxSwift.Observable<(movies: [Movie], totalPages: Int)> {
        return provider.rx.request(.sortByRating(page: page))
            .map(MovieListDTO.self)
            .map{ MovieListDTO.toEntity(dto: $0)}
            .asObservable()
    }
    
    func sortMoviesByNew(page: Int) -> RxSwift.Observable<(movies: [Movie], totalPages: Int)> {
        return provider.rx.request(.sortByNew(page: page))
            .map(MovieListDTO.self)
            .map{ MovieListDTO.toEntity(dto: $0)}
            .asObservable()
    }

    func searchMovies(title: String, page: Int) -> Observable<(movies: [Movie], totalPages: Int)> {
        return provider.rx.request(.searchMovies(title: title, page: page))
            .map(MovieListDTO.self)
            .map{ MovieListDTO.toEntity(dto: $0)}
            .asObservable()
    }
    
    func detailMovie(id: Int) -> Observable<DetailMovie> {
        return provider.rx.request(.detailMoive(id: id))
            .map(DetailMovieDTO.self)
            .map{ DetailMovieDTO.toEntity(dto: $0) }
            .asObservable()
    }
    
    func getYoutubeList(id: Int) -> Observable<[Youtube]> {
        return provider.rx.request(.youtubeList(id: id))
            .map(YoutubeListDTO.self)
            .map{ YoutubeListDTO.toEntity(dto: $0) }
            .asObservable()
    }
}
