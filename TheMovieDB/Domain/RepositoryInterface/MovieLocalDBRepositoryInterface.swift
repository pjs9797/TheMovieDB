import RxSwift

protocol MovieLocalDBRepositoryInterface {
    func fetchBookmarkedMovies() -> Observable<[Movie]>
    func addBookmark(movie: Movie) -> Observable<Bool>
    func removeBookmark(movieId: Int) -> Observable<Bool>
    func isBookMarked(movieId: Int) -> Observable<Bool>
}
