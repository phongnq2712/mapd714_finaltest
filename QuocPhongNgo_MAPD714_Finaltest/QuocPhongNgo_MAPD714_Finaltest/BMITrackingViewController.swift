/**
 * Final Test
 * File Name:    BMITrackingViewController.swift
 * Author:         Quoc Phong Ngo
 * Student ID:   301148406
 * Version:        1.0
 * Date Modified:   December 17th, 2021
 */

import UIKit
import Firebase
import FirebaseDatabase

class BMITrackingViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    let ref = Database.database().reference()
    private var bmiList: [BMI] = []
    let tableIdentifier = "bmiTable"
    
    var nameInAddView = ""
    var ageInAddView = ""
    var heightInAddView = ""
    override func viewDidLoad() {
        loadData()
        super.viewDidLoad()
        tableView.register(BMITrackingTableViewCell.self, forCellReuseIdentifier: tableIdentifier)
        tableView.rowHeight = 80
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(didTapAdd))
    }
    
    /**
     * Handling event for Add button (add a new weight)
     */
    @objc private func didTapAdd()
    {
        let currentDate = Date()
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let dateString = df.string(from: currentDate)
        let alert = UIAlertController(title: "New Weight", message: "Enter New Weight", preferredStyle: .alert)
        alert.addTextField{field in
            field.placeholder = "Enter weight"
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Done", style: .default, handler: {[weak self](_) in
            if let field = alert.textFields?.first {
                if let weight = field.text, !weight.isEmpty {
                    // enter new to do list item
                    let bmi = Double(weight)! / (Double(self!.heightInAddView)! * Double(self!.heightInAddView)!)
                    let category = self?.getCategory(bmi: bmi)
                    self!.ref.child(dateString).setValue([
                        "name": self?.nameInAddView,
                        "age": self?.ageInAddView,
                        "height": self?.heightInAddView,
                        "weight": weight,
                        "bmi": bmi,
                        "category": category,
                        "mode": "Metric",
                        "date": dateString
                    ])
                    DispatchQueue.main.async {
                        let newEntry = [dateString]
                        UserDefaults.standard.setValue(newEntry, forKey: "")
                        self?.bmiList.append(BMI(name: self!.nameInAddView, age: Int(self!.ageInAddView)!, height: Double(self!.heightInAddView)!, weight: Double(weight)!, bmi: bmi, category: category!, mode: "Metric", date: dateString))
                        self?.tableView.reloadData()
                    }
                }
            }
        }))
        present(alert, animated: true)
    }
    
    /**
     * Get category from BMI
     */
    func getCategory(bmi: Double) -> String
    {
        var category = ""
        switch bmi {
        case let x where x < 16:
            category = "Severe Thinness"
        case 16...17:
            category = "Moderate Thinness"
        case 17...18.5:
            category = "Mild Thinness"
        case 18.5...25:
            category = "Normal"
        case 25...30:
            category = "Overweight"
        case 30...35:
            category = "Obese Class I"
        case 35...40:
            category = "Obese Class II"
        default:
            category = "Obese Class III"
        }
        
        return category
    }
    
    /**
     * Load all data of BMI
     */
    func loadData()
    {
        var flag = true
        ref.observe(.value) {
            snapshot in
            var bmiArr: [BMI] = []
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
                    let bmi = dataChange["bmi"] as? Double,
                    let mode = dataChange["mode"] as? String?,
                    let date = dataChange["date"] as? String?,
                    let category = dataChange["category"] as? String {

                    bmiArr.append(BMI(name: name!, age: Int(age!)!, height: Double(height!)!, weight: Double(weight!)!, bmi: bmi, category: category, mode: mode!, date: date!))
                    if(self.nameInAddView == "" && self.ageInAddView == "" && self.heightInAddView == "") {
                        self.nameInAddView = name!
                        self.ageInAddView = age!
                        self.heightInAddView = height!
                    }
                }
            }
            if(flag) {
                self.bmiList.append(contentsOf: bmiArr)
                self.tableView.reloadData()
                flag = false
            }
        }
        
    }
}

extension BMITrackingViewController: UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bmiList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Step 1 - Instantiate an object of type UITableViewCell
        let cell = tableView.dequeueReusableCell(withIdentifier: tableIdentifier, for: indexPath) as! BMITrackingTableViewCell
        let rowData = bmiList[indexPath.row]
        //cell.name = rowData["Name"]!
        if(rowData.mode == "Metric") {
            cell.weight = "Weight: " + String(format: "%.1f", rowData.weight) + " kg"
        } else {
            cell.weight = "Weight: " + String(format: "%.1f", rowData.weight) + " lbs"
        }
        cell.bmi = "BMI: " + String(format: "%.1f", rowData.bmi)
        cell.date = rowData.date

        // Add Edit button target (add target only once when the cell is created)
        cell.editButton.addTarget(self, action: #selector(pressButton), for: .touchUpInside)
        cell.editButton.tag = indexPath.row
        
        return cell
    }
    
    /**
     * Selector for pressing button Edit
     */
    @objc func pressButton(_ sender: UIButton) {
        let alert = UIAlertController(title: "Update Weight", message: "Update Weight", preferredStyle: .alert)
        alert.addTextField{field in
            field.placeholder = "Enter weight"
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Done", style: .default, handler: {[weak self](_) in
            if let field = alert.textFields?.first {
                if let weight = field.text, !weight.isEmpty {
                    // enter new weight
                    let ref = self!.ref.child(self!.bmiList[sender.tag].date)
                    let bmi = Double(weight)! / (Double(self!.heightInAddView)! * Double(self!.heightInAddView)!)
                    let category = self?.getCategory(bmi: bmi)
                    ref.updateChildValues([
                        "weight": weight,
                        "bmi": bmi,
                        "category": category
                    ])

                    DispatchQueue.main.async {
                        self?.bmiList[sender.tag].bmi = bmi
                        self?.bmiList[sender.tag].weight = Double(weight)!
                        self?.tableView.reloadData()
                    }
                }
            }
        }))
        present(alert, animated: true)
    }
    
}

extension BMITrackingViewController: UITableViewDelegate
{
    /**
     * Swipe right to left
     */
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let deleteAction = UIContextualAction(style: .normal, title: "Delete") {
            (contextualAction, view, actionPerformed: (Bool) -> ()) in
            let rowData = self.bmiList[indexPath.row]
            self.bmiList.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
            self.remove(child: rowData.date)
            // if the user Deletes all the entries then the app reroutes the user to the
            // Personal Information Screen
            if(self.bmiList.count == 0) {
                if let vc = self.storyboard!.instantiateViewController(identifier: "ViewController") as? ViewController {
                    
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
        }
        deleteAction.backgroundColor = .red
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        
        return configuration
    }
    
    /**
     * Hanling for 'Delete' long swipe button from right to left
     */
    func remove(child: String) {
        let ref = self.ref.child(child)
        ref.removeValue { error, _ in
            print(error)
        }
    }
    
}


