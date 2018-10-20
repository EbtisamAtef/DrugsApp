//
//  SignUpViewController.swift
//  Drugs
//
//  Created by Ebtisam on 9/15/18.
//  Copyright © 2018 Ebtisam. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class SignUpViewController: UIViewController {
    
    
    @IBOutlet weak var username: UITextField!
    
    @IBOutlet weak var email: UITextField!
    
    @IBOutlet weak var password: UITextField!
    
    @IBOutlet weak var signup: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        handletextfield()
    }
    
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func handletextfield(){
        
        username.addTarget(self, action:#selector(SignUpViewController.chngetextfield), for: UIControlEvents.editingChanged)
        email.addTarget(self, action:#selector(SignUpViewController.chngetextfield), for: UIControlEvents.editingChanged)
        password.addTarget(self, action:#selector(SignUpViewController.chngetextfield), for: UIControlEvents.editingChanged)
        
    }
    
    
    @objc func chngetextfield(){
        
        let nametext = username.text
        let mailtext = email.text
        let passwordtext = password.text
        
        if nametext!.isEmpty || mailtext!.isEmpty || passwordtext!.isEmpty {
            self.signup.isEnabled = false
            
        }else{
            
            signup.isEnabled = true
            signup.backgroundColor = #colorLiteral(red: 0.1994556229, green: 0.579116434, blue: 0.2600405623, alpha: 1)
            signup.setTitleColor(.white, for: .normal)
            
            
        }
    }
    
    
   
    
    @IBAction func SignUp(_ sender: Any) {
        Auth.auth().createUser(withEmail: email.text!, password: password.text!) { (user, error) in
            if error != nil {
                print("sorry unsaved :( \(String(describing: error))")
            }else{
                
                var ref: DatabaseReference!
                ref = Database.database().reference()
                let userid = Auth.auth().currentUser!.uid
                let newuser = ref.child("users").child(userid)
                newuser.setValue(["username": self.username.text!, "mail":self.email.text!])
                
                self.presentingViewController?.dismiss(animated: true, completion: nil)

                
                
            }
        }
    }
    
    
    @IBAction func Backtosignin(_ sender: Any) {
        presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    
    
}










