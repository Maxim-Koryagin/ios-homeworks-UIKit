//
//  LogInViewController.swift
//  Navigation
//
//  Created by kosmokos I on 01.09.2022.

import UIKit

final class LoginViewController: UIViewController {

    // MARK: Properties
    
    var loginDelegate: LoginViewControllerDelegate?
        
    let bruteForce = BruteForce()
    
    let spinner = SpinnerViewController()
    
    private lazy var contentView: UIView = {
        let contentView = UIView()
        contentView.backgroundColor = .white
        contentView.translatesAutoresizingMaskIntoConstraints = false
        return contentView
    }()

    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()

    private lazy var imageView: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "logo")
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()

    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.backgroundColor = .systemGray6
        stackView.layer.borderColor = UIColor.lightGray.cgColor
        stackView.layer.borderWidth = 0.5
        stackView.layer.cornerRadius = 10
        stackView.clipsToBounds = true
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    lazy var loginTextField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .systemGray6
        textField.borderStyle = .roundedRect
        textField.textColor = .black
        textField.font = .systemFont(ofSize: 16)
        textField.placeholder = "Email or phone"
        textField.autocapitalizationType = .none
        textField.clearButtonMode = .whileEditing
        textField.layer.borderWidth = 0.8
        textField.leftView = UIView(frame: CGRect(x: 0, y: 10, width: 10, height: textField.frame.height))
        textField.layer.borderColor = UIColor.lightGray.cgColor
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()

    lazy var passwordTextField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .systemGray6
        textField.borderStyle = .roundedRect
        textField.textColor = .black
        textField.font = .systemFont(ofSize: 16)
        textField.placeholder = "Password"
        textField.layer.borderWidth = 0.8
        textField.leftView = UIView(frame: CGRect(x: 0, y: 10, width: 10, height: textField.frame.height))
        textField.layer.borderColor = UIColor.lightGray.cgColor
        textField.isSecureTextEntry = true
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()

    private lazy var loginbutton: CustomButton = {
        let button = CustomButton(title: "Log In", cornerRadius: 10, shadowOpacity: 0)
        button.clipsToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var choosePasswordButton: CustomButton = {
        let button = CustomButton(title: "Choose a password", cornerRadius: 5, shadowOpacity: 0)
        button.clipsToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.didShowKeyboard(_:)),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.didHideKeyboard(_:)),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }
    
    // MARK: Methods

    private func setupUI(){
        view.backgroundColor = .white

        setupNavBar()
        setupViews()
        setupConstraints()
        setupGestures()
        loginButtonAction()
        choosePasswordButtonAction()
    }

    private func setupNavBar(){
        navigationController?.navigationBar.isHidden = true
    }

    private func setupViews() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(imageView)
        contentView.addSubview(stackView)
        contentView.addSubview(loginbutton)
        contentView.addSubview(choosePasswordButton)
        stackView.addArrangedSubview(loginTextField)
        stackView.addArrangedSubview(passwordTextField)
    }

    private func setupConstraints(){

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            contentView.heightAnchor.constraint(equalTo: scrollView.heightAnchor),

            imageView.heightAnchor.constraint(equalToConstant: 100),
            imageView.widthAnchor.constraint(equalToConstant: 100),
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 120),
            imageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),

            stackView.heightAnchor.constraint(equalToConstant: 100),
            stackView.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 120),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

            loginbutton.heightAnchor.constraint(equalToConstant: 50),
            loginbutton.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 5),
            loginbutton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            loginbutton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            choosePasswordButton.topAnchor.constraint(equalTo: loginbutton.bottomAnchor, constant: 40),
            choosePasswordButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 25),
            choosePasswordButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -25)
        ])
    }

    private func setupGestures() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.forcedHidingKeyboard))
        self.view.addGestureRecognizer(tapGesture)
    }
    
    private func loginButtonAction() {
        loginbutton.tap = {
            self.showProfileView()
        }
    }
    
    private func choosePasswordButtonAction() {
        choosePasswordButton.tap = {
            self.choosePassword()
        }
    }
    
    private func choosePassword() {
        let randomString = String.random(length: 4)
        print("Generated string - \(randomString)")

        let queue = DispatchQueue(label: "choosePasswordQueue", qos: .userInitiated)
        let workItem = DispatchWorkItem { [self] in
            bruteForce.bruteForce(passwordToUnlock: randomString)
        }
        
        setupSpinner()
        
        queue.async(execute: workItem)
        
        workItem.notify(queue: .main) {
            self.passwordTextField.isSecureTextEntry = false
            self.passwordTextField.text = randomString
            
            self.spinner.willMove(toParent: nil)
            self.spinner.view.removeFromSuperview()
            self.spinner.removeFromParent()
        }
    }
    
    private func setupSpinner() {
        stackView.addSubview(spinner.view)
        addChild(spinner)
        
        spinner.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            spinner.view.topAnchor.constraint(equalTo: stackView.lastBaselineAnchor, constant: -5),
            spinner.view.leadingAnchor.constraint(equalTo: stackView.leadingAnchor, constant: 40)
        ])
        spinner.didMove(toParent: self)
    }
    
    private func showProfileView() {

        #if DEBUG
        let user = TestUserService()
        #else
        let user: CurrentUserService = {
            let user = CurrentUserService()
            user.user.login = ""
            user.user.fullName = "Mark User"
            user.user.avatar = UIImage(named: "jdun")
            user.user.status = "Waiting for something..."
            return user
        }()
        #endif

        let profileViewController = ProfileViewController(userService: user, name: loginTextField.text!)
        navigationController?.pushViewController(profileViewController, animated: true)
    }

    @objc private func didShowKeyboard(_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height

            let loginButtonBottomPointY = choosePasswordButton.frame.origin.y + choosePasswordButton.frame.height

            let keyboardOriginY = view.frame.height - keyboardHeight
            let yOffset = keyboardOriginY < loginButtonBottomPointY ? loginButtonBottomPointY - keyboardOriginY + 16 : 0

            scrollView.contentOffset = CGPoint(x: 0, y: yOffset)
        }
    }

    @objc private func didHideKeyboard(_ notification: Notification) {
        self.forcedHidingKeyboard()
    }

    @objc private func forcedHidingKeyboard() {
        self.view.endEditing(true)
        self.scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
    }

}

// MARK: String extension

extension String {
    static func random(length: Int = 20) -> String {
        let base = "abcdefghijklmnopqrstuvwxyz0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ"
        var randomString: String = ""

        for _ in 0..<length {
            let randomValue = arc4random_uniform(UInt32(base.count))
            randomString += "\(base[base.index(base.startIndex, offsetBy: Int(randomValue))])"
        }
        return randomString
    }
}
