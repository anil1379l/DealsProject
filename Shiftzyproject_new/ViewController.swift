//
//  ViewController.swift
//  Shiftzyproject_new
//
//  Created by Narayana on 06/06/24.
//

import UIKit
import Alamofire

struct LoginInfo: Codable {
    var settings: SettingsItems?
    var data: DataItems?
}

struct SettingsItems: Codable {
    var success: Int?
    var message: String?
    var status: Int?
}

struct DataItems: Codable {
    var customerId: Int?
    var accessToken: String?
}

class NavigationBarSetup {
    static func setup(for viewController: UIViewController, title: String, backButtonAction: Selector?, button1Action: Selector?, button2Action: Selector?, button3Action: Selector?) {
        let textAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        viewController.navigationController?.navigationBar.titleTextAttributes = textAttributes
        
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.textColor = .white
        titleLabel.font = UIFont.boldSystemFont(ofSize: 25)
        titleLabel.sizeToFit()
        
        viewController.navigationItem.titleView = titleLabel
        
        if let backButtonAction = backButtonAction {
            let backButton = UIBarButtonItem(image: UIImage(systemName: "chevron.backward.circle.fill"), style: .plain, target: viewController, action: backButtonAction)
            backButton.tintColor = .white
            viewController.navigationItem.leftBarButtonItem = backButton
        }
        setupNavigationBarButtons(viewController: viewController, button1Action: button1Action, button2Action: button2Action, button3Action: button3Action)
    }
    private static func setupNavigationBarButtons(viewController: UIViewController, button1Action: Selector?, button2Action: Selector?, button3Action: Selector?) {
        let button1 = UIBarButtonItem(image: UIImage(systemName: "ellipsis"), style: .plain, target: viewController, action: button1Action)
        button1.tintColor = .white
        let button2 = UIBarButtonItem(image: UIImage(systemName: "bell.fill"), style: .plain, target: viewController, action: button2Action)
        button2.tintColor = .white
        let button3 = UIBarButtonItem(image: UIImage(systemName: "message.fill"), style: .plain, target: viewController, action: button3Action)
        button3.tintColor = .white
        viewController.navigationItem.rightBarButtonItems = [button1, button2, button3]
    }
}

class ViewController: UIViewController {
    
    var loginData: LoginInfo?
    @IBOutlet var mainView: UIView!
    @IBOutlet var loginBtn: UIButton!
    @IBOutlet var googleView: UIView!
    @IBOutlet var appleView: UIView!
    @IBOutlet var facebookView: UIView!
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    func setupUI() {
        mainView.layer.cornerRadius = 20
        loginBtn.layer.cornerRadius = 10
        [googleView, appleView, facebookView].forEach { view in
            view?.layer.cornerRadius = 10
            view?.layer.borderWidth = 0.2
        }
        facebookView.clipsToBounds = true
        
        passwordTextField.isSecureTextEntry = true
        
        let eyeButton = UIButton(type: .custom)
        eyeButton.setImage(UIImage(systemName: "eye.slash.fill"), for: .normal)
        eyeButton.tintColor = .black
        eyeButton.contentMode = .scaleAspectFit
        eyeButton.addTarget(self, action: #selector(passwordVisibility), for: .touchUpInside)
        passwordTextField.rightView = eyeButton
        passwordTextField.rightViewMode = .always
    }
    
    func dataLogin(email: String, password: String) {
        let parameters: [String: Any] = [
            "email": email,
            "password": password,
            "notificationToken": "string"
        ]
        AF.request("https://shiftzzy-api.projectspreview.net/api/v1/auth/login",method: .post,parameters: parameters).response { response in
            if let data = response.data {
                print("data===",data)
                do {
                    self.loginData = try JSONDecoder().decode(LoginInfo.self, from: data)
                    if let loginData = self.loginData, let success = loginData.settings?.success, success == 1 {
                        print("Login Successful!")
                        DispatchQueue.main.async {
                            let secondVC = ProfileViewController.instance()
                            self.navigationController?.pushViewController(secondVC, animated: true)
                        }
                    } else {
                        print("Login failed.")
                        DispatchQueue.main.async {
                            self.showError(message: "Incorrect email or password.", textField: nil)
                        }
                    }
                } catch let error as NSError {
                    print("Failed to Load: \(error.localizedDescription)")
                }
            }
        }
    }
    
    @IBAction func loginButtonTapped(_ sender: UIButton) {
        guard let email = emailTextField.text, let password = passwordTextField.text else {
            showError(message: "Please enter both email and password.", textField: nil)
            return
        }
        if isValidEmail(email) && isValidPassword(password) {
            dataLogin(email: email, password: password)
        } else {
            showError(message: "Invalid email or password format.", textField: nil)
        }
    }
    
    @objc func passwordVisibility() {
        passwordTextField.isSecureTextEntry.toggle()
        let imageName = passwordTextField.isSecureTextEntry ? "eye.slash.fill" : "eye.fill"
        if let eyeButton = passwordTextField.rightView as? UIButton {
            eyeButton.setImage(UIImage(systemName: imageName), for: .normal)
        }
    }
    
    func isValidEmail(_ email: String) -> Bool {
        return email.contains("@") && email.contains(".")
    }
    
    func isValidPassword(_ password: String) -> Bool {
        return password.count >= 8
    }
    
    func showError(message: String, textField: UITextField? = nil) {
        if let textField = textField {
            textField.layer.borderColor = UIColor.red.cgColor
            textField.layer.borderWidth = 1.0
        }
        
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            if let textField = textField {
                textField.layer.borderColor = UIColor.clear.cgColor
                textField.layer.borderWidth = 0.0
            }
        }))
        self.present(alert, animated: true, completion: nil)
    }
}
