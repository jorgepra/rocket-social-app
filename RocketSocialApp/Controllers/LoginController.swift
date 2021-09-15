//
//  LoginController.swift
//  RocketSocialApp
//
//  Created by Jorge Pillaca Ramirez on 5/08/21.
//

import UIKit
import JGProgressHUD

protocol LoginControllerDelegate {
    func didFinishLogin()
}

class LoginController: UIViewController {
       
    let imageView : UIImageView = {
        let iv = UIImageView(image: #imageLiteral(resourceName: "logo social network"), contentMode: .scaleAspectFit)
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.widthAnchor.constraint(equalTo: iv.heightAnchor, multiplier: 1.15).isActive = true
        iv.setContentHuggingPriority(UILayoutPriority(250), for: .horizontal)
        return iv
    }()
    
    let emailTextField          = IndentedTextField(placeholder: "Email", padding: 24, cornerRadius: 25, keyboardType: .emailAddress, backgroundColor: .white)
    let passwordTextField       = IndentedTextField(placeholder: "Password", padding: 24, cornerRadius: 25, keyboardType: .default, backgroundColor: .white, isSecureTextEntry: true)
    lazy var loginButton        = UIButton(title: "Login", titleColor: .white, font: .boldSystemFont(ofSize: 18), backgroundColor: .black, target: self, action: #selector(handleLogin))
    lazy var goToRegisterButton = UIButton(title: "Need an account? Go to Register.", titleColor: .black, font: .systemFont(ofSize: 16, weight: .bold), target: self, action: #selector(handleGoToRegister))
    lazy var bottomStackView    = UIStackView(arrangedSubviews: [emailTextField,passwordTextField,loginButton, goToRegisterButton])
    lazy var overallStackView   = UIStackView(arrangedSubviews: [imageView,bottomStackView])
    var delegate: LoginControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupController()
        setupLayout()
        setupOrientation()
    }
    
    fileprivate func setupController()  {
        view.backgroundColor = UIColor(white: 0.95, alpha: 1)
        navigationController?.navigationBar.isHidden = true
    }
    
    fileprivate func setupLayout() {
                
        emailTextField.autocapitalizationType = .none
        emailTextField.constrainHeight(50)
        passwordTextField.constrainHeight(50)
        loginButton.constrainHeight(50)
        loginButton.layer.cornerRadius = 25
        goToRegisterButton.constrainHeight(50)
        
        // setup Components
        bottomStackView.axis = .vertical
        bottomStackView.spacing = 12
        bottomStackView.distribution = .fillProportionally
        
        // setup Overall Stack
        overallStackView.axis = .vertical
        overallStackView.spacing = 12
        
        view.addSubview(overallStackView)
        overallStackView.anchor(top: nil, leading: view.safeAreaLayoutGuide.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 0, left: 55, bottom: 0, right: 55))
        overallStackView.centerYInSuperview()
        
        // TODO: move the overall stack when the keyboard appears and dismiss the keyboard at scrolling
    }
    
    @objc fileprivate func handleLogin()  {
        let loginHUD = JGProgressHUD(style: .dark)
        loginHUD.textLabel.text = "Logging in"
        loginHUD.show(in: view, animated: true)
        
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }
                        
        Service.shared.login(email: email, password: password) { result in
            loginHUD.dismiss(animated: true)
            switch result{
            case .failure(let error):
                print("Failed to authenticate the user. ", error.localizedDescription)
                self.showNotification(text: "Your email account or password was incorrect, please try again", isError: true)
            case .success(let data):
                print("user logged in", String(data: data, encoding: .utf8)!)
                self.dismiss(animated: true) {
                    self.delegate?.didFinishLogin()
                }
            }
        }
    }
    
    @objc fileprivate func handleGoToRegister()  {
        let registerController = RegisterController()
        navigationController?.pushViewController(registerController, animated: true)
    }
            
    // MARK:- Orientation and Priority
    
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
