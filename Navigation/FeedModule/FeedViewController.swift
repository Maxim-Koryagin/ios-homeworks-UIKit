//
//  FeedViewController.swift
//  Navigation
//
//  Created by Maxim Koryagin on 14.08.2022.

import UIKit

final class FeedViewController: UIViewController {
    
    // MARK: Properties
    
    var viewModel = FeedViewModel()
        
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Feed"
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var button: UIButton = {
        let button = UIButton()
        button.setTitle("Show Post", for: .normal)
        button.setTitleColor(UIColor.black, for: .application)
        button.backgroundColor = .systemFill
        button.layer.cornerRadius = 10
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var textField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Password"
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private lazy var checkGuessButton: CustomButton = {
        let button = CustomButton(title: "Check guess button", cornerRadius: 4, shadowOpacity: 0)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var trueFalseLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    // MARK: Methods
    
    private func setupUI() {
        view.backgroundColor = .systemCyan
        
        setupViews()
        setupConstraints()
        addTargets()
        setupGestures()
        makeViewModel()
    }

    
    private func addTargets() {
        button.addTarget(self, action: #selector(showDetailController), for: .touchUpInside)
        
        checkGuessButton.tap = {
            self.checkPassword()
        }
    }

    private func setupViews() {
        view.addSubview(button)
        view.addSubview(titleLabel)
        view.addSubview(textField)
        view.addSubview(checkGuessButton)
        view.addSubview(trueFalseLabel)
    }
    
    private func setupConstraints() {
        
        NSLayoutConstraint.activate([
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            button.topAnchor.constraint(equalTo: view.topAnchor, constant: 200),
            
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 50),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            trueFalseLabel.topAnchor.constraint(equalTo: button.bottomAnchor, constant: 100),
            trueFalseLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            textField.topAnchor.constraint(equalTo: trueFalseLabel.bottomAnchor, constant: 20),
            textField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            checkGuessButton.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 30),
            checkGuessButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
            
        ])
        
    }
    
    func makeViewModel() {
        viewModel.statusText.make({ ( statusText) in
            DispatchQueue.main.async {
                self.trueFalseLabel.text = statusText
            }
        })
    }
    
    private func checkPassword() {
        if viewModel.checkPassword(password: textField.text ?? "") == true {
            print("Right password")
            trueFalseLabel.textColor = .green
        } else {
            print("Wrong password")
            trueFalseLabel.textColor = .red
        }
    }
    
    private func setupGestures() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.forcedHidingKeyboard))
        self.view.addGestureRecognizer(tapGesture)
    }
    
    @objc private func forcedHidingKeyboard() {
        self.view.endEditing(true)
    }

    @objc private func showDetailController() {
        let detailController = PostViewController()
        navigationController?.pushViewController(detailController, animated: true)
    }
    
}
