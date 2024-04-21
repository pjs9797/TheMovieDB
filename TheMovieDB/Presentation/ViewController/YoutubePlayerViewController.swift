import UIKit
import ReactorKit
import WebKit

class YoutubePlayerViewController: UIViewController, ReactorKit.View {
    var disposeBag = DisposeBag()
    let backButton = UIBarButtonItem(image: ThemeManager.Images.left, style: .plain, target: nil, action: nil)
    let youtubeWebView = YoutubeWebView()
    
    init(with reactor: YoutubePlayerReactor) {
        super.init(nibName: nil, bundle: nil)
        
        self.reactor = reactor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        
        view = youtubeWebView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .black
        setNavigationbar()
    }
    
    private func setNavigationbar() {
        self.title = "유튜브 영상"
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        backButton.tintColor = .systemGreen
        navigationItem.leftBarButtonItem = backButton
    }
}

extension YoutubePlayerViewController {
    func bind(reactor: YoutubePlayerReactor) {
        backButton.rx.tap
            .map{ Reactor.Action.backButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.youtubeKey }
            .distinctUntilChanged()
            .compactMap { URL(string: "https://www.youtube.com/embed/\($0)") }
            .map { URLRequest(url: $0) }
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] urlRequest in
                self?.youtubeWebView.webView.load(urlRequest)
            })
            .disposed(by: disposeBag)
    }
}
