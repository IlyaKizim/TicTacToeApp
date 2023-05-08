
import UIKit

class MainViewController: UIViewController {
    
    private lazy var button: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(Constants.buttonGame, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .black
        button.isEnabled = false
        button.alpha = 0.4
        button.addTarget(self, action: #selector(push), for: .touchUpInside)
        return button
    }()
    
    private lazy var namePlayerTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.backgroundColor = .white
        textField.attributedPlaceholder = NSAttributedString(string: viewModel.placeholder)
        textField.textAlignment = .center
        textField.layer.borderColor = UIColor.black.cgColor
        textField.layer.borderWidth = 1.0
        textField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        return textField
    }()
    
    private lazy var nameSecondPlayerTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.backgroundColor = .white
        textField.attributedPlaceholder = NSAttributedString(string: viewModel.placeholderForSecondPlayer)
        textField.textAlignment = .center
        textField.layer.borderColor = UIColor.black.cgColor
        textField.layer.borderWidth = 1.0
        textField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        return textField
    }()
    
    
    private lazy var viewModel = MainViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        button.layer.cornerRadius = 20
        namePlayerTextField.layer.cornerRadius = 20
        nameSecondPlayerTextField.layer.cornerRadius = 20
    }
    
    private func setup() {
        addSubview()
        setConstraint()
    }
    
    private func addSubview() {
        view.addSubview(button)
        view.addSubview(namePlayerTextField)
        view.addSubview(nameSecondPlayerTextField)
        
    }
    
    private func setConstraint() {
        NSLayoutConstraint.activate([
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            button.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            button.heightAnchor.constraint(equalToConstant: 50),
            button.widthAnchor.constraint(equalToConstant: 100)
        ])
        NSLayoutConstraint.activate([
            nameSecondPlayerTextField.bottomAnchor.constraint(equalTo: button.topAnchor, constant: -20),
            nameSecondPlayerTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            nameSecondPlayerTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            nameSecondPlayerTextField.heightAnchor.constraint(equalToConstant: 50)
        ])
        NSLayoutConstraint.activate([
            namePlayerTextField.bottomAnchor.constraint(equalTo: nameSecondPlayerTextField.topAnchor, constant: -20),
            namePlayerTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            namePlayerTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            namePlayerTextField.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    private func navigateToGame() {
        let vc = GameViewController()
        vc.configureLabel(firstPlayer: namePlayerTextField.text ?? "", secondPlayer: nameSecondPlayerTextField.text ?? "")
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true, completion: nil)
    }
     
    @objc private func push() {
        navigateToGame()
    }
    
    @objc private func textFieldDidChange() {
        guard let textOne = namePlayerTextField.text else { return }
        guard let textTwo = nameSecondPlayerTextField.text else { return }
        viewModel.updateName(textOne, textTwo)
           button.alpha = CGFloat(viewModel.buttonAlpha)
           button.isEnabled = viewModel.isButtonEnabled
       }
    
    
}

