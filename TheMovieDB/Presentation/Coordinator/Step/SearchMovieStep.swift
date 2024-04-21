import RxFlow

enum SearchMovieStep: Step {
    case navigateToSearchMovieViewController
    case navigateToDetailMovieViewController(id: Int, flowType: MovieFlowType)
    case navigateToYoutubePlayerViewController(key: String, flowType: MovieFlowType)
    case popViewController
}
