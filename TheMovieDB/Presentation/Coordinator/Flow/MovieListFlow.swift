import UIKit
import RxFlow

class MovieListFlow: Flow {
    var root: Presentable {
        return self.rootViewController
    }
    
    private var rootViewController: UINavigationController
    let movieAPIUseCase: MovieAPIUseCase
    let movieLocalDBUseCase: MovieLocalDBUseCase
    var movieListreactor: MovieListReactor
    
    init(with rootViewController: UINavigationController, movieAPIUseCase: MovieAPIUseCase, movieLocalDBUseCase: MovieLocalDBUseCase) {
        self.rootViewController = rootViewController
        self.movieAPIUseCase = movieAPIUseCase
        self.movieLocalDBUseCase = movieLocalDBUseCase
        self.movieListreactor = MovieListReactor(movieAPIUseCase: self.movieAPIUseCase, movieLocalDBUseCase: self.movieLocalDBUseCase)
        self.rootViewController.delegate = nil
        self.rootViewController.interactivePopGestureRecognizer?.isEnabled = true
    }
    
    func navigate(to step: Step) -> FlowContributors {
        guard let step = step as? MovieListStep else { return .none }
        switch step {
        case .navigateToMovieListViewController:
            return navigateToMovieListViewController()
        case .presentSortActionSheet:
            return presentSortActionSheet()
        case .navigateToDetailMovieViewController(let id, let type):
            return navigateToDetailMovieViewController(id: id, flowType: type)
        case .navigateToYoutubePlayerViewController(let key, let type):
            return navigateToYoutubePlayerViewController(key: key, flowType: type)
        case .popViewController:
            return popViewController()
        }
    }
    
    private func navigateToMovieListViewController() -> FlowContributors {
        let viewController = MovieListViewController(with: self.movieListreactor)
        self.rootViewController.pushViewController(viewController, animated: true)
        
        return .one(flowContributor: .contribute(withNextPresentable: viewController, withNextStepper: self.movieListreactor))
    }
    
    private func presentSortActionSheet() -> FlowContributors {
        let alertController = UIAlertController(title: nil, message: "영화 정렬", preferredStyle: .actionSheet)
        
        let popularityAction = UIAlertAction(title: "인기순", style: .default) { _ in
            self.movieListreactor.action.onNext(.setSortType(.popularity))
        }
        
        let ratingAction = UIAlertAction(title: "평점순", style: .default) { _ in
            self.movieListreactor.action.onNext(.setSortType(.rating))
        }
        
        let newestAction = UIAlertAction(title: "신규순", style: .default) { _ in
            self.movieListreactor.action.onNext(.setSortType(.new))
        }
        
        let favoritesAction = UIAlertAction(title: "즐겨찾기", style: .default) { _ in
            self.movieListreactor.action.onNext(.setSortType(.favorites))
        }
        
        let cancelAction = UIAlertAction(title: "취소", style: .cancel)
        
        alertController.addAction(popularityAction)
        alertController.addAction(ratingAction)
        alertController.addAction(newestAction)
        alertController.addAction(favoritesAction)
        alertController.addAction(cancelAction)
        
        self.rootViewController.present(alertController, animated: true)
        
        return .none
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
    
