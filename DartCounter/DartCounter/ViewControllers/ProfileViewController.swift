//
//  ProfileViewController.swift
//  DartCounter
//
//  Created by Jonas Schlauch on 26.11.20.
//

import UIKit

class ProfileViewController: UIViewController {
    
    var imagePicker: UIImagePickerController!

    
    @IBOutlet weak var profilePictureImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    
    @IBOutlet weak var careerStatsTableView: UITableView!
    var items = ["Karriere Average", "Karriere First 9", "Karriere Doppelquote", "Karriere Siege", "Karriere Niederlagen"]
    var careerStats: CareerStats?
    
    
    @IBAction func onViewHistory(_ sender: UIButton) {
        performSegue(withIdentifier: Segues.Profile_History, sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
    }
    
    private func initView() {
        careerStatsTableView.dataSource = self
        careerStatsTableView.delegate = self
        careerStatsTableView.isScrollEnabled = false
        
        let profileChangeTapGesture = UITapGestureRecognizer(target:self,action:#selector(self.onChangeProfile))
        profilePictureImageView.addGestureRecognizer(profileChangeTapGesture)
        
        imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        
        profilePictureImageView.layer.masksToBounds = true
        profilePictureImageView.layer.cornerRadius = profilePictureImageView.bounds.width / 2
       
        UserService.observeUserProfile(completion: { userProfileObject in
            guard let profile = userProfileObject else { return }
           
            self.usernameLabel.text = profile.username
            
            if let photURL = profile.photoURL {
                UserService.getProfilePicture(withURL: photURL, completion: { profileImage in
                     self.profilePictureImageView.image = profileImage
                 })
            } else {
                self.profilePictureImageView.image = UIImage(named: "profile")
            }
        })
        
        UserService.observeCareerStats(completion: { careerStatsObject in
            guard let stats = careerStatsObject else { return }
            self.careerStats = stats
            self.careerStatsTableView.reloadData()
        })
    }

}

extension ProfileViewController: UITableViewDataSource, UITableViewDelegate {
    
   /**
     override func viewDidLoad() {
         super.viewDidLoad()
         tableView.register(UINib(nibName: "CareerCell", bundle: nil), forCellReuseIdentifier: "CareerCell")
     }
     
     */
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CareerCell", for: indexPath) as! CareerCell
        cell.keyLabel.text = items[indexPath.row]
        
        let index = indexPath.row
        if let stats = self.careerStats {
            if index == 0 {
                cell.valueLabel.text = String(stats.average)
            } else if index == 1 {
                cell.valueLabel.text = String(stats.firstNine)
            } else if index == 2 {
                cell.valueLabel.text = String(stats.checkoutPerentage)
            } else if index == 3 {
                cell.valueLabel.text = String(stats.wins)
            } else if index == 4 {
                cell.valueLabel.text = String(stats.defeats)
            }
        } else {
            if index == 0 {
                cell.valueLabel.text = "0.00"
            } else if index == 1 {
                cell.valueLabel.text = "0.00"
            } else if index == 2 {
                cell.valueLabel.text = "0.00"
            } else if index == 3 {
                cell.valueLabel.text = "0"
            } else if index == 4 {
                cell.valueLabel.text = "0"
            }
        }
        
        return cell
    }
}

extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let pickedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            self.profilePictureImageView.image = pickedImage
            UserService.updateProfileImage(pickedImage) { success in
                // TODO
                print("ProfilePicture update: " + String(success))
            }
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
}

// Contains UserEventHandling
extension ProfileViewController {
    
    @objc func onChangeProfile() {
       self.present(imagePicker, animated: true, completion: nil )
    }
    
}
