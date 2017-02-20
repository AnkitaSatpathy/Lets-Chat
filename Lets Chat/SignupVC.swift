//
//  SignupVC.swift
//  Lets Chat
//
//  Created by Ankita Satpathy on 10/02/17.
//  Copyright © 2017 Ankita Satpathy. All rights reserved.
//

import UIKit
import Firebase

class SignupVC: UIViewController {

    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    let CONTACTS_SEGUE = "contactsSegue"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func viewDidAppear(_ animated: Bool) {
        
        if FIRAuth.auth()?.currentUser != nil{
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "contactsVC")
            present(vc, animated: true, completion: nil)
        }
    }
    
    @IBAction func looginPressed(_ sender: Any) {
        
        guard emailField.text != "" ,passwordField.text != ""  else {
            return
        }
        
        FIRAuth.auth()?.signIn(withEmail: self.emailField.text!, password: self.passwordField.text!, completion: { (user, error) in
            if let error = error{
                print(error.localizedDescription)
            }
            
            if let user = user{
                let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "contactsVC")
                self.present(vc, animated: true, completion: nil)
            }
        })
        
    }
   
    @IBAction func signupPressed(_ sender: Any) {
        guard emailField.text != "" ,passwordField.text != ""  else {
            return
        }
        
       
            FIRAuth.auth()?.createUser(withEmail: emailField.text!, password: passwordField.text!, completion: { (user, error) in
                if let error = error {
                    print(error.localizedDescription)
                }
                if user?.uid != nil{
                    
                    //strore mail and pw
                    DatabaseProvider.Instance.saveUser(id: user!.uid, email: self.emailField.text!, paasword: self.passwordField.text!)
                    
                    FIRAuth.auth()?.signIn(withEmail: self.emailField.text!, password: self.passwordField.text!, completion: { (user, error) in
                        if let error = error{
                            print(error.localizedDescription)
                        }
                        
                        if let user = user{
                            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "contactsVC")
                            self.present(vc, animated: true, completion: nil)
                        }
                    })
                }
        
           })
      }
}
