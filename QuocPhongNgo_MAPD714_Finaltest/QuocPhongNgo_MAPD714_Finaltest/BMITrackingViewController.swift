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
    
    private var bmiList: [BMI] = []
    let tableIdentifier = "bmiTable"
    
    override func viewDidLoad() {
        loadData()
        super.viewDidLoad()
        tableView.register(BMITrackingTableViewCell.self, forCellReuseIdentifier: tableIdentifier)
        tableView.rowHeight = 80
    }
    
    /**
     * Load all data of BMI
     */
    func loadData()
    {
        let ref = Database.database().reference()
        
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
                }
            }
            self.bmiList.append(contentsOf: bmiArr)
            self.tableView.reloadData()
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
        cell.bmi = String(format: "%.1f", rowData.bmi)
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
//        if let vc = storyboard?.instantiateViewController(identifier: "DetailViewController") as? DetailViewController {
//            vc.taskNameText = tasks[sender.tag].name
//            vc.notesText = tasks[sender.tag].notes
//            vc.isCompletedText = tasks[sender.tag].isCompleted
//            vc.hasDueDateText = tasks[sender.tag].hasDueDate
//
//            if(!tasks[sender.tag].dueDate.isEmpty) {
//                let dateFormatter = DateFormatter()
//                dateFormatter.dateFormat = "YY/MM/dd"
//                let dueDate = dateFormatter.date(from:tasks[sender.tag].dueDate)
//                vc.dueDateText = dueDate
//            }
//
//            navigationController?.pushViewController(vc, animated: true)
//        }
    }
    
}


