//
//  JointInspectionViewController.swift
//  Inspection
//
//  Created by KpStar on 3/4/18.
//  Copyright © 2018 SaudiArabia. All rights reserved.
//

import UIKit
import Parse

class JointInspectionViewController: UIViewController {

    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var logoutBtn: UIButton!
    @IBOutlet weak var goBtn: UIButton!
    @IBOutlet weak var libraryselPicker: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        CustomizeUI()
        libraryselPicker.delegate = self
        libraryselPicker.dataSource = self
    }
    
    func CustomizeUI() {
        goBtn.layer.borderColor = UIColor.blue.cgColor
        goBtn.layer.borderWidth = 1
        goBtn.layer.cornerRadius = 5
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    @IBAction func backBtnTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func logoutBtnTapped(_ sender: UIButton) {
        PFUser.logOut()
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func goBtnTapped(_ sender: UIButton) {
        
    }
}

extension JointInspectionViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 5
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 5
    }

    
    
}

