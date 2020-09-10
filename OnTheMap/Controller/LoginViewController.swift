//
//  LoginViewController.swift
//  OnTheMap
//
//  Created by Rafif Kalantan on 04/09/2020.
//  Copyright © 2020 Rafif Kalantan. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {

    // MARK: Declarations
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    let signUpUrl = UdacityClient.Endpoints.udacitySignUp.url
    
    var emailFieldIsEmpty = true
    var passwordFieldIsEmpty = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailField.text = ""
        passwordField.text = ""
        emailField.delegate = self
        passwordField.delegate = self
        buttonEnabled(false, button: loginButton)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        emailField.text = ""
        passwordField.text = ""
    }
    
    // MARK: Log In
    @IBAction func login(_ sender: UIButton) {
        setLoggingIn(true)
        UdacityClient.login(email: self.emailField.text ?? "", password: self.passwordField.text ?? "", completion: handleLoginResponse(success:error:))
    }
    
    // MARK: Handle login response
    func handleLoginResponse(success: Bool, error: Error?) {
        setLoggingIn(false)
        if success {
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: "login", sender: nil)
            }
        } else {
            let invalidAccessAlert = UIAlertController(title: "Invalid Access", message: "Invalid email or password", preferredStyle: .alert)
            invalidAccessAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: {_ in
                return
            }))
            self.present(invalidAccessAlert, animated: true, completion: nil)
        
            if let error = error {
                print(error.localizedDescription)
                let errorAlert = UIAlertController(title: "Error", message: "There is error", preferredStyle: .alert)
                errorAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: {_ in
                    return
                }))
                self.present(errorAlert, animated: true, completion: nil)
            }
        }
    }
    
    // MARK: Sign Up
    @IBAction func signUp(_ sender: Any) {
        setLoggingIn(true)
        UIApplication.shared.open(signUpUrl, options: [:], completionHandler: nil)
    }
    
    // MARK: Loading state
    func setLoggingIn(_ loggingIn: Bool) {
        if loggingIn {
            DispatchQueue.main.async {
                self.activityIndicator.startAnimating()
                self.buttonEnabled(false, button: self.loginButton)
            }
        } else {
            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()
                self.buttonEnabled(true, button: self.loginButton)
            }
        }
        DispatchQueue.main.async {
            self.emailField.isEnabled = !loggingIn
            self.passwordField.isEnabled = !loggingIn
            self.loginButton.isEnabled = !loggingIn
            self.signUpButton.isEnabled = !loggingIn
        }
    }
    
    // MARK: Clearing Text Fields
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        buttonEnabled(false, button: loginButton)
        if textField == emailField {
            emailFieldIsEmpty = true
        }
        if textField == passwordField {
            passwordFieldIsEmpty = true
        }
        
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let nextField = textField.superview?.viewWithTag(textField.tag + 1) as? UITextField {
            nextField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
            login(loginButton)
        }
        return true
    }
    
    
    // MARK: Toggling Buttons and Text Fields
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == emailField {
            let currenText = emailField.text ?? ""
            guard let stringRange = Range(range, in: currenText) else { return false }
            let updatedText = currenText.replacingCharacters(in: stringRange, with: string)
            
            if updatedText.isEmpty && updatedText == "" {
                emailFieldIsEmpty = true
            } else {
                emailFieldIsEmpty = false
            }
        }
        
        if textField == passwordField {
            let currenText = passwordField.text ?? ""
            guard let stringRange = Range(range, in: currenText) else { return false }
            let updatedText = currenText.replacingCharacters(in: stringRange, with: string)
            
            if updatedText.isEmpty && updatedText == "" {
                passwordFieldIsEmpty = true
            } else {
                passwordFieldIsEmpty = false
            }
        }
        
        if emailFieldIsEmpty == false && passwordFieldIsEmpty == false {
            buttonEnabled(true, button: loginButton)
        } else {
            buttonEnabled(false, button: loginButton)
        }
        
        return true
        
    }
    
}


