
import UIKit

class GameViewController: UIViewController, ViewModelDelegate {
    
    //MARK: - UI
    
    private lazy var buttonClickDismiss: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .gray
        button.setImage(UIImage(systemName: Constants.dismiss), for: .normal)
        button.addTarget(self, action: #selector(close), for: .touchUpInside)
        return button
    }()
    
    private lazy var labelForPlayer: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "\(String(viewModel.namePlayer)): \(viewModel.scoreForLabelPlayer)"
        label.tintColor = .white
        label.backgroundColor = #colorLiteral(red: 0.09022704512, green: 0.6043468118, blue: 0.361207366, alpha: 1)
        label.textAlignment = .center
        label.layer.masksToBounds = true
        label.layer.cornerRadius = 10
        return label
    }()
    
    private lazy var labelForSecondPlayer: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "\(String(viewModel.nameSecondPlayer)): \(viewModel.scoreForLabelSecondPlayer)"
        label.tintColor = .white
        label.backgroundColor = .white
        label.textAlignment = .center
        label.layer.masksToBounds = true
        label.layer.cornerRadius = 10
        return label
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        let screenWidth = UIScreen.main.bounds.width
        let cellWidth = screenWidth / 3
        let cellHeight = cellWidth
        layout.itemSize = CGSize(width: cellWidth, height: cellHeight)
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.backgroundColor = .white
        collection.dataSource = self
        collection.delegate = self
        collection.register(TicTacToeCollectionViewCell.self, forCellWithReuseIdentifier: TicTacToeCollectionViewCell.identifire)
        return collection
    }()
    
    //MARK: - Property
    
    private lazy var viewModel = GameViewModel()
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setup()
    }
    
    //MARK: - Setup UI
    
    private func setup() {
        addSubview()
        setConstraint()
        viewModel.delegate = self
    }
    
    @objc private func close() {
        dismiss(animated: true, completion: nil)
    }
    
    private func addSubview() {
        view.addSubview(buttonClickDismiss)
        view.addSubview(labelForPlayer)
        view.addSubview(labelForSecondPlayer)
        view.addSubview(collectionView)
    }
    
    //MARK: - Constraints
    
    private func setConstraint() {
        NSLayoutConstraint.activate([
            buttonClickDismiss.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: -10),
            buttonClickDismiss.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            buttonClickDismiss.heightAnchor.constraint(equalToConstant: 50),
            buttonClickDismiss.widthAnchor.constraint(equalToConstant: 50)
        ])
        NSLayoutConstraint.activate([
            labelForPlayer.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            labelForPlayer.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30),
            labelForPlayer.heightAnchor.constraint(equalToConstant: 50),
            labelForPlayer.widthAnchor.constraint(equalToConstant: 100)
        ])
        NSLayoutConstraint.activate([
            labelForSecondPlayer.topAnchor.constraint(equalTo: labelForPlayer.bottomAnchor),
            labelForSecondPlayer.leadingAnchor.constraint(equalTo: labelForPlayer.leadingAnchor),
            labelForSecondPlayer.heightAnchor.constraint(equalTo: labelForPlayer.heightAnchor),
            labelForSecondPlayer.widthAnchor.constraint(equalTo: labelForPlayer.widthAnchor)
        ])
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: labelForSecondPlayer.bottomAnchor, constant: 50),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.width)
        ])
    }
    
    func configureLabel(firstPlayer: String, secondPlayer: String) {
        viewModel.namePlayer = firstPlayer
        viewModel.nameSecondPlayer = secondPlayer
    }
}

    //MARK: - UICollectionViewDataSource

extension GameViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 9
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TicTacToeCollectionViewCell.identifire, for: indexPath) as? TicTacToeCollectionViewCell else { return UICollectionViewCell() }
        
        cell.backgroundColor = .white
        cell.layer.borderColor = UIColor.black.cgColor
        cell.layer.borderWidth = 1
        
        return cell
    }
}

    //MARK: - UICollectionViewDelegate

extension GameViewController: UICollectionViewDelegate {
    
    func didUpdateData() {
        collectionView.visibleCells.forEach { cell in
            cell.backgroundView = nil
            cell.backgroundColor = .white
        }
        collectionView.reloadData()
    }
    
    func updateLabel(player: String) {
        labelForPlayer.text = "\(String(viewModel.namePlayer)): \(viewModel.scoreForLabelPlayer)"
        labelForSecondPlayer.text = "\(String(viewModel.nameSecondPlayer)): \(viewModel.scoreForLabelSecondPlayer)"
        showViewWithWinner(text: player)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard !viewModel.isCellSelected(at: indexPath) else { return }
        
        if let cell = collectionView.cellForItem(at: indexPath) {
            if viewModel.round {
                labelForPlayer.backgroundColor = #colorLiteral(red: 0.09022704512, green: 0.6043468118, blue: 0.361207366, alpha: 1)
                labelForSecondPlayer.backgroundColor = .white
                let imageView = UIImageView(image: UIImage(named: Constants.O))
                imageView.frame = cell.bounds
                cell.backgroundView = imageView
                viewModel.updateRound(round: true)
            } else {
                labelForSecondPlayer.backgroundColor = #colorLiteral(red: 0.09022704512, green: 0.6043468118, blue: 0.361207366, alpha: 1)
                labelForPlayer.backgroundColor = .white
                let imageView = UIImageView(image: UIImage(named: Constants.X))
                imageView.frame = cell.bounds
                cell.backgroundView = imageView
                viewModel.updateRound(round: false)
            }
            viewModel.markCellSelected(at: indexPath, round: viewModel.round)
        }
    }
}

    //MARK: - Setup animation

extension GameViewController {
    private func showViewWithWinner(text: String) {
        let labelView = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: 70))
        labelView.center = view.center
        labelView.layer.cornerRadius = 15
        labelView.backgroundColor = #colorLiteral(red: 0.09022704512, green: 0.6043468118, blue: 0.361207366, alpha: 1)
        
        // создаем UILabel и добавляем его на UIView
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 70))
        label.text = text
        label.textAlignment = .center
        label.textColor = .black
        labelView.addSubview(label)
        
        // добавляем UIView на view
        view.addSubview(labelView)
        
        // задаем длительность анимации
        let duration = 1.3
        
        // задаем анимацию для UIView
        UIView.animate(withDuration: duration, animations: {
            labelView.center.y -= 50 // сдвигаем UIView вверх
        }) { _ in
        // запускаем обратную анимацию
            UIView.animate(withDuration: duration, animations: {
                labelView.center.y += 50 // сдвигаем UIView вниз
            }) { _ in
                labelView.removeFromSuperview() // удаляем UIView из view
            }
        }
    }
}


