//
//  SignInViewController.swift
//  
//
//  Created by Ebtisam on 9/15/18.
//

import UIKit
import Firebase
import FirebaseAuth
import GoogleSignIn
import FBSDKLoginKit


class SignInViewController: UIViewController, GIDSignInUIDelegate, FBSDKLoginButtonDelegate{
    
    @IBOutlet weak var userpassword: UITextField!
    
    @IBOutlet weak var usermail: UITextField!
    
    @IBOutlet weak var signin: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        sutupfacebooklogin()
        setupgooglebutton()
        
        
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    fileprivate func sutupfacebooklogin(){
        
        let loginButton = FBSDKLoginButton()
        view.addSubview(loginButton)
        loginButton.frame = CGRect(x: 16, y: 100 , width: view.frame.width - 32 , height: 40)
        loginButton.delegate = self
    }
    
   
    fileprivate func setupgooglebutton(){
        
        let googlebutton = GIDSignInButton()
        googlebutton.frame = CGRect(x: 16, y: 150 , width: view.frame.width - 32 , height: 40)
        view.addSubview(googlebutton)
        GIDSignIn.sharedInstance().uiDelegate = self
    }
    
    
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        if error != nil{
            print(error)
        }
        print("succeesfull to login facebook")
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        print("did logout of facebook")
    }
    
    
    
    
    func handlesigninfields(){
        
        usermail.addTarget(self, action:#selector(SignInViewController.changesigninfields), for: UIControlEvents.editingChanged)
        userpassword.addTarget(self, action:#selector(SignInViewController.changesigninfields), for: UIControlEvents.editingChanged)
        
    }
    
    @objc func changesigninfields(){
        
        let signinmail = usermail.text
        let signinpassword = userpassword.text
        
        if signinmail!.isEmpty ||  signinpassword!.isEmpty {
            self.signin.isEnabled = false
        }else{
            signin.isEnabled = true
            signin.backgroundColor = #colorLiteral(red: 0.1994556229, green: 0.579116434, blue: 0.2600405623, alpha: 1)
            signin.setTitleColor(.white, for: .normal)
        }
    }

    @IBAction func SignIn(_ sender: Any) {
        Auth.auth().signIn(withEmail: usermail.text! , password: userpassword.text!) { (user, error) in
            
            if error != nil{
                print("the error is \(error!.localizedDescription)")
                return
            }else{
                print("you are succeded")
                self.performSegue(withIdentifier: "signinsegue", sender: nil)

            }
        }
        

    }
    


}
