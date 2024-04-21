import Foundation
import SQLite
import RxSwift

class LocalDatabase {
    static let shared = LocalDatabase()
    
    private let db: Connection?
    private let moviesTable = Table("Movies")
    private let id = Expression<Int>("id")
    private let title = Expression<String>("title")
    private let posterPath = Expression<String?>("posterPath")
    
    private init() {
        let path = NSSearchPathForDirectoriesInDomains(
            .documentDirectory, .userDomainMask, true
        ).first!
        
        do {
            db = try Connection("\(path)/movies.sqlite")
            createTable()
        } catch {
            db = nil
        }
    }
    
    private func createTable() {
        let createTable = moviesTable.create(ifNotExists: true) { table in
            table.column(id, primaryKey: true)
            table.column(title)
            table.column(posterPath)
        }
        
        do {
            try db?.run(createTable)
        } catch {
            print("테이블 생성 오류: \(error)")
        }
    }
    
    func fetchBookmarkedMovies() -> Observable<[Movie]> {
        Observable.create { [weak self] observer in
            do {
                guard let self = self, let db = self.db else {
                    observer.onCompleted()
                    return Disposables.create()
                }
                var movies = [Movie]()
                for movie in try db.prepare(moviesTable) {
                    let movieId = movie[id]
                    let movieTitle = movie[title]
                    let moviePosterPath = movie[posterPath]
                    movies.append(Movie(id: movieId, title: movieTitle, posterPath: moviePosterPath))
                }
                observer.onNext(movies)
                observer.onCompleted()
            } catch {
                observer.onError(error)
            }
            return Disposables.create()
        }
    }
    
    func addBookmark(movie: Movie) -> Observable<Bool> {
        return Observable.create { [weak self] observer in
            guard let self = self, let db = self.db else {
                observer.onCompleted()
                return Disposables.create()
            }
            let insertStatement = moviesTable.insert(
                id <- movie.id,
                title <- movie.title,
                posterPath <- movie.posterPath
            )
            do {
                try db.run(insertStatement)
                observer.onNext(true)
                observer.onCompleted()
            } catch {
                observer.onError(error)
            }
            return Disposables.create()
        }
    }
    
    func removeBookmark(movieId: Int) -> Observable<Bool> {
        return Observable.create { [weak self] observer in
            guard let self = self, let db = self.db else {
                observer.onCompleted()
                return Disposables.create()
            }
            let movie = moviesTable.filter(id == movieId)
            let deleteStatement = movie.delete()
            do {
                try db.run(deleteStatement)
                observer.onNext(false)
                observer.onCompleted()
            } catch {
                observer.onError(error)
            }
            return Disposables.create()
        }
    }
    
    func isBookmarked(movieId: Int) -> Observable<Bool> {
        return Observable.create { [weak self] observer in
            do {
                guard let self = self, let db = self.db else {
                    observer.onNext(false)
                    observer.onCompleted()
                    return Disposables.create()
                }
                let query = self.moviesTable.filter(self.id == movieId)
                let result = try db.pluck(query)
                if result != nil {
                    observer.onNext(true)
                } else {
                    observer.onNext(false)
                }
                observer.onCompleted()
            } catch {
                observer.onError(error)
            }
            return Disposables.create()
        }
    }
}
