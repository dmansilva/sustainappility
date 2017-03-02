//
//  ViewController.swift
//  seniorproject
//
//  Created by Daniel Silva on 2/28/17.
//  Copyright © 2017 D Silvv Apps. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    
    var signupMode = true
    var activityIndicator = UIActivityIndicatorView()
    var isLoggin = true

    @IBOutlet weak var header: UILabel!
    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var lastName: UITextField!
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    
    @IBOutlet weak var signupLoginOutlet: UIButton!
    
    func createAlert(title: String, message: String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
            
            self.dismiss(animated: true, completion: nil)
            
        }))
        
        self.present(alert, animated: true, completion: nil)
        
    }

    
    @IBAction func signupOrLogin(_ sender: Any) {
        
        activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        UIApplication.shared.beginIgnoringInteractionEvents() // UIApplication.shared() is now UIApplication.shared
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let context = appDelegate.persistentContainer.viewContext
        
        
        if signupMode {
            
            // add the user
            
            if firstName.text == "" || lastName.text == "" || username.text == "" || password.text == "" {
                
                createAlert(title: "Error in form", message: "Please enter all information")
                
                self.activityIndicator.stopAnimating()
                UIApplication.shared.endIgnoringInteractionEvents()
                
            } else {
                
                let newUser = NSEntityDescription.insertNewObject(forEntityName: "Users", into: context)
                
                newUser.setValue(firstName.text, forKey: "firstName")
                newUser.setValue(lastName.text, forKey: "lastName")
                newUser.setValue(username.text, forKey: "username")
                newUser.setValue(password.text, forKey: "password")
                
                do {
                    
                    try context.save()
                    
                    
                    isLoggin = true
                    
                    
                    self.createAlert(title: "Sign up Successful", message: "Yessss")
                    
                    self.activityIndicator.stopAnimating()
                    UIApplication.shared.endIgnoringInteractionEvents()
                    
                    
                    
                } catch {
                    
                    print("Failed to save")
                    
                    self.createAlert(title: "Signup Error", message: "Please try again")
                    
                    self.activityIndicator.stopAnimating()
                    UIApplication.shared.endIgnoringInteractionEvents()
                    
                }
                
            }
            
            
            
        } else {
            
            // login mode
            
            do {
                let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Users")
                
                let results = try context.fetch(request)
                
                if results.count > 0 {
                    
                    for result in results as! [NSManagedObject] {
                        
                        if username.text == result.value(forKey: "username") as! String? {
                            
                            if password.text == result.value(forKey: "password") as! String? {
                                
                                // username and password match
                                self.createAlert(title: "Log In Successful", message: "Lets gooooo")
                                
                                self.activityIndicator.stopAnimating()
                                UIApplication.shared.endIgnoringInteractionEvents()
                                
                            } else {
                                
                                // username is correct but password doesn't match
                                self.createAlert(title: "Log In Unsuccessful", message: "Username and Password don't match")
                                
                                self.activityIndicator.stopAnimating()
                                UIApplication.shared.endIgnoringInteractionEvents()
                            }
                        } else {
                            
                            // username doesn't exist
                            self.createAlert(title: "Log In Unsucessful", message: "Username doesn't exist")
                            
                            self.activityIndicator.stopAnimating()
                            UIApplication.shared.endIgnoringInteractionEvents()
                            
                        }
                    }
                }
                
            } catch {
                
                print("Login Request failed")
                
            }
        }
        

        
    }
    
    @IBAction func changeSignupMode(_ sender: Any) {
        
        if signupMode {
            
            // change to login mode
            
            signupLoginOutlet.setTitle("Log In", for: [])
            
            signupLoginChange.setTitle("Sign Up", for: [])
            
            message.text = "Don't have an account?"
            
            header.text = "Login Step"
            
            firstName.alpha = 0
            
            lastName.alpha = 0
            
            signupMode = false
            
        } else {
            
            // change to signup mode
            
            signupLoginOutlet.setTitle("Sign up", for: [])
            
            signupLoginChange.setTitle("Log In", for: [])
            
            message.text = "Already have an account?"
            
            header.text = "Sign up Step"
            
            firstName.alpha = 1
            
            lastName.alpha = 1
            
            signupMode = true
            
        }
        
    }
    
    
    
    @IBOutlet weak var message: UILabel!
    @IBOutlet weak var signupLoginChange: UIButton!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        // change
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

