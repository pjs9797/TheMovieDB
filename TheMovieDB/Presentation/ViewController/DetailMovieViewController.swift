import UIKit
import ReactorKit
import Kingfisher

class DetailMovieViewController: UIViewController, ReactorKit.View {
    var disposeBag = DisposeBag()
    let backButton = UIBarButtonItem(image: ThemeManager.Images.left, style: .plain, target: nil, action: nil)
    lazy var detailMovieView = DetailMovieView()
    
    init(with reactor: DetailMovieReactor) {
        super.init(nibName: nil, bundle: nil)
        
        self.reactor = reactor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        
        view = detailMovieView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .black
        setNavigationbar()
    }
    
    private func setNavigationbar() {
        self.title = "영화 정보"
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        backButton.tintColor = .systemGreen
        navigationItem.leftBarButtonItem = backButton
    }
}

extension DetailMovieViewController {
    func bind(reactor: DetailMovieReactor) {
        bindAction(reactor: reactor)
        bindState(reactor: reactor)
    }
    
    func bindAction(reactor: DetailMovieReactor){
        reactor.action.onNext(.loadDetailMovieData)
        
        backButton.rx.tap
            .map{ Reactor.Action.backButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        detailMovieView.bookMarkButton.rx.tap
            .map{ Reactor.Action.bookMarkButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        detailMovieView.youtubeCollectionView.rx.itemSelected
            .map { [weak self] indexPath in
                guard let self = self else { return "" }
                let youtubeKey = self.reactor?.currentState.youtubeList[indexPath.row].key
                return youtubeKey ?? ""
            }
            .map{ Reactor.Action.selectYoutube($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    func bindState(reactor: DetailMovieReactor){
        reactor.state.map{ $0.posterPath }
            .distinctUntilChanged()
            .bind(onNext: { [weak self] path in
                if let posterPath = path, let url = URL(string: "https://image.tmdb.org/t/p/w500\(posterPath)") {
                    self?.detailMovieView.movieImageView.kf.setImage(with: url)
                }
                else{
                    self?.detailMovieView.movieImageView.image = ThemeManager.Images.imageNotFound
                }
            })
            .disposed(by: disposeBag)
        
        reactor.state.map{ $0.isBookMarked }
            .distinctUntilChanged()
            .bind(onNext: { [weak self] status in
                self?.detailMovieView.bookMarkButton.tintColor = status ? UIColor.systemGreen : UIColor.white
            })
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.title }
            .distinctUntilChanged()
            .bind(to: detailMovieView.movieTitleLabel.rx.text)
            .disposed(by: disposeBag)
        
        reactor.state.map{ $0.voteAverage }
            .distinctUntilChanged()
            .bind(onNext: { [weak self] average in
                if let average = average {
                    self?.detailMovieView.movieRatingLabel.text = "\(average)"
                }
                else{
                    self?.detailMovieView.movieRatingLabel.text = "평점이 없습니다."
                }
            })
            .disposed(by: disposeBag)
        
        reactor.state.map{ $0.releaseDate }
            .distinctUntilChanged()
            .bind(to: detailMovieView.movieReleaseDateLabel.rx.text)
            .disposed(by: disposeBag)
        
        reactor.state.map{ $0.overView }
            .distinctUntilChanged()
            .bind(onNext: { [weak self] overView in
                if let overView = overView {
                    self?.detailMovieView.movieOverViewLabel.text = overView
                }
                else{
                    self?.detailMovieView.movieOverViewLabel.text = "개요가 없습니다."
                }
            })
            .disposed(by: disposeBag)
        
        reactor.state.map{ $0.youtubeList }
            .distinctUntilChanged()
            .bind(onNext: { [weak self] list in
                if list.isEmpty {
                    self?.detailMovieView.noneVideoLabel.isHidden = false
                    self?.detailMovieView.youtubeCollectionView.isHidden = true
                }
                else{
                    self?.detailMovieView.noneVideoLabel.isHidden = true
                    self?.detailMovieView.youtubeCollectionView.isHidden = false
                }
            })
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.youtubeList }
            .distinctUntilChanged()
            .bind(to: detailMovieView.youtubeCollectionView.rx.items(cellIdentifier: "YouTubeListCollectionViewCell", cellType: YouTubeListCollectionViewCell.self)) { (index, youtube, cell) in
                if let url = URL(string: "https://img.youtube.com/vi/\(youtube.key)/0.jpg") {
                    cell.youtubeImageView.kf.setImage(with: url)
                }
                else{
                    cell.youtubeImageView.image = ThemeManager.Images.imageNotFound
                }
                cell.youtubeTitleLabel.text = youtube.name
            }
            .disposed(by: disposeBag)
    }
}
