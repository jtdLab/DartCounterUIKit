//
//  LoginViewController.swift
//  DartCounter
//
//  Created by Jonas Schlauch on 08.11.20.
//

import UIKit
import FirebaseAuth
import FirebaseAuth.FIRAuthErrors

class SignInViewController: UIViewController {
    
    @IBOutlet weak var textField_username: UITextField!
    @IBOutlet weak var textField_password: UITextField!
    @IBOutlet weak var label_error: UILabel!
    
    
    @IBAction func onSignInUsernameAndPassword(_ sender: UIButton) {
        if(validateTextfields()) {
            AuthService.signInUsernameAndPassword(
                username: textField_username.text!,
                password: textField_password.text!,
                onError: onSignInUsernameAndPasswordError(error:)
            )
        }
    }
    
    @IBAction func onSignInFacebook(_ sender: UIButton) {
        AuthService.signInFacebook(onError: onSignInFacebookError(error:))
    }
    
    @IBAction func onSignInGoogle(_ sender: UIButton) {
        AuthService.signInGoogle(onError: onSignInGoogleError(error:))
    }
    
    @IBAction func onSignInInstagram(_ sender: UIButton) {
        AuthService.signInInstagram(onError: onSignInInstagramError(error:))
    }
    
    @IBAction func onGotoSignUp(_ sender: UIButton) {
        performSegue(withIdentifier: Segues.SignIn_SignUp, sender: self)
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
    }
    
    // TODO refactor
    func validateTextfields() -> Bool {
        if textField_username.text == nil || textField_password.text == nil {
            return false
        }
        
        // TODO
        
        return true
    }

}


// handle events from textfields
extension SignInViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        // if username textfield is focused and return gets pressed focus password textfield
        case textField_username:
            textField_password.becomeFirstResponder()
            break
        // if password textfield is focused and return gets pressed hide keyboard and unfocus password textfield
        default:
            textField_password.resignFirstResponder()
        }

        return true
    }
    
}

// TODO refactor
// extension for error handling after trying to contact the Firebase API
extension SignInViewController {
    
    func onSignInUsernameAndPasswordError(error: NSError) {
        switch error.code {
        case FirebaseAuth.AuthErrorCode.networkError.rawValue:
            label_error.text = "Network not reachable"
        default:
            label_error.text = "Wrong username or password"
        }
       
        // TODO
        print("onSignInUsernameAndPasswordError")
        print(error.code)
        print(error.userInfo)
    }
    
    func onSignInFacebookError(error: NSError) {
        // TODO
        print("onSignInFacebookError")
        print(error.code)
        print(error.userInfo)
    }
    
    func onSignInGoogleError(error: NSError) {
        // TODO
       
        print("onSignInGoogleError")
        print(error.code)
        print(error.userInfo)
    }
    
    func onSignInInstagramError(error: NSError) {
        // TODO
        print("onSignInInstagramError")
        print(error.code)
        print(error.userInfo)
    }
    
}
