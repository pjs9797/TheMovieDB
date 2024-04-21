import UIKit
import SnapKit

class SearchMovieView: UIView {
    let searchTextField: UITextField = {
        let textField = UITextField()
        textField.layer.borderColor = UIColor.orange.cgColor
        textField.layer.borderWidth = 1
        textField.textColor = .white
        textField.placeholder = "영화를 검색하세요."
        textField.attributedPlaceholder = NSAttributedString(string: "영화를 검색하세요.", attributes: [
            .foregroundColor: UIColor.white
        ])
        textField.leftView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 10.0, height: 0.0))
        textField.leftViewMode = .always
        return textField
    }()
    let searchButton: UIButton = {
        let button = UIButton()
        let buttonImage = ThemeManager.Images.search?.withRenderingMode(.alwaysTemplate)
        button.setImage(buttonImage, for: .normal)
        button.tintColor = UIColor.white
        button.layer.borderColor = UIColor.systemGreen.cgColor
        button.layer.borderWidth = 1
        return button
    }()
    lazy var movieListCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let screenWidth = UIScreen.main.bounds.width
        let cellWidth = (screenWidth - 60) / 2
        let cellHeight = cellWidth * 1.5
        layout.itemSize = CGSize(width: cellWidth*Constants.standardWidth, height: cellHeight*Constants.standardWidth)
        layout.minimumLineSpacing = 10*Constants.standardHeight
        layout.minimumInteritemSpacing = 10*Constants.standardWidth
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.backgroundColor = .black
        collectionView.register(MovieListCollectionViewCell.self, forCellWithReuseIdentifier: "SubCollectionViewCell")
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
        [searchTextField,searchButton,movieListCollectionView]
            .forEach{
                addSubview($0)
            }
        
        searchTextField.snp.makeConstraints { make in
            make.width.equalTo(300*Constants.standardWidth)
            make.height.equalTo(50*Constants.standardHeight)
            make.leading.equalToSuperview().offset(10*Constants.standardWidth)
            make.top.equalTo(self.safeAreaLayoutGuide.snp.top).offset(10*Constants.standardHeight)
        }
        
        searchButton.snp.makeConstraints { make in
            make.width.height.equalTo(50*Constants.standardHeight)
            make.trailing.equalToSuperview().offset(-10*Constants.standardWidth)
            make.top.equalTo(self.safeAreaLayoutGuide.snp.top).offset(10*Constants.standardHeight)
        }
        
        movieListCollectionView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(10*Constants.standardWidth)
            make.trailing.equalToSuperview().offset(-10*Constants.standardWidth)
            make.top.equalTo(searchTextField.snp.bottom).offset(10*Constants.standardHeight)
            make.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottom)
        }
    }
}
