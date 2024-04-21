import RxSwift

class MovieAPIUseCase {
    private let repository: MovieAPIRepository

    init(repository: MovieAPIRepository) {
        self.repository = repository
    }
    
    func sortMoviesByPopularity(page: Int) -> Observable<(movies: [Movie], totalPages: Int)> {
        return repository.sortMoviesByPopularity(page: page)
    }
    
    func sortMoviesByRating(page: Int) -> Observable<(movies: [Movie], totalPages: Int)> {
        return repository.sortMoviesByRating(page: page)
    }
    
    func sortMoviesByNew(page: Int) -> Observable<(movies: [Movie], totalPages: Int)> {
        return repository.sortMoviesByNew(page: page)
    }

    func searchMovies(title: String, page: Int) -> Observable<(movies: [Movie], totalPages: Int)> {
        return repository.searchMovies(title: title, page: page)
    }
    
    func detailMovie(id: Int) -> Observable<DetailMovie> {
        return repository.detailMovie(id: id)
    }
    
    func getYoutubeList(id: Int) -> Observable<[Youtube]> {
        return repository.getYoutubeList(id: id)
    }
}
