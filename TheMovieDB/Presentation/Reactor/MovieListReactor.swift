import ReactorKit
import Foundation
import RxCocoa
import RxFlow

class MovieListReactor: ReactorKit.Reactor, Stepper {
    let initialState: State = State()
    var steps = PublishRelay<Step>()
    let movieAPIUseCase: MovieAPIUseCase
    let movieLocalDBUseCase: MovieLocalDBUseCase
    
    init(movieAPIUseCase: MovieAPIUseCase, movieLocalDBUseCase: MovieLocalDBUseCase) {
        self.movieAPIUseCase = movieAPIUseCase
        self.movieLocalDBUseCase = movieLocalDBUseCase
    }
    
    enum Action {
        case loadIntialData
        case editButtonTapped
        case setSortType(SortMovie)
        case loadMore(SortMovie)
        case selectMovie(Int)
    }
    
    enum Mutation {
        case setSortType(SortMovie)
        case setMovies([Movie], Int)
        case appendMovies([Movie])
    }
    
    struct State {
        var title: String = "영화 목록 - 인기순"
        var sortType: SortMovie = .popularity
        var movies: [Movie] = []
        var currentPage: Int = 1
        var totalPages: Int = 1
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .loadIntialData:
            return movieAPIUseCase.sortMoviesByPopularity(page: currentState.currentPage)
                .map{ .setMovies($0.movies, $0.totalPages) }
        case .editButtonTapped:
            self.steps.accept(MovieListStep.presentSortActionSheet)
            return .empty()
        case .setSortType(let type):
            print("setSortType",type)
            switch type{
            case .popularity:
                return .concat([
                    .just(.setSortType(type)),
                    movieAPIUseCase.sortMoviesByPopularity(page: currentState.currentPage)
                        .map{ .setMovies($0.movies, $0.totalPages) }
                ])
            case .rating:
                return .concat([
                    .just(.setSortType(type)),
                    movieAPIUseCase.sortMoviesByRating(page: currentState.currentPage)
                        .map{ .setMovies($0.movies, $0.totalPages) }
                ])
            case .new:
                return .concat([
                    .just(.setSortType(type)),
                    movieAPIUseCase.sortMoviesByNew(page: currentState.currentPage)
                        .map{ .setMovies($0.movies, $0.totalPages) }
                ])
            case .favorites:
                return .concat([
                    .just(.setSortType(type)),
                    movieLocalDBUseCase.fetchBookmarkedMovies()
                        .map{.setMovies($0, 1)}
                ])
            }
        case .loadMore(let type):
            guard currentState.currentPage < currentState.totalPages else { return .empty() }
            switch type{
            case .popularity:
                return .concat([
                    .just(.setSortType(type)),
                    movieAPIUseCase.sortMoviesByPopularity(page: currentState.currentPage)
                        .map { .appendMovies($0.movies) }
                ])
            case .rating:
                return .concat([
                    .just(.setSortType(type)),
                    movieAPIUseCase.sortMoviesByRating(page: currentState.currentPage)
                        .map { .appendMovies($0.movies) }
                ])
            case .new:
                return .concat([
                    .just(.setSortType(type)),
                    movieAPIUseCase.sortMoviesByNew(page: currentState.currentPage)
                        .map { .appendMovies($0.movies) }
                ])
            case .favorites:
                return .just(.setSortType(type))
            }
        case .selectMovie(let id):
            self.steps.accept(MovieListStep.navigateToDetailMovieViewController(id: id, flowType: .list))
            return .empty()
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .setSortType(let type):
            newState.title = "영화 목록 - \(type.title)"
            newState.sortType = type
        case .setMovies(let movies, let totalPages):
            newState.movies = movies
            newState.totalPages = totalPages
            newState.currentPage = 1
        case .appendMovies(let movies):
            newState.movies.append(contentsOf: movies)
            newState.currentPage += 1
        }
        return newState
    }
}
