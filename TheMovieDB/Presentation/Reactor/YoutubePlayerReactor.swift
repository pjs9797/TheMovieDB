import ReactorKit
import RxCocoa
import RxFlow

class YoutubePlayerReactor: ReactorKit.Reactor, Stepper {
    let initialState: State
    var steps = PublishRelay<Step>()
    
    init(key: String, flowType: MovieFlowType) {
        self.initialState = State(youtubeKey: key, flowType: flowType)
    }
    
    enum Action {
        case backButtonTapped
    }
    
    enum Mutation {
    }
    
    struct State {
        var youtubeKey: String = ""
        var flowType: MovieFlowType
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .backButtonTapped:
            switch currentState.flowType {
            case .list:
                self.steps.accept(MovieListStep.popViewController)
            case .search:
                self.steps.accept(SearchMovieStep.popViewController)
            }
            return .empty()
        }
    }
}
