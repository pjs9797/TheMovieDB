import UIKit
import ReactorKit
import Kingfisher

class SearchMovieViewController: UIViewController, ReactorKit.View {
    var disposeBag = DisposeBag()
    lazy var searchView = SearchMovieView()
    
    init(with reactor: SearchMovieReactor) {
        super.init(nibName: nil, bundle: nil)
        
        self.reactor = reactor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        
        view = searchView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .black
        setNavigationbar()
        setKeyboard()
    }
    
    private func setNavigationbar() {
        self.navigationController?.navigationBar.topItem?.title = "영화 검색"
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
    }
    
    private func setKeyboard(){
        let tapGesture = UITapGestureRecognizer()
        view.addGestureRecognizer(tapGesture)
        tapGesture.cancelsTouchesInView = false
        tapGesture.rx.event
            .bind(onNext: { [weak self] _ in
                self?.view.endEditing(true)
            })
            .disposed(by: disposeBag)
    }
}

extension SearchMovieViewController {
    func bind(reactor: SearchMovieReactor) {
        bindAction(reactor: reactor)
        bindState(reactor: reactor)
    }
    
    func bindAction(reactor: SearchMovieReactor){
        searchView.searchTextField.rx.text.orEmpty
            .map{ Reactor.Action.updateMovieTitle($0)}
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        searchView.searchButton.rx.tap
            .map { Reactor.Action.searchButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        searchView.movieListCollectionView.rx.itemSelected
            .map { [weak self] indexPath in
                guard let self = self else { return 0 }
                let movie = self.reactor?.currentState.movies[indexPath.row]
                return movie?.id ?? 0
            }
            .map{ Reactor.Action.selectMovie($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        searchView.movieListCollectionView.rx.prefetchItems
            .map { $0.last?.row ?? 0 }
            .filter { [weak self] row in
                guard let self = self else { return false }
                return row >= self.searchView.movieListCollectionView.numberOfItems(inSection: 0) - 1
            }
            .filter { [weak self] _ in
                guard let reactor = self?.reactor else { return false }
                return reactor.currentState.currentPage < reactor.currentState.totalPages
            }
            .map { _ in Reactor.Action.loadMore }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    func bindState(reactor: SearchMovieReactor){
        reactor.state.map{ $0.movies }
            .distinctUntilChanged()
            .bind(onNext: { [weak self] movies in
                if movies.isEmpty {
                    self?.searchView.nonMovieLabel.isHidden = false
                    self?.searchView.movieListCollectionView.isHidden = true
                }
                else{
                    self?.searchView.nonMovieLabel.isHidden = true
                    self?.searchView.movieListCollectionView.isHidden = false
                }
            })
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.movies }
            .distinctUntilChanged()
            .bind(to: searchView.movieListCollectionView.rx.items(cellIdentifier: "SubCollectionViewCell", cellType: MovieListCollectionViewCell.self)) { (index, movie, cell) in
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
