//
//  LoginViewController.swift
//  OnTheMap
//
//  Created by Doyinsola Osanyintolu on 5/5/20.
//  Copyright © 2020 DoyinOsanyintolu. All rights reserved.
//

import Foundation
import UIKit


class LoginViewController: UIViewController, UITextFieldDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passowrdField: UITextField!
    @IBOutlet weak var LoginButton: UIButton!
    @IBOutlet weak var LoadingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var acccountLabel: UILabel!
    @IBOutlet weak var signUpButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        usernameField.delegate = self
        passowrdField.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        usernameField.text = ""
        passowrdField.text = ""
        subscribeToKeyboardNotification()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        unsubscribeToKeyboardNotification()
    }
    
    @IBAction func loginTapped(_ sender: Any) {
        if usernameField.text == nil || passowrdField.text == nil {
            alertView()
        } else {
        setLoggingIn(true)
        UdacityClient.login(username: usernameField.text ?? "", password: passowrdField.text ?? "", completionHandler: handleLoginResponse(success:error:))
    }
}
    
    @IBAction func signUpButton(_ sender: Any) {
        setLoggingIn(true)
        UIApplication.shared.open(ParseClient.Endpoint.udacityURL.url, options: [:], completionHandler: nil)
        enableButton(Bool: true)
    }
    
    func setLoggingIn(_ loggingIn: Bool) {
    if loggingIn {
        LoadingIndicator.startAnimating()
    } else {
        LoadingIndicator.stopAnimating()
    }
       enableButton(Bool: !loggingIn)
    }
    
    func handleLoginResponse(success: Bool, error: Error?) {
        if success {
            performSegue(withIdentifier: "LoginSegue", sender: nil)
        } else {
           alertView()
           print(error?.localizedDescription ?? "Something is wrong in the Login View Controller")
        }
    }
    
    func alertView() {
        let alertVC = UIAlertController(title: "Login Failed", message: "", preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertVC, animated: true, completion: nil)
        LoadingIndicator.stopAnimating()
        enableButton(Bool: true)
    }
    
    func enableButton(Bool: Bool) {
        usernameField.isEnabled = Bool
        passowrdField.isEnabled = Bool
        signUpButton.isEnabled =  Bool
        LoginButton.isEnabled = Bool
        
        if Bool == true {
            LoadingIndicator.stopAnimating()
        }
    }
    
    
    func subscribeToKeyboardNotification() {
         NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
         
         NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
     }
     
     func unsubscribeToKeyboardNotification() {
         NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
         
         NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
     }
     
    @objc func keyboardWillHide(_ notification: Notification) {
         view.frame.origin.y = 0
     }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        view.frame.origin.y = 50 - getKeyboardHeight(notification) 
    }
    
    func getKeyboardHeight(_ notification: Notification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.cgRectValue.height
    }
}


