//
//  RegisterController.swift
//  RocketSocialApp
//
//  Created by Jorge Pillaca Ramirez on 9/08/21.
//

import UIKit
import JGProgressHUD
import Alamofire

class RegisterController: UIViewController {
    
    let imageView : UIImageView = {
        let iv = UIImageView(image: #imageLiteral(resourceName: "logo social network"), contentMode: .scaleAspectFit)
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.widthAnchor.constraint(equalTo: iv.heightAnchor, multiplier: 1.15).isActive = true
        iv.setContentHuggingPriority(UILayoutPriority(250), for: .horizontal)
        return iv
    }()
    let fullNameTextField = IndentedTextField(placeholder: "Full  name", padding: 24, cornerRadius: 25, keyboardType: .emailAddress, backgroundColor: .white)
    let emailTextField = IndentedTextField(placeholder: "Email", padding: 24, cornerRadius: 25, keyboardType: .emailAddress, backgroundColor: .white)
    let passwordTextField = IndentedTextField(placeholder: "Password", padding: 24, cornerRadius: 25, keyboardType: .default, backgroundColor: .white, isSecureTextEntry: true)
    lazy var signupButton = UIButton(title: "Sign Up", titleColor: .white, font: .boldSystemFont(ofSize: 18), backgroundColor: .black, target: self, action: #selector(handleSignup))
    lazy var goBackToLoginButton = UIButton(title: "Go back to login", titleColor: .black, font: .systemFont(ofSize: 16, weight: .bold), target: self, action: #selector(handleGoBackToLogin))
    
    
    lazy var bottomStackView = UIStackView(arrangedSubviews: [
        fullNameTextField,
        emailTextField,
        passwordTextField,
        signupButton,
        goBackToLoginButton
        ]
    )
    
    lazy var overallStackView = UIStackView(arrangedSubviews: [
        imageView,
        bottomStackView
    ])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLayout()
        setupOrientation()
    }
    
    @objc fileprivate func handleSignup() {
        let hudLoading = JGProgressHUD(style: .dark)
        hudLoading.show(in: view, animated: true)
                        
        if isEmptyForm(){
            print("You have to fill out all the information.")
            return
        }
        
        Service.shared.signup(fullName: fullNameTextField.text!, email: emailTextField.text!, password: passwordTextField.text!) { result in
            hudLoading.dismiss(animated: true)
            switch result{
            case .success(let data):
                print("user signed up.", String(data: data, encoding: .utf8)!)
                self.dismiss(animated: true, completion: nil)
            case .failure(let error):
                print("Failed to signed up user", error.localizedDescription)
                self.showNotification(text: "Failed to Signup user", isError: true)
            }
        }
    }
    
    func isEmptyForm() -> Bool {
        return fullNameTextField.text == "" || emailTextField.text == "" || passwordTextField.text == ""
    }
    
    @objc fileprivate func handleGoBackToLogin() {
        navigationController?.popViewController(animated: true)
    }
    
    // MARK:- setup components
    
    fileprivate func setupLayout()  {
        view.backgroundColor = UIColor(white: 0.95, alpha: 1)
        navigationController?.navigationBar.isHidden = true
        
        fullNameTextField.constrainHeight(50)
        emailTextField.autocapitalizationType = .none
        emailTextField.constrainHeight(50)
        passwordTextField.constrainHeight(50)
        signupButton.constrainHeight(50)
        signupButton.layer.cornerRadius = 25
        goBackToLoginButton.constrainHeight(20)
        
        // setup Components
        bottomStackView.axis = .vertical
        bottomStackView.spacing = 8
        bottomStackView.distribution = .fillProportionally
        
        // setup Overall Stack
        overallStackView.axis = .vertical
        overallStackView.spacing = 8
        
        view.addSubview(overallStackView)
        overallStackView.anchor(top: nil, leading: view.safeAreaLayoutGuide.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 0, left: 55, bottom: 0, right: 55))
        overallStackView.centerYInSuperview()
        
        // TODO: move the overall stack when the keyboard appears and dismiss the keyboard at scrolling

    }
    
    // MARK:- Orientation
    
    fileprivate func setupOrientation()  {
        if traitCollection.verticalSizeClass == .compact {
            overallStackView.axis = .horizontal
            imageView.setContentHuggingPriority(UILayoutPriority(rawValue: 251), for: .horizontal)
        } else {
            overallStackView.axis = .vertical
            imageView.setContentHuggingPriority(UILayoutPriority(rawValue: 250), for: .horizontal)
        }
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        setupOrientation()
    }
    
    // MARK:- show notification
    
    let hud = JGProgressHUD(style: .dark)
    
    private func showNotification(text : String, isError: Bool) {
        
        if isError{
            hud.indicatorView = JGProgressHUDErrorIndicatorView()
        } else{
            hud.indicatorView = JGProgressHUDSuccessIndicatorView()
        }
        
        hud.textLabel.text = text
        hud.show(in: self.view)
        hud.dismiss(afterDelay: 3.0)
    }
    
}
