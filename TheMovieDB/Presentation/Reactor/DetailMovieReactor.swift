import ReactorKit
import UIKit
import Foundation
import RxCocoa
import RxFlow

class DetailMovieReactor: ReactorKit.Reactor, Stepper {
    let initialState: State
    var steps = PublishRelay<Step>()
    let movieAPIUseCase: MovieAPIUseCase
    let movieLocalDBUseCase: MovieLocalDBUseCase
    
    init(id: Int, flowType: MovieFlowType , movieAPIUseCase: MovieAPIUseCase, movieLocalDBUseCase: MovieLocalDBUseCase) {
        self.initialState = State(flowType: flowType, movieId: id)
        self.movieAPIUseCase = movieAPIUseCase
        self.movieLocalDBUseCase = movieLocalDBUseCase
    }
    
    enum Action {
        case loadDetailMovieData
        case backButtonTapped
        case bookMarkButtonTapped
        case selectYoutube(String)
    }
    
    enum Mutation {
        case setDetailMovieData(DetailMovie)
        case setYoutubeData([Youtube])
        case setBookMark(Bool)
        case setCanOpenYoutubeApp(URL)
    }
    
    struct State {
        var flowType: MovieFlowType
        var movieId: Int
        var isBookMarked: Bool = false
        var posterPath: String?
        var title: String = ""
        var voteAverage: Double?
        var releaseDate: String = ""
        var overView: String?
        var youtubes: [Youtube] = []
        var youtubeUrl: URL?
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .loadDetailMovieData:
            return .concat([
                movieAPIUseCase.detailMovie(id: currentState.movieId)
                    .map{ .setDetailMovieData($0) },
                movieAPIUseCase.getYoutubeList(id: currentState.movieId)
                    .map{ .setYoutubeData($0) },
                movieLocalDBUseCase.isBookMarked(movieId: currentState.movieId)
                    .map{ .setBookMark($0) }
            ])
        case .backButtonTapped:
            switch currentState.flowType {
            case .list:
                self.steps.accept(MovieListStep.popViewController)
            case .search:
                self.steps.accept(SearchMovieStep.popViewController)
            }
            return .empty()
        case .bookMarkButtonTapped:
            if currentState.isBookMarked {
                return movieLocalDBUseCase.removeBookmark(movieId: currentState.movieId)
                    .map{ .setBookMark($0)}
            }
            else{
                return movieLocalDBUseCase.addBookmark(movie: Movie(id: currentState.movieId, title: currentState.title, posterPath: currentState.posterPath))
                    .map{ .setBookMark($0)}
            }
        case .selectYoutube(let key):
            guard let url = URL(string: "youtube://\(key)") else { return .empty() }
            if UIApplication.shared.canOpenURL(url) {
                return .just(.setCanOpenYoutubeApp(url))
            }
            else{
                switch currentState.flowType {
                case .list:
                    self.steps.accept(MovieListStep.navigateToYoutubePlayerViewController(key: key, flowType: .list))
                case .search:
                    self.steps.accept(SearchMovieStep.navigateToYoutubePlayerViewController(key: key, flowType: .search))
                }
                return .empty()
            }
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .setDetailMovieData(let data):
            newState.posterPath = data.posterPath
            newState.title = data.originalTitle
            newState.voteAverage = data.voteAverage
            newState.releaseDate = data.releaseDate
            newState.overView = data.overview
        case .setBookMark(let status):
            newState.isBookMarked = status
        case .setYoutubeData(let youtubeList):
            newState.youtubes = youtubeList
        case .setCanOpenYoutubeApp(let url):
            newState.youtubeUrl = url
        }
        return newState
    }
}
