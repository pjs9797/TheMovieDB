import UIKit
import SnapKit

class YouTubeListCollectionViewCell: UICollectionViewCell {
    lazy var youtubeImageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    let youtubeIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.image = ThemeManager.Images.youtubeIcon
        return imageView
    }()
    lazy var youtubeTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.numberOfLines = 1
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
        [youtubeImageView,youtubeIcon, youtubeTitleLabel]
            .forEach{
                contentView.addSubview($0)
            }
                
        youtubeImageView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview().offset(-60*Constants.standardHeight)
        }
        
        youtubeIcon.snp.makeConstraints { make in
            make.width.equalTo(40*Constants.standardWidth)
            make.height.equalTo(30*Constants.standardHeight)
            make.center.equalTo(youtubeImageView)
        }
        
        youtubeTitleLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(youtubeImageView.snp.bottom).offset(5*Constants.standardHeight)
            make.bottom.equalToSuperview().offset(-5*Constants.standardHeight)
        }
    }
}
