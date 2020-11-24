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
        if(validate()) {
            AuthService.shared.signUpUsernameAndPassword(
                username: textField_username.text!,
                password: textField_password.text!,
                onSuccess: onSignUpSuccess(user:),
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
        
        self.hideKeyboardWhenTappedAround()
        
        self.textField_username.delegate = self
        self.textField_password.delegate = self
        self.textField_passwordAgain.delegate = self

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.isNavigationBarHidden = false
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Segues.SignUp_Home, let viewController = segue.destination as? HomeViewController {
          
        }
    }

}

extension SignUpViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case textField_username:
            textField_password.becomeFirstResponder()
        case textField_password:
            textField_passwordAgain.becomeFirstResponder()
        default:
            textField_passwordAgain.resignFirstResponder()
        }
        
        return true
    }
    
    func validate() -> Bool {
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

// Extension for success handling after trying to contact the Firebase API
extension SignUpViewController {
    
    func onSignUpSuccess(user: FirebaseAuth.User) {
        print("onSignUpSuccess")
        App.user = User(firebaseUser: user)
        print(App.user!.uid)
        print(App.user!.username)
        
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: Segues.SignUp_Home, sender: self)
        }
    }
    
}

// Extension for error handling after trying to contact the Firebase API
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
