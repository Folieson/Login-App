//
//  ViewController.swift
//  Login App
//
//  Created by Андрей Понамарчук on 15.09.2018.
//  Copyright © 2018 Андрей Понамарчук. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {

    @IBOutlet var usernameTextField: UITextField!
    
    @IBOutlet var logInButton: UIButton!
    
    @IBOutlet var helloLabel: UILabel!
    
    @IBAction func logInButtonPressed(_ sender: UIButton) {
        if usernameTextField.text != "" {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            let newUser = NSEntityDescription.insertNewObject(forEntityName: "Users", into: context)
            newUser.setValue(usernameTextField.text, forKey: "username")
            do {
                try context.save()
            } catch {
                print("There was an error")
            }
            showHelloLabel(to: usernameTextField.text!)
        } else {
            print("usernameTextField is empty")
        }
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let context = appDelegate.persistentContainer.viewContext
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Users")
        
        request.returnsObjectsAsFaults = false
        
        do {
            let results = try context.fetch(request)
            if results.count > 0 {
                for result in results as! [NSManagedObject] {
                    if let username = result.value(forKey: "username") as? String {
                        showHelloLabel(to: username)
                    }
                }
            } else {
                showLogInInterface()
                print("No results")
            }
            
        } catch {
            print("Couldn't fetch results")
        }
        
    }
    
    func showHelloLabel (to username: String) {
        usernameTextField.isEnabled = false
        usernameTextField.isHidden = true
        logInButton.isEnabled = false
        logInButton.isHidden = true
        helloLabel.text = "Hello, \(username)!"
        helloLabel.center = CGPoint(x: helloLabel.center.x - 500, y: helloLabel.center.y)
        helloLabel.isHidden = false
        UIView.animate(withDuration: 2, animations: {
            self.helloLabel.center = CGPoint(x: self.helloLabel.center.x + 500, y: self.helloLabel.center.y)
        })
        
    }
    
    func showLogInInterface() {
        helloLabel.isHidden = true
        usernameTextField.isHidden = false
        usernameTextField.isEnabled = true
        logInButton.isHidden = false
        logInButton.isEnabled = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

