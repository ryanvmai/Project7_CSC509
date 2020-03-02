//
//  ActivityTableViewController.swift
//  Project7
//
//  Created by student on 2/29/20.
//  Copyright © 2020 CSC509. All rights reserved.
//
import Foundation
import UIKit

class ActivityTableViewController: UITableViewController {
    let defaults = UserDefaults.standard
    var activityList = [Activity]()
    var studentActivityList = [StudentActivity]()

    let abbotBlue: UIColor = UIColor(red: 102/255, green: 173/255, blue: 220/255, alpha: 1)

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.backgroundColor = abbotBlue

        let urlStringActivity = "https://summer-session-api.herokuapp.com/activities"
       // where is the studnet ID?
        let urlStringStudentActivity = "https://summer-session-api.herokuapp.com/student/1/activities"
        
        if let url = URL(string: urlStringActivity) {
            if let data = try? Data(contentsOf: url) {
                parseActivities(json: data)
            } else {
                print("error getting activty data")
            }
        }
        if let url2 = URL(string: urlStringStudentActivity) {
            if let data2 = try? Data(contentsOf: url2) {
                parseStudentActivities(json: data2)
               print("succeccfully getting student activity data")
                return
            } else {
                print("error getting student activity data")
            }
        }
        showError()
    }

    func parseActivities(json: Data) {
        let decoder = JSONDecoder()
        if let jsonActivities = try? decoder.decode(Activities.self, from: json) {
            activityList
                = jsonActivities.activities
            tableView.reloadData()
            print("successfully loaded  activity data")
        } else {
            print("error decoding activity json")
        }
        let encoder = JSONEncoder()
        if let activityData = try? encoder.encode(activityList){
            let defaults = UserDefaults.standard
            defaults.set(activityData, forKey: "ActivityList")
        }
    }
   
    func parseStudentActivities(json: Data) {
        let decoder = JSONDecoder()
        if let jsonStudentActivities = try? decoder.decode(StudentActivities.self, from: json) {
            studentActivityList
                = jsonStudentActivities.activities
            tableView.reloadData()
            print("successfully loaded student activity data")

        } else {
            print("error decoding student activity json")
        }
        let encoder = JSONEncoder()
        if let studentActivityData = try? encoder.encode(studentActivityList){
            let defaults = UserDefaults.standard
            defaults.set(studentActivityData, forKey: "StudentActivityList")
        }
    }
    
     func showError() {
         let ac = UIAlertController(title: "Loading error", message: "There was a problem loading the feed; please check your connection and try again.", preferredStyle: .alert)
         ac.addAction(UIAlertAction(title: "OK", style: .default))
         present(ac, animated: true)
     }
    
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return activityList.count
        } else {
            return studentActivityList.count
        }
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ActivityCell", for: indexPath) as! ActivityTableViewCell
        if indexPath.section == 0 {
            let activityItem = activityList[indexPath.row]
            cell.nameLabel.text = activityItem.name
            cell.locationLabel.text = activityItem.location
            cell.descriptionLabel.text = activityItem.description
            cell.timeLabel.text = "\(activityItem.time_start) - \(activityItem.time_end)"
            return cell
        } else if indexPath.section == 1{
            let studentActivityItem = studentActivityList[indexPath.row]
            cell.nameLabel.text = studentActivityItem.name
            cell.locationLabel.text = studentActivityItem.location
            cell.descriptionLabel.text = studentActivityItem.description
            cell.timeLabel.text = "\(studentActivityItem.time_start) - \(studentActivityItem.time_end)"
            return cell
        } else{
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return  "All Campus Activities"
        } else{
            return "My Activities"
        }
        
    }
    
   override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       print("\(indexPath.row) tapped")
       
       let storyboard = UIStoryboard(name: "ActivitiesStoryboard", bundle: nil)
       let selectedVC = storyboard.instantiateViewController(identifier: "SelectedActivityVC") as! DetailedActivityViewController
      
    let slcActivity: [String] = ["\(activityList[indexPath.row].name)", "\(activityList[indexPath.row].time_start)", "\(activityList[indexPath.row].time_end)", "\(activityList[indexPath.row].description)", "\(activityList[indexPath.row].location)"]
       
       defaults.set(slcActivity, forKey: "slcActivity" )
       navigationController?.pushViewController(selectedVC, animated: true)
   }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
