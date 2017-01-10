//
//  AddEventViewController.swift
//  check-in
//
//  Created by Matt Garnett on 8/13/16.
//  Copyright © 2016 Matt Garnett. All rights reserved.
//

import UIKit

class AddEventViewController: UITableViewController, UITextFieldDelegate {
    
    /* -------------------------------------------------------- */
    
    let firstGroup = [ ("Title"), ("Location") ]
    let secondGroup = [ ("Starts"), ("Ends"), ("Picker") ]
    let titleField = UITextField()
    let locationField = UITextField()
    
    let datePicker = UIDatePicker()
    
    var startDateIndexPath = IndexPath()
    var endDateIndexPath = IndexPath()

    let TITLE_INDEX = 0
    let LOCATION_INDEX = 1
    
    let STARTS_INDEX = 0
    let ENDS_INDEX = 1
    
    // Changes depending on which text field is tapped
    var date_index: Int = -1
    
    /* -------------------------------------------------------- */
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.barTintColor = UIColor(red:0.23, green:0.48, blue:0.84, alpha:1.0)
        self.navigationController?.navigationBar.tintColor = .white
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return firstGroup.count
        }
        
        else {
            return secondGroup.count
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = UITableViewCell()
        
        // Setup cell in the first group
        if indexPath.section == 0 {
            
            
            if(indexPath.row == TITLE_INDEX) {
                // Set up the title cell
                setupTextFieldInsideCell(textField: titleField, placeholder: "Title", cell: cell)
            } else if indexPath.row == LOCATION_INDEX {
                // Set up the location cell
                setupTextFieldInsideCell(textField: locationField, placeholder: "Location", cell: cell)
            }
        } else {
            if secondGroup[indexPath.row] == "Picker" {
                datePicker.addTarget(self, action: #selector(AddEventViewController.datePickerValueChanged), for: .valueChanged)
                cell.addSubview(datePicker)
            } else if secondGroup[indexPath.row] == "Starts" {
                cell = UITableViewCell(style: .value1, reuseIdentifier: "cell")
                startDateIndexPath = indexPath
                cell.textLabel?.text = secondGroup[indexPath.row]
            } else if secondGroup[indexPath.row] == "Ends" {
                cell = UITableViewCell(style: .value1, reuseIdentifier: "cell")
                endDateIndexPath = indexPath
                cell.textLabel?.text = secondGroup[indexPath.row]
            }
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            date_index = STARTS_INDEX
        } else if indexPath.row == 1 {
            date_index = ENDS_INDEX
        }
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {

    }
    
    override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {

    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if (indexPath.section == 1 && indexPath.row == 2) {
            return 210
        }
        return 44
    }
    
    // MARK: - Button Actions
    
    @IBAction func submitAddNewEvent(_ sender: AnyObject) {
        addNewEvent(name: titleField.text!, startDate: datePicker.date as NSDate, endDate: datePicker.date as NSDate, location: locationField.text!)
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancelAddEvent(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // Make text field look pretty
    func setupTextFieldInsideCell(textField: UITextField, placeholder: String, cell: UITableViewCell) {
        textField.frame = cell.frame
        let padding = UIView(frame: CGRect(x: 0, y: 0, width: CGFloat(15), height: titleField.frame.size.height))
        textField.leftView = padding
        textField.leftViewMode = .always
        textField.font = UIFont.preferredFont(forTextStyle: UIFontTextStyle.body)
        textField.placeholder = placeholder
        cell.addSubview(textField)
    }
    
    
    // Update the label text when picker value changes
    func datePickerValueChanged() {
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateStyle = DateFormatter.Style.full
        dateFormatter.timeStyle = DateFormatter.Style.short
        
        if(date_index == STARTS_INDEX) {
            let strDate = dateFormatter.string(from: datePicker.date)
            tableView.cellForRow(at: startDateIndexPath)?.detailTextLabel?.text = strDate
        } else if(date_index == ENDS_INDEX) {
            let strDate = dateFormatter.string(from: datePicker.date)
            tableView.cellForRow(at: endDateIndexPath)?.detailTextLabel?.text = strDate
        }
    }
    
    // Save the event
    func addNewEvent(name: String, startDate: NSDate, endDate: NSDate, location: String) {

        let event = Event(name: name, startDate: startDate, endDate: endDate, location: location)
        event?.save(completionHandler:) { error in
            // Do something on save sucess
        }
    }

    

}
