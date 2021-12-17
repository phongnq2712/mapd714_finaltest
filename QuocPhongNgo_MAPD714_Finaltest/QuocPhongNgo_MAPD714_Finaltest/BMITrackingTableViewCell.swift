/**
 * Final Test
 * File Name:    BMITrackingTableViewCell.swift
 * Author:         Quoc Phong Ngo
 * Student ID:   301148406
 * Version:        1.0
 * Date Modified:   December 17th, 2021
 */

import UIKit

class BMITrackingTableViewCell: UITableViewCell {
    weak var editButton: UIButton!
    var weight:String = "" {
        didSet {
            if(weight != oldValue) {
                weightLabel.text = weight
            }
        }
    }
    var bmi:String = "" {
        didSet {
            if(bmi != oldValue) {
                bmiLabel.text = bmi
            }
        }
    }
    var date:String = "" {
        didSet {
            if(date != oldValue)
            {
                dateLabel.text = date
            }
        }
    }
    var weightLabel: UILabel!
    var bmiLabel: UILabel!
    var dateLabel: UILabel!
    var switchUI: UISwitch!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
                
        let weightValueRect = CGRect(x:80, y:0, width: 200, height: 40)
        weightLabel = UILabel(frame: weightValueRect)
        contentView.addSubview(weightLabel)
        
        let bmiValueRect = CGRect(x:80, y:16, width: 200, height: 40)
        bmiLabel = UILabel(frame: bmiValueRect)
        contentView.addSubview(bmiLabel)
        
        let dateValueRect = CGRect(x:80, y:32, width: 200, height: 40)
        dateLabel = UILabel(frame: dateValueRect)
        contentView.addSubview(dateLabel)
        
        //Initialize Edit button
        let editButton = UIButton(frame: CGRect(x: 8, y: 4.5, width: 48, height: 28))
        self.editButton = editButton
        self.frame = frame
        
        //Setup Edit button
        addSubview(editButton)
        let editImage = UIImage(systemName: "square.and.pencil")
        editButton.setImage(editImage, for: UIControl.State.normal)
        editButton.setTitleColor(.blue, for: .normal)
        editButton.center.y = self.center.y
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
