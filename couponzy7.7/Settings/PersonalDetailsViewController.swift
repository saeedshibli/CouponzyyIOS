//
//  PersonalDetailsViewController.swift
//  couponzy7.7
//
//  Created by מאיס on 24/07/2021.
//

import UIKit
import Photos

class PersonalDetailsViewController: UIViewController , UIImagePickerControllerDelegate & UINavigationControllerDelegate{
    
    @IBOutlet weak var segmentedControlSwitch: UISegmentedControl!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var lastName: UITextField!
    @IBOutlet weak var shopName: UITextField!
    @IBOutlet weak var phoneNumber: UITextField!
    @IBOutlet weak var shopImage: UIImageView!
    @IBOutlet weak var shopLogoText: UILabel!
    @IBOutlet weak var GalleryBtn: UIButton!
    
    
    var currentUser:User = User();
    var imagePickerController = UIImagePickerController();
    
    var isShop:Bool = true;
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePickerController.delegate = self;
        checkPermistions();
        
        if(currentUser.shopName == ""){
            segmentedControlSwitch.selectedSegmentIndex = 1
            didChangeSegment(segmentedControlSwitch);
        }
        segmentedControlSwitch.isEnabled = false;
        //set current user details :
        firstName.text = currentUser.firstName;
        lastName.text = currentUser.lastName;
        email.text = currentUser.email;
        email.isUserInteractionEnabled = false;
        if(isShop){
            shopName.text = currentUser.shopName;
            phoneNumber.text = currentUser.phoneNumber;
            if (currentUser.shopImageURL != ""){
                let url = URL(string: currentUser.shopImageURL ?? "")
                let data = try? Data(contentsOf: url!)
                shopImage.image = UIImage(data: data!)
            }
        }
        // Do any additional setup after loading the view.
    }
    
    @IBAction func didChangeSegment(_ sender:UISegmentedControl){
        if(sender.selectedSegmentIndex == 0){
            shopName.isEnabled = true;
            phoneNumber.isEnabled = true;
            shopLogoText.isEnabled = true;
            shopImage.isHidden = false;
            isShop=true;
            GalleryBtn.isEnabled = true;
        }
        else if(sender.selectedSegmentIndex == 1){
            shopName.isEnabled = false;
            phoneNumber.isEnabled = false;
            shopLogoText.isEnabled = false;
            shopImage.isHidden = true;
            isShop=false;
            GalleryBtn.isEnabled = false;
        }
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
    func CheckIfEmptyFeilds()->Bool{
        if(firstName.text!.isEmpty){
            showAlert(text: "Please Include firstname TEXT")
            return false
        }
        else if((lastName.text!.isEmpty)){
            showAlert(text: "Please Include lastname TEXT")
            return false
        }
        if(isShop){
            if(shopName.text!.isEmpty){
                showAlert(text: "Please Include shopName TEXT")
                return false
            }
            else if((phoneNumber.text!.isEmpty)){
                showAlert(text: "Please Include phoneNumber TEXT")
                return false
            }
            else if((currentUser.shopImageURL == "")){
                showAlert(text: "Please Include Shop Image TEXT")
                return false
            }
        }
        return true;
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "PersonalDetailsToReset") {
            let vc = segue.destination as! ResetPasswordViewController
            vc.currentUser = currentUser;
        }
    }
    
    @IBAction func SaveChangesTapped(_ sender: Any) {
        if(CheckIfEmptyFeilds()==false){
            return;
        }
        setCurrentUserFields();
        Indicator.sharedInstance.showIndicator()
        Model.instance.addUserDetails(user: currentUser) { response in
            if(self.currentUser.shopName != ""){
                Model.instance.changeShopImageInAllCoupons(email: self.currentUser.email, shopImageUrl: self.currentUser.shopImageURL) {
                    Indicator.sharedInstance.hideIndicator()
                    self.navigationController?.popViewController(animated: true)
                }
            }
            else{
                Indicator.sharedInstance.hideIndicator()
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    func setCurrentUserFields(){
        currentUser.firstName = firstName.text!;
        currentUser.lastName = lastName.text!;
        currentUser.phoneNumber = phoneNumber.text!;
        currentUser.shopName = shopName.text!;
    }
    
    
        @IBAction func UploadPhotoTapped(_ sender: Any) {
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
                Model.instance.uploadCouponImage(fileURL: url, pathString: currentUser.email){ urlImage in
                    print("urlImage is Ready")
                    self.currentUser.shopImageURL = urlImage;
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
}
