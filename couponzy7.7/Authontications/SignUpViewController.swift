//
//  SignUpViewController.swift
//  couponzy7.7
//
//  Created by מאיס on 22/07/2021.
//

import UIKit
import Photos

class SignUpViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {

    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var verifyPassword: UITextField!
    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var lastName: UITextField!
    @IBOutlet weak var shopName: UITextField!
    @IBOutlet weak var phoneNumber: UITextField!
    @IBOutlet weak var shopImage: UIImageView!
    @IBOutlet weak var shopLogoText: UILabel!
    
    var isShop:Bool=true;
    var shopImageUrl:String="";
    var imagePickerController = UIImagePickerController();
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePickerController.delegate = self;
        checkPermistions();
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
    @IBAction func signUpTapped(_ sender: Any) {
        
        if(email.text?.isEmpty == true || !isValidEmail(email: email.text!)){
            showAlert(text: "please enter a valid email")
            return
        }
        else if(password.text?.isEmpty == true){
            showAlert(text: "Please enter a password")
            return
        }
        else if(verifyPassword.text?.isEmpty == true){
            showAlert(text: "please Verify the password")
            return
        }
        else if(password.text != verifyPassword.text){
            showAlert(text: "password and verify password don't match")
            return
        }
        else if(firstName.text?.isEmpty == true){
            showAlert(text: "Please enter firstname")
            return
        }
        else if(lastName.text?.isEmpty == true){
            showAlert(text: "Please enter lastname")
            return
        }
        if(isShop){
            if(phoneNumber.text?.isEmpty == true){
                showAlert(text: "please enter phonenumber")
                return
            }
            else if(shopName.text?.isEmpty == true){
                showAlert(text: "please enter shopname")
                return
            }
            else if(shopImageUrl == ""){
                showAlert(text: "please select a picture")
                return
            }
        }
        Indicator.sharedInstance.showIndicator()
        Model.instance.signUp(email: email.text!.lowercased(), password: password.text!, firstname: firstName.text!, lastName: lastName.text!, phoneNumber: phoneNumber.text!, shopName: shopName.text!, shopImageUrl: shopImageUrl) {response in
            Indicator.sharedInstance.hideIndicator()
            if(response == ""){
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let vc = storyboard.instantiateViewController(identifier: "mainHome")
                vc.modalPresentationStyle = .overFullScreen
                self.present(vc, animated: true)
            }
            else{
                self.showAlert(text: response)
            }
        };
    }
    
    @IBAction func didChangeSegment(_ sender:UISegmentedControl){
        if(sender.selectedSegmentIndex == 0){
            shopName.isEnabled = true;
            phoneNumber.isEnabled = true;
            shopLogoText.isEnabled = true;
            shopImage.isHidden = false;
            isShop=true;
        }
        else if(sender.selectedSegmentIndex == 1){
            shopName.isEnabled = false;
            phoneNumber.isEnabled = false;
            shopLogoText.isEnabled = false;
            shopImage.isHidden = true;
            isShop=false;
        }
    }
    @IBAction func loginTapped(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: "login")
        vc.modalPresentationStyle = .overFullScreen
        present(vc, animated: true)
    }
    
    
    
    @IBAction func CameraButtonTapped(_ sender: Any) {
        if(email.text!.isEmpty || !isValidEmail(email: email.text!)){
            showAlert(text: "Please Provide email address before trying to select the image")
            return;
        }
        self.imagePickerController.sourceType = .photoLibrary
        self.present(self.imagePickerController, animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        //Displaying the image and uploading it to FireBase]
        //imageUrlFireBaseStorge="x";
        if let url = info[UIImagePickerController.InfoKey.imageURL] as? URL{
            print(url)
            //couponImage.image = load(fileName: url);
            Indicator.sharedInstance.showIndicator()
            Model.instance.uploadCouponImage(fileURL: url, pathString: "ImageOf\(self.email.text!)"){ urlImage in
                print("urlImage is Ready")
                self.shopImageUrl = urlImage;
                self.shopImage.image = self.load(fileName: url);
                Indicator.sharedInstance.hideIndicator()
            };
            
        }
        imagePickerController.dismiss(animated: true, completion: nil)
    }
    
    private func load(fileName: URL) -> UIImage? {
        let fileURL = fileName;
        do {
            let imageData = try Data(contentsOf: fileURL)
            return UIImage(data: imageData)
        } catch {
            print("Error loading image : \(error)")
        }
        return nil
    }
    
    func checkPermistions(){
        if(PHPhotoLibrary.authorizationStatus() != PHAuthorizationStatus.authorized){
            PHPhotoLibrary.requestAuthorization({(status: PHAuthorizationStatus)-> Void in
                ()
            })
        }
        if(PHPhotoLibrary.authorizationStatus() == PHAuthorizationStatus.authorized){
            
        }else{
            PHPhotoLibrary.requestAuthorization(requestAuthorizationHandler)
        }
    }
    func requestAuthorizationHandler(status: PHAuthorizationStatus){
        if(PHPhotoLibrary.authorizationStatus() == PHAuthorizationStatus.authorized){
            print("we have access to photos")
        }
        else{
            print("we don't have access to photos");
        }
    }
    func isValidEmail(email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
}
