//
//  ViewController.swift
//  ToDoFire
//
//  Created by Давид Михайлов on 08.02.2021.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class LoginViewController: UIViewController {
    
    let segueIdentifier = "tasksSegue"
    var ref: DatabaseReference!

    @IBOutlet weak var warnLabel: UILabel!
    
   
    @IBOutlet weak var emailTextField: UITextField!
    
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference(withPath: "users")
        NotificationCenter.default.addObserver(self, selector: #selector(kbDidShow), name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(kbDidHide), name: UIResponder.keyboardDidHideNotification, object: nil)
        
        warnLabel.alpha = 0
        
        Auth.auth().addStateDidChangeListener { [weak self] (auth, user) in
            if user != nil {
                self?.performSegue(withIdentifier: (self?.segueIdentifier)!, sender: nil)
            }
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        emailTextField.text = ""
        passwordTextField.text = ""
    }
    
//    Изменили contentSize нашего view, который теперь является scrollView, на размер клавиатуры.
    @objc func kbDidShow(notification: Notification) {
        guard let userInfo = notification.userInfo else {return}
        let kbFrameSize = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        (self.view as! UIScrollView).contentSize = CGSize(width: self.view.bounds.size.width, height: self.view.bounds.height + kbFrameSize.height)
        
        (self.view as! UIScrollView).scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: kbFrameSize.height, right: 0)
    }
    
    @objc func kbDidHide() {
        (self.view as! UIScrollView).contentSize = CGSize(width: self.view.bounds.size.width, height: self.view.bounds.height)
        
    }

    func displayWarningLabel(withText text: String) {
        warnLabel.text = text
        UIView.animate(withDuration: 3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseInOut)  { [weak self] in
            self?.warnLabel.alpha = 1
        } completion: { [weak self] (complete) in
            self?.warnLabel.alpha = 0
        }

    }
    
    @IBAction func loginTapped(_ sender: UIButton) {
        guard let email = emailTextField.text, let password = passwordTextField.text, email != "", password != "" else {
        displayWarningLabel(withText: "Info is incorrect")
            return
        }
        
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] (user, error)  in
            if error != nil {
                self?.displayWarningLabel(withText: "Error occured")
                return
            }
            
            if user != nil {
                self?.performSegue(withIdentifier: "tasksSegue", sender: nil)
                return
            }
            
            self?.warnLabel.text = "No such user"
        }
    }
    
    @IBAction func registerTapped(_ sender: UIButton) {
        guard let email = emailTextField.text, let password = passwordTextField.text, email != "", password != "" else {
        displayWarningLabel(withText: "Info is incorrect")
            return
        }
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] (authResult, error) in
           
            guard error == nil, let user = authResult?.user else {
                print(error!.localizedDescription)
                return
            }
            
            let userRef = self?.ref.child(user.uid)
            userRef?.setValue(["email" : user.email])
            
        }
            
        }
        
    }
    

