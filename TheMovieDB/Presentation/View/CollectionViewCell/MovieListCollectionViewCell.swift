import UIKit
import SnapKit

class MovieListCollectionViewCell: UICollectionViewCell {
    lazy var movieImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = ThemeManager.Images.imageNotFound
        return imageView
    }()
    lazy var movieTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.numberOfLines = 0
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func layout(){
        [movieImageView, movieTitleLabel]
            .forEach{
                contentView.addSubview($0)
            }
        
        movieImageView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview().offset(-60*Constants.standardHeight)
        }
        
        movieTitleLabel.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalTo(movieImageView.snp.bottom).offset(5*Constants.standardHeight)
        }
    }
}
