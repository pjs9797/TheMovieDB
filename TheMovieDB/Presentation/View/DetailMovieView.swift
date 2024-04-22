import UIKit
import SnapKit

class DetailMovieView: UIView {
    let scrollView = UIScrollView()
    let contentView = UIView()
    let movieImageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    let bookMarkButton: UIButton = {
        let button = UIButton()
        let buttonImage = ThemeManager.Images.bookMark?.withRenderingMode(.alwaysTemplate)
        button.setImage(buttonImage, for: .normal)
        return button
    }()
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "제목 : "
        label.textColor = .white
        return label
    }()
    let movieTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.numberOfLines = 0
        return label
    }()
    let ratingLabel: UILabel = {
        let label = UILabel()
        label.text = "평점 : "
        label.textColor = .white
        return label
    }()
    let movieRatingLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        return label
    }()
    let releaseDateLabel: UILabel = {
        let label = UILabel()
        label.text = "개봉일 : "
        label.textColor = .white
        return label
    }()
    let movieReleaseDateLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        return label
    }()
    let overViewLabel: UILabel = {
        let label = UILabel()
        label.text = "개요"
        label.textColor = .white
        return label
    }()
    let movieOverViewLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.numberOfLines = 0
        return label
    }()
    let youtubeVideoLabel: UILabel = {
        let label = UILabel()
        label.text = "유튜브 영상"
        label.textColor = .white
        return label
    }()
    let noneVideoLabel: UILabel = {
        let label = UILabel()
        label.text = "유튜브 영상이 없습니다."
        label.textColor = .white
        return label
    }()
    lazy var youtubeCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let screenWidth = UIScreen.main.bounds.width
        let cellWidth = (screenWidth - 40) / 2
        let cellHeight = 180*Constants.standardHeight
        layout.itemSize = CGSize(width: cellWidth*Constants.standardWidth, height: cellHeight*Constants.standardWidth)
        layout.minimumLineSpacing = 10*Constants.standardHeight
        layout.minimumInteritemSpacing = 0*Constants.standardWidth
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .black
        collectionView.register(YouTubeListCollectionViewCell.self, forCellWithReuseIdentifier: "YouTubeListCollectionViewCell")
        return collectionView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        layout()
    }
    
    private func layout() {
        addSubview(scrollView)
        scrollView.addSubview(contentView)
        [movieImageView,bookMarkButton,titleLabel,movieTitleLabel,ratingLabel,movieRatingLabel,releaseDateLabel,movieReleaseDateLabel,overViewLabel,movieOverViewLabel,youtubeVideoLabel,noneVideoLabel,youtubeCollectionView]
            .forEach{
                contentView.addSubview($0)
            }
        
        scrollView.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(self.safeAreaLayoutGuide.snp.top)
            make.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottom)
        }
        
        contentView.snp.makeConstraints { make in
            make.width.equalTo(scrollView)
            make.top.leading.trailing.bottom.equalToSuperview()
        }
        
        movieImageView.snp.makeConstraints { make in
            make.width.equalTo(150*Constants.standardWidth)
            make.height.equalTo(200*Constants.standardHeight)
            make.leading.equalToSuperview().offset(10*Constants.standardWidth)
            make.top.equalToSuperview().offset(20*Constants.standardHeight)
        }
        
        bookMarkButton.snp.makeConstraints { make in
            make.width.height.equalTo(40*Constants.standardHeight)
            make.trailing.equalToSuperview().offset(-20*Constants.standardWidth)
            make.top.equalTo(movieImageView.snp.top)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(movieImageView.snp.trailing).offset(10*Constants.standardWidth)
            make.centerY.equalTo(movieImageView)
        }
        
        movieTitleLabel.snp.makeConstraints { make in
            make.leading.equalTo(titleLabel.snp.trailing)
            make.trailing.equalToSuperview().offset(-20*Constants.standardWidth)
            make.centerY.equalTo(titleLabel)
        }
        
        ratingLabel.snp.makeConstraints { make in
            make.leading.equalTo(titleLabel.snp.leading)
            make.top.equalTo(titleLabel.snp.bottom).offset(20*Constants.standardHeight)
        }
        
        movieRatingLabel.snp.makeConstraints { make in
            make.leading.equalTo(ratingLabel.snp.trailing)
            make.centerY.equalTo(ratingLabel)
        }
        
        releaseDateLabel.snp.makeConstraints { make in
            make.leading.equalTo(titleLabel.snp.leading)
            make.top.equalTo(ratingLabel.snp.bottom).offset(20*Constants.standardHeight)
        }
        
        movieReleaseDateLabel.snp.makeConstraints { make in
            make.leading.equalTo(releaseDateLabel.snp.trailing)
            make.centerY.equalTo(releaseDateLabel)
        }
        
        overViewLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20*Constants.standardWidth)
            make.top.equalTo(movieImageView.snp.bottom).offset(20*Constants.standardHeight)
        }
        
        movieOverViewLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20*Constants.standardWidth)
            make.trailing.equalToSuperview().offset(-20*Constants.standardWidth)
            make.top.equalTo(overViewLabel.snp.bottom).offset(10*Constants.standardHeight)
        }
        
        youtubeVideoLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20*Constants.standardWidth)
            make.top.equalTo(movieOverViewLabel.snp.bottom).offset(20*Constants.standardHeight)
        }
        
        noneVideoLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20*Constants.standardWidth)
            make.top.equalTo(youtubeVideoLabel.snp.bottom).offset(10*Constants.standardHeight)
        }
        
        youtubeCollectionView.snp.makeConstraints { make in
            make.height.equalTo(180*Constants.standardHeight)
            make.leading.equalToSuperview().offset(20*Constants.standardWidth)
            make.trailing.equalToSuperview()
            make.top.equalTo(youtubeVideoLabel.snp.bottom).offset(10*Constants.standardHeight)
            make.bottom.equalToSuperview().offset(-5*Constants.standardHeight)
        }
    }
}
