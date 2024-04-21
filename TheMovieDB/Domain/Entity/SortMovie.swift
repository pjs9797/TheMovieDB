enum SortMovie {
    case popularity
    case rating
    case new
    case favorites

    var title: String {
        switch self {
        case .popularity:
            return "인기순"
        case .rating:
            return "평점순"
        case .new:
            return "신규순"
        case .favorites:
            return "즐겨찾기"
        }
    }
}
