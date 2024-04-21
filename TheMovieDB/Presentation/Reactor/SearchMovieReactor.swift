import ReactorKit
import Foundation
import RxCocoa
import RxFlow

class SearchMovieReactor: ReactorKit.Reactor, Stepper {
    let initialState: State = State()
    var steps = PublishRelay<Step>()
    let movieAPIUseCase: MovieAPIUseCase
    
    init(movieAPIUseCase: MovieAPIUseCase) {
        self.movieAPIUseCase = movieAPIUseCase
    }
    
    enum Action {
        case updateMovieTitle(String)
        case searchButtonTapped
        case loadMore
        case selectMovie(Int)
    }
    
    enum Mutation {
        case setMovieTitle(String)
        case setMovies([Movie], Int)
        case appendMovies([Movie])
    }
    
    struct State {
        var movieTitle: String = ""
        var movies: [Movie] = []
        var currentPage: Int = 1
        var totalPages: Int = 1
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .updateMovieTitle(let title):
            return .just(.setMovieTitle(title))
        case .searchButtonTapped:
            return movieAPIUseCase.searchMovies(title: currentState.movieTitle, page: currentState.currentPage)
                .map { .setMovies($0.movies, $0.totalPages) }
        case .loadMore:
            guard currentState.currentPage < currentState.totalPages else { return .empty() }
            return movieAPIUseCase.searchMovies(title: currentState.movieTitle, page: currentState.currentPage)
                .map { .appendMovies($0.movies) }
        case .selectMovie(let id):
            self.steps.accept(SearchMovieStep.navigateToDetailMovieViewController(id: id, flowType: .search))
            return .empty()
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .setMovieTitle(let title):
            newState.movieTitle = title
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
