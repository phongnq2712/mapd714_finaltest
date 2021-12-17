/**
 * Final Test
 * File Name:    ViewController.swift
 * Author:         Quoc Phong Ngo
 * Student ID:   301148406
 * Version:        1.0
 * Date Modified:   December 17th, 2021
 */

import UIKit
import Firebase
import FirebaseDatabase

class ViewController: UIViewController {
    let ref = Database.database().reference()
    let imperial = 703
    private var bmiScores: [BMI] = []
    @IBOutlet weak var tvHeight: UITextField!
    var placeholderHeight : UILabel!
    
    @IBOutlet weak var tvName: UITextField!
    @IBOutlet weak var tvAge: UITextField!
    @IBOutlet weak var lblResult: UILabel!
    @IBOutlet weak var switchMode: UISwitch!
    @IBOutlet weak var tvWeight: UITextField!
    var placeholderWeight : UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        lblResult.text = ""
        // Placeholder height
        placeholderHeight = UILabel()
        placeholderHeight.text = "inch"
        placeholderHeight.font = UIFont.italicSystemFont(ofSize: CGFloat((15.0)))
        placeholderHeight.sizeToFit()
        tvHeight.addSubview(placeholderHeight)
        // Placeholder weight
        placeholderWeight = UILabel()
        placeholderWeight.text = "lbs"
        placeholderWeight.font = UIFont.italicSystemFont(ofSize: CGFloat((15.0)))
        placeholderWeight.sizeToFit()
        tvWeight.addSubview(placeholderWeight)
        // load the latest data of BMI score
        loadData()
    }
    
    func loadData()
    {
        ref.observe(.value) { [self] snapshot in
            //
            for child in snapshot.children {
                //
                if
                    let snapshot = child as? DataSnapshot,
                    let dataChange = snapshot.value as? [String:AnyObject],
                    let name = dataChange["name"] as? String?,
                    let age = dataChange["age"] as? String?,
                    let height = dataChange["height"] as? String?,
                    let weight = dataChange["weight"] as? String?,
                    let mode = dataChange["mode"] as? String?,
                    let category = dataChange["category"] as? String {

                    tvName.text = name
                    tvAge.text = age
                    tvHeight.text = height
                    tvWeight.text = weight
                    lblResult.text = category
                    if(mode == "Metric") {
                        placeholderHeight.text = "m"
                        placeholderWeight.text = "kg"
                    } else {
                        placeholderHeight.text = "inch"
                        placeholderWeight.text = "lbs"
                    }
                }
            }
        }
    }
    
    /**
     * Handling event for Calculate button
     */
    @IBAction func calculateBMI(_ sender: UIButton) {
        if(!tvHeight.text!.isEmpty && !tvWeight.text!.isEmpty) {
            if(Double(tvHeight.text!) != nil && Double(tvWeight.text!) != nil) {
                // calculate BMI
                var bmi = 0.0
                var mode = ""
                if(placeholderWeight.text == "kg") {
                    // metric
                    bmi = Double(tvWeight.text!)! / (Double(tvHeight.text!)! * Double(tvHeight.text!)!)
                    mode = "Metric"
                } else if(placeholderWeight.text == "lbs") {
                    // imperal
                    bmi = (Double(tvWeight.text!)! / (Double(tvHeight.text!)! * Double(tvHeight.text!)!)) * Double(imperial)
                    mode = "Imperal"
                }
                switch bmi {
                case let x where x < 16:
                    lblResult.text = "Severe Thinness"
                case 16...17:
                    lblResult.text = "Moderate Thinness"
                case 17...18.5:
                    lblResult.text = "Mild Thinness"
                case 18.5...25:
                    lblResult.text = "Normal"
                case 25...30:
                    lblResult.text = "Overweight"
                case 30...35:
                    lblResult.text = "Obese Class I"
                case 35...40:
                    lblResult.text = "Obese Class II"
                default:
                    lblResult.text = "Obese Class III"
                }
                //
                let currentDate = Date()
                let df = DateFormatter()
                df.dateFormat = "yyyy-MM-dd HH:mm:ss"
                let dateString = df.string(from: currentDate)
                let name = tvName.text
                let age = tvAge.text
                let height = tvHeight.text
                let weight = tvWeight.text
                let category = lblResult.text
                self.ref.child(dateString).setValue([
                    "name": name!,
                    "age": age!,
                    "height": height!,
                    "weight": weight!,
                    "bmi": bmi,
                    "category": category!,
                    "mode": mode,
                    "date": dateString
                ])
                DispatchQueue.main.async {
                    let newEntry = [self.tvName.text, self.tvAge.text, self.tvHeight.text, self.tvWeight.text]
                    UserDefaults.standard.setValue(newEntry, forKey: "")
                    self.bmiScores.append(BMI(name: name!, age: Int(age!)!, height: Double(height!)!, weight: Double(weight!)!, bmi: Double(bmi), category: category!, mode: mode, date: dateString))
                }
            }
        } else {
            lblResult.text = ""
        }
    }
    
    /**
     * Handling event for Done button
     */
    @IBAction func btnDoneClicked(_ sender: UIButton) {
        if let vc = storyboard?.instantiateViewController(identifier: "BMITrackingViewController") as? BMITrackingViewController {
            
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    /**
     * Change between Metric and Imperial mode
     */
    @IBAction func switchModeChanged(_ sender: UISwitch) {
        if(sender.isOn) {
            placeholderHeight.text = "inch"
            placeholderWeight.text = "lbs"
        } else {
            placeholderHeight.text = "m"
            placeholderWeight.text = "kg"
        }
    }
}

