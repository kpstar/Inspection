//
//  InspectionViewController.swift
//  Inspection
//
//  Created by KpStar on 3/14/18.
//  Copyright © 2018 SaudiArabia. All rights reserved.
//

import UIKit
import Parse

class InspectionViewController: UIViewController {
    
    @IBOutlet weak var tablView: UITableView!
    @IBOutlet weak var resultBtn: UIButton!
    @IBOutlet weak var generateBtn: UIButton!
    @IBOutlet weak var photoBtn: UIButton!
    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var libraryBtn: UIButton!
    
    var LibType = Int()
    var system_name = String()
    var building = String()
    var floor = String()
    var room = String()
    var drawing = String()
    var object: PFObject?
    var installer =  String()
    var summary = String()
    var name = String()
    var location = String()
    var objectId: String?
    
    let mainstoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        CustomizeUI()
        
        if LibType == 0 {
            let query = PFQuery(className: "JointLib")
            let obj = query.whereKey("System", equalTo: self.system_name)
            obj.findObjectsInBackground{ (objects, error) -> Void in
                if ( error == nil) {
                    self.object = objects![0]
                    self.tablView.delegate = self
                    self.tablView.dataSource = self
                    self.tablView.reloadData()
                }
            };
        } else {
            let query = PFQuery(className: "PenetLib")
            let obj = query.whereKey("System", equalTo: self.system_name)
            obj.findObjectsInBackground{ (objects, error) -> Void in
                if ( error == nil) {
                    self.object = objects![0]
                    self.tablView.delegate = self
                    self.tablView.dataSource = self
                    self.tablView.reloadData()
                }
            };
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    @IBAction func libraryBtnTapped(_ sender: UIButton) {
        if self.LibType == 0 {
            let desVC = mainstoryboard.instantiateViewController(withIdentifier: "PreviewViewController") as! PreviewViewController
            desVC.HTMLType = 2
            self.navigationController?.pushViewController(desVC, animated: true)
        } else {
            let desVC = mainstoryboard.instantiateViewController(withIdentifier: "PreviewViewController") as! PreviewViewController
            desVC.HTMLType = 3
            self.navigationController?.pushViewController(desVC, animated: true)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    private func CustomizeUI () {
        resultBtn.layer.borderWidth = 1
        resultBtn.layer.borderColor = UIColor.init(red: 255/255.0, green: 97/255.0, blue: 77/255.0, alpha: 1.0).cgColor
        resultBtn.layer.cornerRadius = 5
        generateBtn.layer.borderWidth = 1
        generateBtn.layer.borderColor = UIColor.init(red: 255/255.0, green: 97/255.0, blue: 77/255.0, alpha: 1.0).cgColor
        generateBtn.layer.cornerRadius = 5
        photoBtn.layer.borderWidth = 1
        photoBtn.layer.cornerRadius = 5
        photoBtn.layer.borderColor = UIColor.init(red: 255/255.0, green: 97/255.0, blue: 77/255.0, alpha: 1.0).cgColor
        libraryBtn.layer.borderWidth = 1
        libraryBtn.layer.cornerRadius = 5
        libraryBtn.layer.borderColor = UIColor.init(red: 255/255.0, green: 97/255.0, blue: 77/255.0, alpha: 1.0).cgColor
        
        generateBtn.isEnabled = false
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }

    @IBAction func resultBtnTapped(_ sender: UIButton) {
        var score = 0
        var data: [String] = []
    
        if LibType == 0 {
            var indexpath = IndexPath(item: 1, section: 0)
            var cell = tablView.cellForRow(at: indexpath) as! InputTableViewCell
            
            let jointType: String! = cell.inputTxt.text
            if jointType == "" {
                displayMyAlertMessage(titleMsg: "Error", alertMsg: "Please insert joint type")
                return
            } else {
                if jointType == object!["Type"] as! String {
                    score += Int(pow(Double(2),Double(11)))
                    data.append("pass")
                } else {
                    data.append("fail")
                }
                cell.inputTxt.text = ""
            }

            indexpath = IndexPath(item: 2, section: 0)
            cell = tablView.cellForRow(at: indexpath) as! InputTableViewCell

            let jointAccess = cell.inputTxt.text
            if jointAccess == "" {
                displayMyAlertMessage(titleMsg: "Error", alertMsg: "Please insert joint Access")
                return
            } else {
                if jointAccess == (object!["Access"] as! String) {
                    score += Int(pow(Double(2),Double(10)))
                    data.append("pass")
                } else {
                    data.append("fail")
                }
                cell.inputTxt.text = ""
            }

            indexpath = IndexPath(item: 3, section: 0)
            cell = tablView.cellForRow(at: indexpath) as! InputTableViewCell

            let jointWidth = cell.inputTxt.text
            if jointWidth == "" {
                displayMyAlertMessage(titleMsg: "Error", alertMsg: "Please insert joint width")
                return
            } else {
                let temp = (jointWidth! as NSString).floatValue
                if temp == object!["MaxWidth"] as! Float {
                    score += Int(pow(Double(2),Double(9)))
                    data.append("pass")
                } else {
                    data.append("fail")
                }
                cell.inputTxt.text = ""
            }

            indexpath = IndexPath(item: 4, section: 0)
            cell = tablView.cellForRow(at: indexpath) as! InputTableViewCell

            let fireRating = cell.inputTxt.text
            if fireRating == "" {
                displayMyAlertMessage(titleMsg: "Error", alertMsg: "Please insert fire rating")
                return
            } else {
                let temp = (fireRating! as NSString).floatValue
                if temp <= object!["FireRating"] as! Float {
                    score += Int(pow(Double(2),Double(8)))
                    data.append("pass")
                } else {
                    data.append("fail")
                }
                cell.inputTxt.text = ""
            }

            indexpath = IndexPath(item: 5, section: 0)
            cell = tablView.cellForRow(at: indexpath) as! InputTableViewCell

            let movement = cell.inputTxt.text
            if movement == "" {
                displayMyAlertMessage(titleMsg: "Error", alertMsg: "Please insert movement capabilities")
                return
            } else {
                let temp = (movement! as NSString).floatValue
                if temp <= object!["Movement"] as! Float {
                    score += Int(pow(Double(2),Double(7)))
                    data.append("pass")
                } else {
                    data.append("fail")
                }
                cell.inputTxt.text = ""
            }

            indexpath = IndexPath(item: 6, section: 0)
            cell = tablView.cellForRow(at: indexpath) as! InputTableViewCell

            let bm = cell.inputTxt.text
            if bm == "" {
                displayMyAlertMessage(titleMsg: "Error", alertMsg: "Please insert base material")
                return
            } else {
                if bm == (object!["BM"] as! String) {
                    score += Int(pow(Double(2),Double(6)))
                    data.append("pass")
                } else {
                    data.append("fail")
                }
                cell.inputTxt.text = ""
            }

            indexpath = IndexPath(item: 7, section: 0)
            cell = tablView.cellForRow(at: indexpath) as! InputTableViewCell

            let bmThick = cell.inputTxt.text
            if bmThick == "" {
                displayMyAlertMessage(titleMsg: "Error", alertMsg: "Please insert bm thickness")
                return
            } else {
                let temp = (bmThick! as NSString).floatValue
                if temp >= object!["MBThickness"] as! Float {
                    score += Int(pow(Double(2),Double(5)))
                    data.append("pass")
                } else {
                    data.append("fail")
                }
                cell.inputTxt.text = ""
            }

            indexpath = IndexPath(item: 8, section: 0)
            cell = tablView.cellForRow(at: indexpath) as! InputTableViewCell

            let fsMaterial = cell.inputTxt.text
            if fsMaterial == "" {
                displayMyAlertMessage(titleMsg: "Error", alertMsg: "Please insert FS Material")
                return
            } else {
                if fsMaterial == (object!["FSMaterial"] as! String) {
                    score += Int(pow(Double(2),Double(4)))
                    data.append("pass")
                } else {
                    data.append("fail")
                }
                cell.inputTxt.text = ""
            }

            indexpath = IndexPath(item: 9, section: 0)
            cell = tablView.cellForRow(at: indexpath) as! InputTableViewCell

            let fsDepth = cell.inputTxt.text
            if fsDepth == "" {
                displayMyAlertMessage(titleMsg: "Error", alertMsg: "Please insert FS depth")
                return
            } else {
                let temp = (fsDepth! as NSString).floatValue
                if temp >= object!["FSMinThickness"] as! Float {
                    score += Int(pow(Double(2),Double(3)))
                    data.append("pass")
                } else {
                    data.append("fail")
                }
                cell.inputTxt.text = ""
            }

            indexpath = IndexPath(item: 10, section: 0)
            cell = tablView.cellForRow(at: indexpath) as! InputTableViewCell

            let rwDensity = cell.inputTxt.text
            if rwDensity == "" {
                displayMyAlertMessage(titleMsg: "Error", alertMsg: "Please insert RW density")
                return
            } else {
                let temp = (rwDensity! as NSString).floatValue
                if temp >= object!["RWMinDensity"] as! Float {
                    score += Int(pow(Double(2),Double(2)))
                    data.append("pass")
                } else {
                    data.append("fail")
                }
                cell.inputTxt.text = ""
            }

            indexpath = IndexPath(item: 11, section: 0)
            cell = tablView.cellForRow(at: indexpath) as! InputTableViewCell

            let rwThick = cell.inputTxt.text
            if rwThick == "" {
                displayMyAlertMessage(titleMsg: "Error", alertMsg: "Please insert RW Thickness")
                return
            } else {
                let temp = (rwThick! as NSString).floatValue
                if temp >= object!["RWMinThickness"] as! Float {
                    score += Int(pow(Double(2),Double(1)))
                    data.append("pass")
                } else {
                    data.append("fail")
                }
                cell.inputTxt.text = ""
            }
            
            indexpath = IndexPath(item: 12, section: 0)
            cell = tablView.cellForRow(at: indexpath) as! InputTableViewCell
            
            let rwCompression = cell.inputTxt.text
            if rwCompression == "" {
                displayMyAlertMessage(titleMsg: "Error", alertMsg: "Please insert RW Compression")
                return
            } else {
                let temp = (rwCompression! as NSString).floatValue
                if  temp >= object!["RWMinCompression"] as! Float {
                    score += Int(pow(Double(2),Double(0)))
                    data.append("pass")
                } else {
                    data.append("fail")
                }
                cell.inputTxt.text = ""
            }
            
            for index in 1 ... 12 {
                indexpath = IndexPath(item: index, section: 0)
                cell = tablView.cellForRow(at: indexpath) as! InputTableViewCell
                
                cell.result = data[index - 1]
            }
            
            var passFlag = ""
            if score == 4095 {
                resultLabel.text = "Pass"
                resultLabel.textColor = UIColor.green
                resultLabel.font = resultLabel.font.withSize(18.0)
                passFlag = "Pass"
            } else {
                resultLabel.text = "Fail"
                resultLabel.textColor = UIColor.red
                resultLabel.font = resultLabel.font.withSize(16.0)
                passFlag = "Fail"
            }
            
            let recObj = PFObject(className: "Report")
            recObj["Installer"] =  self.installer
            recObj["Building"] =  self.building
            recObj["Floor"] =  self.floor
            recObj["Room"] =  self.room
            recObj["Drawing"] =  self.drawing
            recObj["TotalNum"] = String(score)
            let date = Date()
            let formatter = DateFormatter()
            formatter.dateFormat = "dd/MM/yyyy"
            let result = formatter.string(from: date)
            recObj["Date"] = result
            recObj["TestType"] = jointType
            recObj["Status"] = passFlag
            recObj["System"] =  self.system_name
            recObj["FireRating"] = fireRating
            recObj["Access"] = jointAccess
            recObj["MaxWidth"] = jointWidth
            recObj["Movement"] = movement
            recObj["RWMinThickness"] = rwThick
            recObj["BM"] = bm
            recObj["StatusArray"] = data
            recObj["FSMinThickness"] = fsDepth
            recObj["FSMaterial"] = fsMaterial
            recObj["RWMinCompression"] = rwCompression
            recObj["RWMinDensity"] = rwDensity
            recObj["MBThickness"] = bmThick
            recObj["ProjectSummary"] = self.summary
            recObj["ProjectName"] = self.name
            recObj["ProjectLocation"] = self.location
            let mtitle = "Report{" + installer + "-" + building + " Building-" + floor + " Floor-Room" + room + "-" + drawing + "}"
            recObj["Title"] = mtitle
            
            recObj.saveInBackground{ (saved: Bool, error: Error?) -> Void in
                if saved {
                    self.objectId = recObj.objectId
                    self.generateBtn.isEnabled = true
                } else {
                    self.displayMyAlertMessage(titleMsg: "error", alertMsg: (error?.localizedDescription)!)
                    self.generateBtn.isEnabled = false
                }
            }
        } else {
            var indexpath = IndexPath(item: 1, section: 0)
            var cell = tablView.cellForRow(at: indexpath) as! InputTableViewCell
            
            let penetType: String! = cell.inputTxt.text
            if penetType == "" {
                displayMyAlertMessage(titleMsg: "Error", alertMsg: "Please insert penetration type")
                return
            } else {
                if penetType == object!["Type"] as! String {
                    score += Int(pow(Double(2),Double(13)))
                    data.append("pass")
                } else {
                    data.append("fail")
                }
                cell.inputTxt.text = ""
            }
            
            indexpath = IndexPath(item: 2, section: 0)
            cell = tablView.cellForRow(at: indexpath) as! InputTableViewCell
            
            let penetAccess = cell.inputTxt.text
            if penetAccess == "" {
                displayMyAlertMessage(titleMsg: "Error", alertMsg: "Please insert penetration Access")
                return
            } else {
                if penetAccess == (object!["Access"] as! String) {
                    score += Int(pow(Double(2),Double(12)))
                    data.append("pass")
                } else {
                    data.append("fail")
                }
                cell.inputTxt.text = ""
            }
            
            indexpath = IndexPath(item: 3, section: 0)
            cell = tablView.cellForRow(at: indexpath) as! InputTableViewCell
            
            let penetSize = cell.inputTxt.text
            if penetSize == "" {
                displayMyAlertMessage(titleMsg: "Error", alertMsg: "Please insert penetration size")
                return
            } else {
                let temp = (penetSize! as NSString).floatValue
                if temp == object!["MEPSize"] as! Float {
                    score += Int(pow(Double(2),Double(11)))
                    data.append("pass")
                } else {
                    data.append("fail")
                }
                cell.inputTxt.text = ""
            }
            
            indexpath = IndexPath(item: 4, section: 0)
            cell = tablView.cellForRow(at: indexpath) as! InputTableViewCell
            
            let opensize = cell.inputTxt.text
            if opensize == "" {
                displayMyAlertMessage(titleMsg: "Error", alertMsg: "Please insert opening size")
                return
            } else {
                let temp = (opensize! as NSString).floatValue
                if temp <= object!["OpeningSize"] as! Float {
                    score += Int(pow(Double(2),Double(10)))
                    data.append("pass")
                } else {
                    data.append("fail")
                }
                cell.inputTxt.text = ""
            }
            
            indexpath = IndexPath(item: 5, section: 0)
            cell = tablView.cellForRow(at: indexpath) as! InputTableViewCell
            
            let minannular = cell.inputTxt.text
            if minannular == "" {
                displayMyAlertMessage(titleMsg: "Error", alertMsg: "Please insert min annular")
                return
            } else {
                let temp = (minannular! as NSString).floatValue
                if temp >= object!["MinAnnular"] as! Float {
                    score += Int(pow(Double(2),Double(9)))
                    data.append("pass")
                } else {
                    data.append("fail")
                }
                cell.inputTxt.text = ""
            }
            
            indexpath = IndexPath(item: 6, section: 0)
            cell = tablView.cellForRow(at: indexpath) as! InputTableViewCell
            
            let maxannular = cell.inputTxt.text
            if maxannular == "" {
                displayMyAlertMessage(titleMsg: "Error", alertMsg: "Please insert max annular")
                return
            } else {
                let temp = (maxannular! as NSString).floatValue
                if temp <= object!["MaxAnnular"] as! Float {
                    score += Int(pow(Double(2),Double(8)))
                    data.append("pass")
                } else {
                    data.append("fail")
                }
                cell.inputTxt.text = ""
            }
            
            indexpath = IndexPath(item: 7, section: 0)
            cell = tablView.cellForRow(at: indexpath) as! InputTableViewCell
            
            let fireRating = cell.inputTxt.text
            if fireRating == "" {
                displayMyAlertMessage(titleMsg: "Error", alertMsg: "Please insert fire rating")
                return
            } else {
                let temp = (fireRating! as NSString).floatValue
                if temp <= object!["FireRating"] as! Float {
                    score += Int(pow(Double(2),Double(7)))
                    data.append("pass")
                } else {
                    data.append("fail")
                }
                cell.inputTxt.text = ""
            }
            
            indexpath = IndexPath(item: 8, section: 0)
            cell = tablView.cellForRow(at: indexpath) as! InputTableViewCell
            
            let wf = cell.inputTxt.text
            if wf == "" {
                displayMyAlertMessage(titleMsg: "Error", alertMsg: "Please insert wall/floor")
                return
            } else {
                if wf == (object!["WF"] as! String) {
                    score += Int(pow(Double(2),Double(6)))
                    data.append("pass")
                } else {
                    data.append("fail")
                }
                cell.inputTxt.text = ""
            }
            
            indexpath = IndexPath(item: 9, section: 0)
            cell = tablView.cellForRow(at: indexpath) as! InputTableViewCell
            
            let bm = cell.inputTxt.text
            if bm == "" {
                displayMyAlertMessage(titleMsg: "Error", alertMsg: "Please insert base material")
                return
            } else {
                if bm == (object!["BM"] as! String) {
                    score += Int(pow(Double(2),Double(5)))
                    data.append("pass")
                } else {
                    data.append("fail")
                }
                cell.inputTxt.text = ""
            }
            
            indexpath = IndexPath(item: 10, section: 0)
            cell = tablView.cellForRow(at: indexpath) as! InputTableViewCell
            
            let bmThick = cell.inputTxt.text
            if bmThick == "" {
                displayMyAlertMessage(titleMsg: "Error", alertMsg: "Please insert bm thickness")
                return
            } else {
                let temp = (bmThick! as NSString).floatValue
                if temp >= object!["MBThick"] as! Float {
                    score += Int(pow(Double(2),Double(4)))
                    data.append("pass")
                } else {
                    data.append("fail")
                }
                cell.inputTxt.text = ""
            }
            
            indexpath = IndexPath(item: 11, section: 0)
            cell = tablView.cellForRow(at: indexpath) as! InputTableViewCell
            
            let fsMaterial = cell.inputTxt.text
            if fsMaterial == "" {
                displayMyAlertMessage(titleMsg: "Error", alertMsg: "Please insert FS Material")
                return
            } else {
                if fsMaterial == (object!["FSMaterial"] as! String) {
                    score += Int(pow(Double(2),Double(3)))
                    data.append("pass")
                } else {
                    data.append("fail")
                }
                cell.inputTxt.text = ""
            }
            
            indexpath = IndexPath(item: 12, section: 0)
            cell = tablView.cellForRow(at: indexpath) as! InputTableViewCell
            
            let fsDepth = cell.inputTxt.text
            if fsDepth == "" {
                displayMyAlertMessage(titleMsg: "Error", alertMsg: "Please insert FS depth")
                return
            } else {
                let temp = (fsDepth! as NSString).floatValue
                if temp >= object!["FSMinThickness"] as! Float {
                    score += Int(pow(Double(2),Double(2)))
                    data.append("pass")
                } else {
                    data.append("fail")
                }
                cell.inputTxt.text = ""
            }
            
            indexpath = IndexPath(item: 13, section: 0)
            cell = tablView.cellForRow(at: indexpath) as! InputTableViewCell
            
            let rwDensity = cell.inputTxt.text
            if rwDensity == "" {
                displayMyAlertMessage(titleMsg: "Error", alertMsg: "Please insert RW density")
                return
            } else {
                let temp = (rwDensity! as NSString).floatValue
                if temp >= object!["RWMinDensity"] as! Float {
                    score += Int(pow(Double(2),Double(1)))
                    data.append("pass")
                } else {
                    data.append("fail")
                }
                cell.inputTxt.text = ""
            }
            
            indexpath = IndexPath(item: 14, section: 0)
            cell = tablView.cellForRow(at: indexpath) as! InputTableViewCell
            
            let rwThick = cell.inputTxt.text
            if rwThick == "" {
                displayMyAlertMessage(titleMsg: "Error", alertMsg: "Please insert RW Thickness")
                return
            } else {
                let temp = (rwThick! as NSString).floatValue
                if temp >= object!["RWMinThickness"] as! Float {
                    score += Int(pow(Double(2),Double(0)))
                    data.append("pass")
                } else {
                    data.append("fail")
                }
                cell.inputTxt.text = ""
            }
            
            for index in 1 ... 14 {
                indexpath = IndexPath(item: index, section: 0)
                cell = tablView.cellForRow(at: indexpath) as! InputTableViewCell
                cell.result = data[index - 1]
            }
            
            var passFlag = ""
            if score == 16383 {
                resultLabel.text = "Pass"
                resultLabel.textColor = UIColor.green
                resultLabel.font = resultLabel.font.withSize(18.0)
                passFlag = "Pass"
            } else {
                resultLabel.text = "Fail"
                resultLabel.textColor = UIColor.red
                resultLabel.font = resultLabel.font.withSize(16.0)
                passFlag = "Fail"
            }
            
            let recObj = PFObject(className: "Report")
            recObj["Installer"] =  self.installer
            recObj["Building"] =  self.building
            recObj["Floor"] =  self.floor
            recObj["Room"] =  self.room
            recObj["Drawing"] =  self.drawing
            recObj["TotalNum"] = String(score)
            let date = Date()
            let formatter = DateFormatter()
            formatter.dateFormat = "dd/MM/yyyy"
            let result = formatter.string(from: date)
            recObj["Date"] = result
            recObj["TestType"] = penetType
            recObj["Status"] = passFlag
            recObj["System"] =  self.system_name
            recObj["FireRating"] = fireRating
            recObj["Access"] = penetAccess
            recObj["MEPSize"] = penetSize
            recObj["StatusArray"] = data
            recObj["OpeningSize"] = opensize
            recObj["MaxAnnular"] = maxannular
            recObj["RWMinThickness"] = rwThick
            recObj["BM"] = bm
            recObj["FSMinThickness"] = fsDepth
            recObj["FSMaterial"] = fsMaterial
            recObj["MinAnnular"] = minannular
            recObj["RWMinDensity"] = rwDensity
            recObj["MBThickness"] = bmThick
            recObj["WF"] = wf
            recObj["ProjectSummary"] = self.summary
            recObj["ProjectName"] = self.name
            recObj["ProjectLocation"] = self.location
            let title = "Report{" + installer + "-" + building + " Building-" + floor + " Floor-Room" + room + "-" + drawing + "}"
            recObj["Title"] = title
            
            recObj.saveInBackground{ (saved: Bool, error: Error?) -> Void in
                if saved {
                    self.generateBtn.isEnabled = true
                    self.objectId = recObj.objectId
                } else {
                    self.displayMyAlertMessage(titleMsg: "error", alertMsg: (error?.localizedDescription)!)
                    self.generateBtn.isEnabled = false
                    return
                }
            }
            
        }
    }
    
    private func displayMyAlertMessage( titleMsg: String, alertMsg: String) {
        let alertdialog = UIAlertController(title: titleMsg, message: alertMsg , preferredStyle: UIAlertControllerStyle.alert)
        alertdialog.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default){(ACTION) in
        })
        self.present(alertdialog,animated: true)
    }
    
    @IBAction func generateBtnTapped(_ sender: UIButton) {
        let desVC = mainstoryboard.instantiateViewController(withIdentifier: "PreviewViewController") as! PreviewViewController
        desVC.HTMLType = self.LibType
        desVC.objectId = self.objectId!
        self.navigationController?.pushViewController(desVC, animated: true)
    }
    
    @IBAction func photoBtnTapped(_ sender: UIButton) {
        
    }
}

extension InspectionViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TitleTableViewCell") as! TitleTableViewCell
            cell.selectionStyle = .none
            if (self.LibType == 0) {
                cell.data = ["Joint App","Input",system_name,"Result"]
            } else {
                cell.data = ["Penet App", "Input",system_name,"Result"]
            }
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "InputTableViewCell") as! InputTableViewCell
            cell.selectionStyle = .none
            if object == nil {
                return cell
            }
            
            if self.LibType == 0 {
                switch(indexPath.row) {
                case 1:
                    cell.data = ["Joint Type", self.object!["Type"] as! String, "", ""]
                    break
                case 2:
                    cell.data = ["Joint Access", self.object!["Access"] as! String, "", ""]
                    break
                case 3:
                    cell.data = ["Joint Width", String(self.object!["MaxWidth"] as! Float), "mm", "n"]
                    break
                case 4:
                    cell.data = ["Fire Rating", String(self.object!["FireRating"] as! Float), "hr", "n"]
                    break
                case 5:
                    cell.data = ["Movement Capabilities", String(self.object!["Movement"] as! Float), "%", "n"]
                    break
                case 6:
                    cell.data = ["Base Material", self.object!["BM"] as! String, "", ""]
                    break
                case 7:
                    cell.data = ["BM Thickness", String(self.object!["MBThickness"] as! Float), "mm", "n"]
                    break
                case 8:
                    cell.data = ["FS Material", self.object!["FSMaterial"] as! String, "", ""]
                    break
                case 9:
                    cell.data = ["FS Depth", String(self.object!["FSMinThickness"] as! Float), "mm", "n"]
                    break
                case 10:
                    cell.data = ["RW Density", String(self.object!["RWMinDensity"] as! Float), "kg/㎥", "n"]
                    break
                case 11:
                    cell.data = ["RW Thickness", String(self.object!["RWMinThickness"] as! Float), "mm", "n"]
                    break
                case 12:
                    cell.data = ["RW Compression", String(self.object!["RWMinCompression"] as! Float), "%", "n"]
                    break
                default:
                    break
                }
            } else {
                switch(indexPath.row) {
                case 1:
                    cell.data = ["Penetration Type", self.object!["Type"] as! String, "", ""]
                    break
                case 2:
                    cell.data = ["Penetration Access", self.object!["Access"] as! String, "", ""]
                    break
                case 3:
                    cell.data = ["MepSize", String(self.object!["MEPSize"] as! Float), "mm", "n"]
                    break
                case 4:
                    cell.data = ["Opening Size", String(self.object!["OpeningSize"] as! Float), "mm", "n"]
                    break
                case 5:
                    cell.data = ["Min Annular", String(self.object!["MinAnnular"] as! Float), "mm", "n"]
                    break
                case 6:
                    cell.data = ["Max Annular", String(self.object!["MaxAnnular"] as! Float), "mm", "n"]
                    break
                case 7:
                    cell.data = ["Fire Rating", String(self.object!["FireRating"] as! Float), "hr", "n"]
                    break
                case 8:
                    cell.data = ["Wall/Floor", self.object!["WF"] as! String, "", ""]
                    break
                case 9:
                    cell.data = ["Base Material", self.object!["BM"] as! String, "", ""]
                    break
                case 10:
                    cell.data = ["BM Thickness", String(self.object!["MBThick"] as! Float), "mm", "n"]
                    break
                case 11:
                    cell.data = ["FS Material", self.object!["FSMaterial"] as! String, "", ""]
                    break
                case 12:
                    cell.data = ["FS Depth", String(self.object!["FSMinThickness"] as! Float), "mm", "n"]
                    break
                case 13:
                    cell.data = ["RW Density", String(self.object!["RWMinDensity"] as! Float), "kg/㎥", "n"]
                    break
                case 14:
                    cell.data = ["RW Thickness", String(self.object!["RWMinThickness"] as! Float), "mm", "n"]
                    break
                default:
                    break
                }
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 35.0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.LibType == 0 {
            return 13
        } else {
            return 15
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            return
        } else {
            let cell: InputTableViewCell = tableView .cellForRow(at: indexPath)! as! InputTableViewCell
            cell.inputTxt.becomeFirstResponder()
        }
    }
}
