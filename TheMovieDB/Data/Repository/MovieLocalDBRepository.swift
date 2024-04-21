import RxSwift

class MovieLocalDBRepository: MovieLocalDBRepositoryInterface {
    private let db = LocalDatabase.shared
    
    func fetchBookmarkedMovies() -> Observable<[Movie]> {
        return db.fetchBookmarkedMovies()
    }

    func addBookmark(movie: Movie) -> Observable<Bool> {
        return db.addBookmark(movie: movie)
    }
    
    func removeBookmark(movieId: Int) -> Observable<Bool> {
        return db.removeBookmark(movieId: movieId)
    }
    
    func isBookMarked(movieId: Int) -> Observable<Bool> {
        return db.isBookmarked(movieId: movieId)
    }
}
