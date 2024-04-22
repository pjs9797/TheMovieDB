import UIKit
import SnapKit

class MovieListView: UIView {
    lazy var movieListCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let screenWidth = UIScreen.main.bounds.width
        let cellWidth = (screenWidth - 40*Constants.standardWidth) / 2
        let cellHeight = cellWidth * 1.5
        layout.itemSize = CGSize(width: cellWidth, height: cellHeight*Constants.standardWidth)
        layout.minimumLineSpacing = 10*Constants.standardHeight
        layout.minimumInteritemSpacing = 10*Constants.standardWidth
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.backgroundColor = .black
        collectionView.register(MovieListCollectionViewCell.self, forCellWithReuseIdentifier: "MovieListCollectionViewCell")
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
        self.addSubview(movieListCollectionView)
        
        movieListCollectionView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(10*Constants.standardWidth)
            make.trailing.equalToSuperview().offset(-10*Constants.standardWidth)
            make.top.equalTo(self.safeAreaLayoutGuide.snp.top).offset(10*Constants.standardHeight)
            make.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottom)
        }
    }
}
