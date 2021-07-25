//
//  ResetPasswordViewController.swift
//  couponzy7.7
//
//  Created by מאיס on 24/07/2021.
//

import UIKit

class ResetPasswordViewController: UIViewController {

    @IBOutlet weak var oldPassword: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var verifyPassword: UITextField!
    
    var currentUser:User=User();
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    @IBAction func ResetBtnTapped(_ sender: Any) {
        if(CheckIfEmptyFeilds() == false){
            return;
        }
        Indicator.sharedInstance.showIndicator()
        Model.instance.resetUserPassword(email:currentUser.email,password: oldPassword.text! ,newPassword: password.text!) {
            response in
            Indicator.sharedInstance.hideIndicator()
            if(response == ""){
                self.showAlert(text: "Succesfully Resetted the Password"){
                    self.navigationController?.popViewController(animated: true)
                }
            }
            else{
                self.showAlert(text: response)
                return;
            }
        }
    }

    func CheckIfEmptyFeilds()->Bool{
        if(password.text?.isEmpty == true){
            showAlert(text: "insert new password field")
            return false
        }
        else if(verifyPassword.text?.isEmpty == true){
            showAlert(text: "insert verify password field")
            return false
        }
        else if(oldPassword.text?.isEmpty == true){
            showAlert(text: "insert old password field")
            return false
        }
        else if(password.text != verifyPassword.text){
            showAlert(text: "passwords are not mattched field")
            return false
        }
        return true;
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
    func showAlert(text:String,callback:@escaping (()->Void)) {
       let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.light)
       let blurEffectView = UIVisualEffectView(effect: blurEffect)
         blurEffectView.frame = view.bounds
         blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
         self.view.addSubview(blurEffectView)
       let previewController = UIAlertController(title: "Alert", message: text, preferredStyle: .alert)


           let cancelAction = UIAlertAction(title: "OK", style: .cancel, handler: { (UIAlertAction) in
               blurEffectView.removeFromSuperview()
                callback()
           })

           previewController.addAction(cancelAction)

           present(previewController, animated: true, completion: nil)
     }
}
