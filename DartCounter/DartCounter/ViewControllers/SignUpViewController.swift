//
//  SignUpViewController.swift
//  DartCounter
//
//  Created by Jonas Schlauch on 08.11.20.
//

import UIKit
import FirebaseAuth

class SignUpViewController: UIViewController {
    
    @IBOutlet weak var textField_username: UITextField!
    @IBOutlet weak var textField_password: UITextField!
    @IBOutlet weak var textField_passwordAgain: UITextField!
    @IBOutlet weak var label_error: UILabel!
    
    
    @IBAction func onSignUp(_ sender: UIButton) {
        label_error.isHidden = true
        if(validateTextfields()) {
            AuthService.signUpUsernameAndPassword(
                username: textField_username.text!,
                password: textField_password.text!,
                onError: onSignUpError(error:)
            )
        }
    }
    
    @IBAction func onGotoSignIn(_ sender: UIButton) {
        if let nav = self.navigationController {
            nav.popViewController(animated: true)
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // hide navbar
        self.navigationController?.isNavigationBarHidden = true
        
        // hide keyboard if touched screen somewhere outside of keyboard area
        self.hideKeyboardWhenTappedAround()
        
        // subscribe to textfields to receive events
        self.textField_username.delegate = self
        self.textField_password.delegate = self
        self.textField_passwordAgain.delegate = self
    }
    
    // TODO refactor
    func validateTextfields() -> Bool {
        if textField_username.text == nil || textField_password.text == nil || textField_passwordAgain.text == nil {
            return false
        }
        
        if textField_password.text! != textField_passwordAgain.text! {
            label_error.isHidden = false
            label_error.text = "Passwords do not match"
            return false
        }
        
        // TODO
        
        return true
    }
    
}


// handle events from textfields
extension SignUpViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        // if username textfield is focused and return gets pressed focus password textfield
        case textField_username:
            textField_password.becomeFirstResponder()
        // if username password is focused and return gets pressed focus passwordAgain textfield
        case textField_password:
            textField_passwordAgain.becomeFirstResponder()
        // if passwordAgain textfield is focused and return gets pressed hide keyboard and unfocus passwordAgain textfield
        default:
            textField_passwordAgain.resignFirstResponder()
        }
        
        return true
    }
    
}

// TODO refactor
// extension for error handling after trying to contact the Firebase API
extension SignUpViewController {
    
    func onSignUpError(error: NSError) {
        print("onSignUpError")

         switch error.code {
            case FirebaseAuth.AuthErrorCode.networkError.rawValue:
                label_error.isHidden = false
                label_error.text = "Network not reachable"
                break
            case FirebaseAuth.AuthErrorCode.emailAlreadyInUse.rawValue:
                label_error.isHidden = false
                label_error.text = "Username already in use"
                break
            case FirebaseAuth.AuthErrorCode.weakPassword.rawValue:
                label_error.isHidden = false
                label_error.text = "Weak password"
                break
            default:
                print(error.code)
         }
        
    }
    
}
