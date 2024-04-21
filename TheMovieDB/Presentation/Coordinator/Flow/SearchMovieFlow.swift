import UIKit
import RxFlow

class SearchMovieFlow: Flow {
    var root: Presentable {
        return self.rootViewController
    }
    
    private var rootViewController: UINavigationController
    let movieAPIUseCase: MovieAPIUseCase
    let movieLocalDBUseCase: MovieLocalDBUseCase
    
    init(with rootViewController: UINavigationController, movieAPIUseCase: MovieAPIUseCase, movieLocalDBUseCase: MovieLocalDBUseCase) {
        self.rootViewController = rootViewController
        self.movieAPIUseCase = movieAPIUseCase
        self.movieLocalDBUseCase = movieLocalDBUseCase
    }
    
    func navigate(to step: Step) -> FlowContributors {
        guard let step = step as? SearchMovieStep else { return .none }
        switch step {
        case .navigateToSearchMovieViewController:
            return navigateToSearchMovieViewController()
        case .navigateToDetailMovieViewController(let id, let type):
            return navigateToDetailMovieViewController(id: id, flowType: type)
        case .navigateToYoutubePlayerViewController(let key, let type):
            return navigateToYoutubePlayerViewController(key: key, flowType: type)
        case .popViewController:
            return popViewController()
        }
    }
    
    private func navigateToSearchMovieViewController() -> FlowContributors {
        let reactor = SearchMovieReactor(movieAPIUseCase: self.movieAPIUseCase)
        let viewController = SearchMovieViewController(with: reactor)
        self.rootViewController.pushViewController(viewController, animated: true)
        
        return .one(flowContributor: .contribute(withNextPresentable: viewController, withNextStepper: reactor))
    }
    
    private func navigateToDetailMovieViewController(id: Int, flowType: MovieFlowType) -> FlowContributors {
        let reactor = DetailMovieReactor(id: id, flowType: flowType, movieAPIUseCase: self.movieAPIUseCase, movieLocalDBUseCase: self.movieLocalDBUseCase)
        let viewController = DetailMovieViewController(with: reactor)
        self.rootViewController.pushViewController(viewController, animated: true)
        
        return .one(flowContributor: .contribute(withNextPresentable: viewController, withNextStepper: reactor))
    }
    
    private func navigateToYoutubePlayerViewController(key: String, flowType: MovieFlowType) -> FlowContributors {
        let reactor = YoutubePlayerReactor(key: key, flowType: flowType)
        let viewController = YoutubePlayerViewController(with: reactor)
        self.rootViewController.pushViewController(viewController, animated: true)
        
        return .one(flowContributor: .contribute(withNextPresentable: viewController, withNextStepper: reactor))
    }
    
    private func popViewController() -> FlowContributors {
        rootViewController.popViewController(animated: true)
        
        return .none
    }
}

