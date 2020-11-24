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
        if(validate()) {
            AuthService.shared.signInUsernameAndPassword(
                username: textField_username.text!,
                password: textField_password.text!,
                onSuccess: onSignInUsernameAndPasswordSuccess(user:),
                onError: onSignInUsernameAndPasswordError(error:)
            )
        }
    }
    
    @IBAction func onSignInFacebook(_ sender: UIButton) {
        AuthService.shared.signInFacebook(onError: onSignInFacebookError(error:))
    }
    
    @IBAction func onSignInGoogle(_ sender: UIButton) {
        AuthService.shared.signInGoogle(onError: onSignInGoogleError(error:))
    }
    
    @IBAction func onSignInInstagram(_ sender: UIButton) {
        AuthService.shared.signInInstagram(onError: onSignInInstagramError(error:))
    }
    
    @IBAction func onGotoSignUp(_ sender: UIButton) {
        performSegue(withIdentifier: Segues.SignIn_SignUp, sender: self)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.hideKeyboardWhenTappedAround()
        
        self.textField_username.delegate = self
        self.textField_password.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.isNavigationBarHidden = false
    }

}

extension SignInViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case textField_username:
            textField_password.becomeFirstResponder()
            break
        default:
            textField_password.resignFirstResponder()
        }
        
        return true
    }
    
    func validate() -> Bool {
        if textField_username.text == nil || textField_password.text == nil {
            return false
        }
        
        // TODO
        
        return true
    }
    
}



// Extension for success handling after trying to contact the Firebase API
extension SignInViewController {
    
    func onSignInUsernameAndPasswordSuccess(user: FirebaseAuth.User) {
        print("onSignInSuccess")
        App.user = User(firebaseUser: user)
        print(App.user!.uid)
        print(App.user!.username)
        
        performSegue(withIdentifier: Segues.SignIn_Home, sender: self)
    }
    
}

// Extension for error handling after trying to contact the Firebase API
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
