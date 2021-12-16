/**
 * Final Test
 * File Name:    ViewController.swift
 * Author:         Quoc Phong Ngo
 * Student ID:   301148406
 * Version:        1.0
 * Date Modified:   December 16th, 2021
 */

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var tvHeight: UITextField!
    var placeholderHeight : UILabel!
    
    @IBOutlet weak var switchMode: UISwitch!
    @IBOutlet weak var tvWeight: UITextField!
    var placeholderWeight : UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Placeholder height.
        placeholderHeight = UILabel()
        placeholderHeight.text = "m"
        placeholderHeight.font = UIFont.italicSystemFont(ofSize: CGFloat((15.0)))
        placeholderHeight.sizeToFit()
        tvHeight.addSubview(placeholderHeight)
        // Placeholder weight
        placeholderWeight = UILabel()
        placeholderWeight.text = "kg"
        placeholderWeight.font = UIFont.italicSystemFont(ofSize: CGFloat((15.0)))
        placeholderWeight.sizeToFit()
        tvWeight.addSubview(placeholderWeight)
    }


}

