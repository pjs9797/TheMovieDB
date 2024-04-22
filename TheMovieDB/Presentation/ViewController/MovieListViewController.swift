import UIKit
import ReactorKit
import Kingfisher

class MovieListViewController: UIViewController, ReactorKit.View {
    var disposeBag = DisposeBag()
    let editButton = UIBarButtonItem(image: ThemeManager.Images.edit, style: .plain, target: nil, action: nil)
    lazy var movieListView = MovieListView()
    
    init(with reactor: MovieListReactor) {
        super.init(nibName: nil, bundle: nil)
        
        self.reactor = reactor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        
        view = movieListView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .black
        setNavigationbar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if reactor?.currentState.sortType == .favorites {
            reactor?.action.onNext(.setSortType(.favorites))
        }
    }
    
    private func setNavigationbar() {
        self.navigationController?.navigationBar.topItem?.title = "영화 목록 - 인기순"
        let navigationBarAppearance = UINavigationBarAppearance()
        navigationBarAppearance.backgroundColor = .black
        navigationBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        self.navigationController?.navigationBar.standardAppearance = navigationBarAppearance
        self.navigationController?.navigationBar.scrollEdgeAppearance = navigationBarAppearance
        editButton.tintColor = .systemGreen
        navigationItem.rightBarButtonItem = editButton
    }
}

extension MovieListViewController {
    func bind(reactor: MovieListReactor) {
        bindAction(reactor: reactor)
        bindState(reactor: reactor)
    }
    
    func bindAction(reactor: MovieListReactor){
        reactor.action.onNext(.loadIntialData)
        
        editButton.rx.tap
            .map{ Reactor.Action.editButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        movieListView.movieListCollectionView.rx.itemSelected
            .map { [weak self] indexPath in
                guard let self = self else { return 0 }
                let movie = self.reactor?.currentState.movies[indexPath.row]
                return movie?.id ?? 0
            }
            .map{ Reactor.Action.selectMovie($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        movieListView.movieListCollectionView.rx.prefetchItems
            .map { $0.last?.row ?? 0 }
            .filter { [weak self] row in
                guard let self = self else { return false }
                return row >= self.movieListView.movieListCollectionView.numberOfItems(inSection: 0) - 1
            }
            .filter { [weak self] _ in
                guard let reactor = self?.reactor else { return false }
                return reactor.currentState.currentPage < reactor.currentState.totalPages
            }
            .map { _ in Reactor.Action.loadMore(reactor.currentState.sortType) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    func bindState(reactor: MovieListReactor){
        reactor.state.map{ $0.title }
            .distinctUntilChanged()
            .bind(onNext: { [weak self] title in
                self?.navigationController?.navigationBar.topItem?.title = title
            })
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.movies }
            .distinctUntilChanged()
            .bind(to: movieListView.movieListCollectionView.rx.items(cellIdentifier: "MovieListCollectionViewCell", cellType: MovieListCollectionViewCell.self)) { (index, movie, cell) in
                if let posterPath = movie.posterPath, let url = URL(string: "https://image.tmdb.org/t/p/w500\(posterPath)") {
                    cell.movieImageView.kf.setImage(with: url)
                }
                else{
                    cell.movieImageView.image = ThemeManager.Images.imageNotFound
                }
                cell.movieTitleLabel.text = movie.title
            }
            .disposed(by: disposeBag)
    }
}
