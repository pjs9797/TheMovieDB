import UIKit
import RxFlow

class AppFlow: Flow {
    var root: Presentable {
        return self.rootViewController
    }
    
    private lazy var rootViewController: UINavigationController = {
        let navigationController = UINavigationController()
        navigationController.isNavigationBarHidden = true
        return navigationController
    }()
    let movieAPIUseCase = MovieAPIUseCase(repository: MovieAPIRepository())
    let movieLocalDBUseCase = MovieLocalDBUseCase(repository: MovieLocalDBRepository())
    
    func navigate(to step: Step) -> FlowContributors {
        guard let step = step as? AppStep else { return .none }
        switch step {
        case .navigateToTabBar:
            return navigateToTabBar()
        }
    }
    
    private func navigateToTabBar() -> FlowContributors {
        let tabBarController = TabBarController()
        
        let movieListNavigationController = UINavigationController()
        let searchMovieNavigationController = UINavigationController()
        
        let movieListFlow = MovieListFlow(with: movieListNavigationController, movieAPIUseCase: self.movieAPIUseCase, movieLocalDBUseCase: self.movieLocalDBUseCase)
        let searchMovieFlow = SearchMovieFlow(with: searchMovieNavigationController, movieAPIUseCase: self.movieAPIUseCase, movieLocalDBUseCase: self.movieLocalDBUseCase)
        
        Flows.use(movieListFlow, searchMovieFlow, when: .created) { [weak self] (movieListViewController, searchMovieViewController) in
            
            movieListViewController.tabBarItem = UITabBarItem(title: "홈", image: ThemeManager.Images.home,tag: 0)
            searchMovieViewController.tabBarItem = UITabBarItem(title: "검색", image: ThemeManager.Images.search,tag: 1)

            
            tabBarController.viewControllers = [movieListViewController, searchMovieViewController]
            self?.rootViewController.setViewControllers([tabBarController], animated: false)
        }

        return .multiple(flowContributors: [
            .contribute(withNextPresentable: movieListFlow, withNextStepper: OneStepper(withSingleStep: MovieListStep.navigateToMovieListViewController)),
            .contribute(withNextPresentable: searchMovieFlow, withNextStepper: OneStepper(withSingleStep: SearchMovieStep.navigateToSearchMovieViewController))
        ])
    }
}
