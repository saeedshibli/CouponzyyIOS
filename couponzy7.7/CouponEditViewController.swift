//
//  CouponEditViewController.swift
//  couponzy7.7
//
//  Created by מאיס on 24/07/2021.
//

import UIKit
import Photos

class CouponEditViewController: UIViewController , UIImagePickerControllerDelegate & UINavigationControllerDelegate{

    
    @IBOutlet weak var CouponCodeViewer: UILabel!
    @IBOutlet weak var expireDateViewer:UITextField!
    @IBOutlet weak var couponImageViewer: UIImageView!
    @IBOutlet weak var finalPriceViewer: UITextField!
    @IBOutlet weak var orginalPriceViewer: UITextField!
    @IBOutlet weak var descriptionViewer: UITextField!
    @IBOutlet weak var titleViewer: UITextField!
    
    
    var orginalPrice = Double()
    var finalPrice = Double()
    var descriptions = String()
    var titles = String()
    var couponImage = String();
    var expireDate = String();
    var couponCode = String();
    
    let datePicker = UIDatePicker()
    var imagePickerController = UIImagePickerController();
    var imageUrlFireBaseStorge : String = "";
//    var lb:UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePickerController.delegate = self;
        checkPermistions();
        createDatePicker()
        
        CouponCodeViewer.text = couponCode
        titleViewer.text = titles;
        descriptionViewer.text = descriptions;
        orginalPriceViewer.text = String(orginalPrice);
        finalPriceViewer.text = String(finalPrice);
        expireDateViewer.text =
            expireDate;
        if (couponImage != ""){
        let url = URL(string: couponImage ?? "")
        let data = try? Data(contentsOf: url!)
        couponImageViewer.image = UIImage(data: data!)
        }
    }
    
    
func CheckIfEmptyFeilds()->Bool{
    if(titleViewer.text!.isEmpty){
        showAlert(text: "Please Include Title TEXT")
        return false
    }
    else if((descriptionViewer.text!.isEmpty)){
        showAlert(text: "Please Include Description TEXT")
        return false
    }
    else if((finalPriceViewer.text!.isEmpty) && (orginalPriceViewer.text!.isEmpty)){
        showAlert(text: "FinalPrice / OriginalPrice Are Empty")
        return false
    }
    else if(orginalPriceViewer.text!.isNumeric != true ||
            finalPriceViewer.text!.isNumeric != true){
        showAlert(text: "FinalPrice/OriginalPrice must be only numbers")
        return false
    }
    else if(Double(orginalPriceViewer.text!)! <= Double(finalPriceViewer.text!)!){
        showAlert(text: "FinalPrice should be Lower than OriginalPrice")
        return false
    }
    else if(couponImage==""){
        showAlert(text: "Please select a picture for the coupon")
        return false
    }
    else if(!expireDateViewer.hasText){
        showAlert(text: "Please select a Expire Date for the Coupon")
        return false
    }
//        else if((titleText.text?.isEmpty) != nil){
//            showAlert(text: "Please Include Title TEXT")
//            return false
//        }
//        else if((couponImage.text?.isEmpty) != nil){
//            return false
//        }
//        else if((datePicker.text?.isEmpty) != nil){
//            return false
//        }
    return true;
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
            Model.instance.uploadCouponImage(fileURL: url, pathString: "ImageOf\(couponCode)"){ urlImage in
                print("urlImage is Ready")
                self.couponImage = urlImage;
                self.couponImageViewer.image = self.load(fileName: url);
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
    //Date Picker for valid till Coupon
    
    func createDatePicker(){
        
        datePicker.frame.size = CGSize(width: 0, height: 250)
        datePicker.minimumDate = Date()
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "MMM dd,yyyy"
        datePicker.date = dateFormatterPrint.date(from: self.expireDate)!
        expireDateViewer.textAlignment = .center;
        //toolbar
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        //bar button
        let doneBtn = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePressed));
        toolbar.setItems([doneBtn], animated: true)
        
        //assign toolbar
        expireDateViewer.inputAccessoryView = toolbar
        
        //assign date picker to the text field
        expireDateViewer.inputView = datePicker;
    }
    @objc func donePressed(){
        //formatter
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        
        expireDateViewer.text = formatter.string(from: datePicker.date)
        self.view.endEditing(true)
    }
    @IBAction func SaveBtnTapped(_ sender: Any) {
        if(CheckIfEmptyFeilds()==false){
            return;
        }
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext;
        let coupon = Coupon(context: context);
        //let number = Int.random(in: 90000..<100000)
        coupon.couponCode=couponCode;
        print("Coupon code: \(couponCode)")
        coupon.couponDescription=descriptionViewer.text;
        coupon.discountPrice=Double(finalPriceViewer.text!)!;
        coupon.orginalPrice=Double(orginalPriceViewer.text!)!;
        coupon.expireDate = expireDateViewer.text!;
        coupon.couponImage = couponImage;
        coupon.title=titleViewer.text;
        Indicator.sharedInstance.showIndicator()
        Model.instance.getCurrentUser { user in
            coupon.shopId = user.email//shopId;
            coupon.shopImage=user.shopImageURL//ShopName;
            //let coupon = Coupon.create(xx);
            Model.instance.addCoupon(coupon: coupon){
                Indicator.sharedInstance.hideIndicator()
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    @IBAction func DeleteBtnTapped(_ sender: Any) {
        Indicator.sharedInstance.showIndicator()
        Model.instance.getCoupon(couponCode: couponCode) { coupon in
            Model.instance.deleteCoupon(coupon: coupon) {
                coupon.delete()
                Indicator.sharedInstance.hideIndicator()
                self.navigationController?.popViewController(animated: true)
            }
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
}

