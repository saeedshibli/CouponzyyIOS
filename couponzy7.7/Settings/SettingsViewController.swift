//
//  SettingsViewController.swift
//  couponzy7.7
//
//  Created by מאיס on 22/07/2021.
//

import UIKit

class SettingsViewController: UIViewController {

    @IBOutlet weak var firstnamelastnameLabel: UILabel!
    @IBOutlet weak var userImage: UIImageView!
    
    var currentUser:User = User();
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Indicator.sharedInstance.showIndicator()
        Model.instance.getCurrentUser { user in
            Indicator.sharedInstance.hideIndicator()
            self.currentUser = user;
            print(user.firstName)
            self.firstnamelastnameLabel.text = "Welcome back \(user.firstName) , \(user.lastName)"
            if (!user.shopImageURL.isEmpty){
            let url = URL(string: user.shopImageURL ?? "")
                let data = try? Data(contentsOf: url!)
                if(data != nil){
                    self.userImage.image = UIImage(data: data!)
                    self.userImage.sizeToFit()
                }
            }
        }
        // Do any additional setup after loading the view.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "SettingsToDetails") {
            let vc = segue.destination as! PersonalDetailsViewController
            vc.currentUser = currentUser;
        }
    }
    
    @IBAction func logoutTapped(_ sender: Any) {
        Model.instance.logout()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: "login")
        vc.modalPresentationStyle = .overFullScreen
        present(vc, animated: true)
    }
    
    @IBAction func personalDetailsTapped(_ sender: Any) {
    }
}
