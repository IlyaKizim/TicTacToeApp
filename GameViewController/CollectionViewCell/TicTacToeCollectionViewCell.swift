
import UIKit

class TicTacToeCollectionViewCell: UICollectionViewCell {
    
    static let identifire = "TicTacToeCollectionViewCell"
    
    override init(frame: CGRect) {
          super.init(frame: frame)
        
          contentView.layer.borderColor = UIColor.black.cgColor
          contentView.layer.borderWidth = 1
      }
      
      required init?(coder: NSCoder) {
          fatalError("init(coder:) has not been implemented")
      }
}
