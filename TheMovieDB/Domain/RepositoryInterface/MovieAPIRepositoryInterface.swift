import RxSwift

protocol MovieAPIRepositoryInterface {
    func sortMoviesByPopularity(page: Int) -> Observable<(movies: [Movie], totalPages: Int)>
    func sortMoviesByRating(page: Int) -> Observable<(movies: [Movie], totalPages: Int)>
    func sortMoviesByNew(page: Int) -> Observable<(movies: [Movie], totalPages: Int)>
    func searchMovies(title: String, page: Int) -> Observable<(movies: [Movie], totalPages: Int)>
    func detailMovie(id: Int) -> Observable<DetailMovie>
    func getYoutubeList(id: Int) -> Observable<[Youtube]>
}
