import RxFlow

enum MovieListStep: Step {
    case navigateToMovieListViewController
    case presentSortActionSheet
    case navigateToDetailMovieViewController(id: Int, flowType: MovieFlowType)
    case navigateToYoutubePlayerViewController(key: String, flowType: MovieFlowType)
    case popViewController
}

