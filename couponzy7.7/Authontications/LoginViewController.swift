//
//  LoginViewController.swift
//  couponzy7.7
//
//  Created by מאיס on 22/07/2021.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkUserInfo()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        checkUserInfo()
    }
    
    @IBAction func loginTapped(_ sender: Any) {
        validateFields()
    }
    
    @IBAction func createAccountTapped(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: "signup")
        vc.modalPresentationStyle = .overFullScreen
        present(vc, animated: true)
    }
    func showAlert(text:String) {
       let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.light)
       let blurEffectView = UIVisualEffectView(effect: blurEffect)
         blurEffectView.frame = view.bounds
         blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
         self.view.addSubview(blurEffectView)
       let previewController = UIAlertController(title: "Alert", message: text, preferredStyle: .alert)


           let cancelAction = UIAlertAction(title: "OK", style: .cancel, handler: { (UIAlertAction) in
               blurEffectView.removeFromSuperview()
           })

           previewController.addAction(cancelAction)

           present(previewController, animated: true, completion: nil)
     }
    
    func validateFields(){
        if(email.text?.isEmpty == true){
            print("no text in email field")
            showAlert(text: "no text in email field")
            return
        }
        else if(password.text?.isEmpty == true){
            print("no text in password field")
            showAlert(text: "no text in password field")
            return
        }
        Indicator.sharedInstance.showIndicator()
        Model.instance.signIn(email: email.text!, password: password.text!) {response in
            if(response == ""){
                Indicator.sharedInstance.hideIndicator()
                self.checkUserInfo();
            }
            else{
                Indicator.sharedInstance.hideIndicator()
                self.showAlert(text: response)
                return;
            }
        }
    }
    func checkUserInfo(){
        if Model.instance.checkUserInfo() == true{
            //Indicator.sharedInstance.hideIndicator()
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(identifier: "mainHome")
            vc.modalPresentationStyle = .overFullScreen
            self.present(vc, animated: true)
        }
    }
}
