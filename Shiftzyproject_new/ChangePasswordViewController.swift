//
//  ChangePasswordViewController.swift
//  Shiftzyproject_new
//
//  Created by Narayana on 06/06/24.
//
import UIKit
import Alamofire

struct ChangePasswordResponse: Codable {
    let settings: Settings
}

struct Settings: Codable {
    let success: Int
    let message: String
}

class ChangePasswordViewController: UIViewController {
    
    var passwordData: ChangePasswordResponse?
    
    @IBOutlet var newPasswordTextField: UITextField!
    @IBOutlet var oldPasswordTextField: UITextField!
    @IBOutlet var oldPasswordVisibilityButton: UITextField!
    @IBOutlet var newPasswordVisibilityButton: UITextField!
    @IBOutlet var submitBtnClick: UIButton!
    @IBOutlet var mainView: UIView!

    
    class func instance() -> ChangePasswordViewController {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "ChangePasswordViewController") as! ChangePasswordViewController
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    func setupUI() {
        NavigationBarSetup.setup(for: self, title: "SWIFTZY", backButtonAction: #selector(backButtonTapped), button1Action: nil, button2Action: nil, button3Action: nil)
        mainView.layer.cornerRadius = 20

        newPasswordTextField.isSecureTextEntry = true
        
        let eyeButton = UIButton(type: .custom)
        eyeButton.setImage(UIImage(systemName: "eye.slash.fill"), for: .normal)
        eyeButton.tintColor = .black
        eyeButton.contentMode = .scaleAspectFit
        eyeButton.addTarget(self, action: #selector(passwordVisibility), for: .touchUpInside)
        newPasswordVisibilityButton.rightView = eyeButton
        newPasswordVisibilityButton.rightViewMode = .always
        
        let oldEyeButton = UIButton(type: .custom)
        oldEyeButton.setImage(UIImage(systemName: "eye.fill"), for: .normal)
        oldEyeButton.tintColor = .black
        oldEyeButton.contentMode = .scaleAspectFit
        oldPasswordTextField.rightView = oldEyeButton
        oldPasswordTextField.rightViewMode = .always
    }
    func changePassword(newPassword: String) {
        guard let oldPassword = oldPasswordTextField.text else {
            return
        }
        
        let parameters: [String: Any] = [
            "oldPassword": oldPassword,
            "newPassword": newPassword
        ]
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJjdXN0b21lcklkIjoxMjYsImZ1bGxOYW1lIjoibmFyYXlhbmEgMTgiLCJlbWFpbCI6Im5hcmF5YW5hLnJhbysxOEBoaWRkZW5icmFpbnMuaW4iLCJlbWFpbFZlcmlmaWVkIjoxLCJjb3VudHJ5VG9Mb2NhdGUiOjIzNSwic3RhdHVzIjoiQWN0aXZlIiwibG9nSWQiOjIyNDUsImlhdCI6MTcxODA3OTkxNSwiZXhwIjoxNzE4MTUxOTE1LCJhdWQiOiJodHRwczovL3NoaWZ0enp5LWFwaS5wcm9qZWN0c3ByZXZpZXcubmV0IiwiaXNzIjoiaHR0cHM6Ly9zaGlmdHp6eS1hcGkucHJvamVjdHNwcmV2aWV3Lm5ldCJ9.t_zEZxjwzxEPAM08Fv74R2cqJZgzk_95q5deF-Twp4A"
        ]
        
        AF.request("https://shiftzzy-api.projectspreview.net/api/v1/customer/change-password",
                   method: .post,
                   parameters: parameters,
                   headers: headers)
        .validate(statusCode: 200..<300)
        .responseDecodable(of: ChangePasswordResponse.self) { response in
            switch response.result {
            case .success(let passwordResponse):
                self.passwordData = passwordResponse
                self.handlePasswordChangeResponse()
                
            case .failure(let error):
                print("Error changing password: \(error)")
                self.showAlert(title: "Error", message: "Failed to change password. Please try again later.")
            }
        }
    }
    @objc func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    @objc func passwordVisibility() {
        newPasswordTextField.isSecureTextEntry.toggle()
        let imageName = newPasswordTextField.isSecureTextEntry ? "eye.slash.fill" : "eye.fill"
        if let eyeButton = newPasswordTextField.rightView as? UIButton {
            eyeButton.setImage(UIImage(systemName: imageName), for: .normal)
        }
    }
    func handlePasswordChangeResponse() {
        guard let settings = self.passwordData?.settings else {
            print("Invalid response format")
            return
        }
        if settings.success == 1 {
            showAlert(title: "Success", message: "Password changed successfully.") { [weak self] in
                self?.navigationController?.popViewController(animated: true)
            }
        } else {
            showAlert(title: "Error", message: settings.message)
        }
    }
    
    func showAlert(title: String, message: String, completion: (() -> Void)? = nil) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
            completion?()
        }
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func submitButtonTapped(_ sender: UIButton) {
        guard let newPassword = newPasswordTextField.text else {
            return
        }
        changePassword(newPassword: newPassword)
    }
}
