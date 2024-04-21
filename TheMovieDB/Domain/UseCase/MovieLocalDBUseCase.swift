import RxSwift

class MovieLocalDBUseCase {
    private let repository: MovieLocalDBRepository

    init(repository: MovieLocalDBRepository) {
        self.repository = repository
    }
    
    func fetchBookmarkedMovies() -> Observable<[Movie]> {
        return repository.fetchBookmarkedMovies()
    }

    func addBookmark(movie: Movie) -> Observable<Bool> {
        return repository.addBookmark(movie: movie)
    }
    
    func removeBookmark(movieId: Int) -> Observable<Bool> {
        return repository.removeBookmark(movieId: movieId)
    }
    
    func isBookMarked(movieId: Int) -> Observable<Bool> {
        return repository.isBookMarked(movieId: movieId)
    }
}
