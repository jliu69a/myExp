//
//  LoginRegisterViewController.swift
//  MyExps
//
//  Created by Johnson Liu on 1/14/19.
//  Copyright © 2019 Home Office. All rights reserved.
//

import UIKit

class LoginRegisterViewController: UIViewController {
    
    @IBOutlet weak var loginView: UIView!
    @IBOutlet weak var registerView: UIView!
    @IBOutlet weak var titleBarButtonItem: UIBarButtonItem!
    
    //-- for login
    
    @IBOutlet weak var userIdTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var rememberMeSwitch: UISwitch!
    
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var registerButton: UIButton!
    
    //-- for register
    
    @IBOutlet weak var regUserIdTextfield: UITextField!
    @IBOutlet weak var regPasswordTextfield: UITextField!
    @IBOutlet weak var regPassword2Textfield: UITextField!
    
    @IBOutlet weak var regCancelButton: UIButton!
    @IBOutlet weak var regRegisterButton: UIButton!
    
    //MARK: - init
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.titleBarButtonItem.title = "Login"
        self.loginView.isHidden = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    //MARK: - IB actions
    
    @IBAction func loginAction(_ sender: Any) {
        
        //-- call manager class, for login
        
        //-- testing
        UserManager.sharedInstance.userId = "1"
        
        self.closeLoginRegisterPage()
    }
    
    @IBAction func registerAction(_ sender: Any) {
        
        self.titleBarButtonItem.title = "Register"
        self.loginView.isHidden = true
    }
    
    @IBAction func regCancelAction(_ sender: Any) {
        
        self.titleBarButtonItem.title = "Login"
        self.loginView.isHidden = false
    }
    
    @IBAction func regRegisterAction(_ sender: Any) {
        
        //-- call manager class, for register
        self.closeLoginRegisterPage()
    }
    
    //MARK: - close login register page
    
    func closeLoginRegisterPage() {
        self.dismiss(animated: true, completion: nil)
    }
    
}
