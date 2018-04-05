//
//  NotesTableViewController.swift
//  myCloud
//
//  Created by chenBighead on 2018/4/4.
//  Copyright © 2018年 joybien. All rights reserved.
//

import UIKit
import CloudKit

class NotesTableViewController: UITableViewController {
    //let database = CKContainer.default().privateCloudDatabase
    var notes = [CKRecord]()
    @IBAction func sendNote(_ sender: Any) {
        let alert = UIAlertController(title: "Type Something", message: "Save the data for note", preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.placeholder = "Type Note Here"
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let post  = UIAlertAction(title: "Post", style: .default, handler: { (_) in
            guard let text = alert.textFields?.first?.text else { return }
            
            self.saveToCloud(note: text)
            
            print("alert:\(text)")
        })
        alert.addAction(cancel)
        alert.addAction(post)
        present(alert, animated: true , completion: nil)
    }
    func saveToCloud(note: String){
        let newSweet = CKRecord(recordType: "Notes")
        newSweet["content"] = note as CKRecordValue
        let publicData = CKContainer.default().publicCloudDatabase
         publicData.save(newSweet) { (record,_) in
            guard record != nil else { return }
            print("Save record")
        }
        
    }
    @objc func queryDatabase() {
        notes = [CKRecord]()
        let publicData = CKContainer.default().publicCloudDatabase
        let query = CKQuery(recordType: "Notes", predicate: NSPredicate(value: true))
        publicData.perform(query, inZoneWith: nil) { (records, _) in
            guard let records = records else { return }
             DispatchQueue.main.async {
              let sortRecords = records.sorted(by: { $0.creationDate! > $1.creationDate!} )
              self.notes = sortRecords
           
                self.tableView.refreshControl?.endRefreshing()
                self.tableView.reloadData()
            }
        }
        
    }
    @objc func xQueryDataBase() {
        queryDatabase()
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //table view refresh control
        let refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(xQueryDataBase), for: .valueChanged)
        self.tableView.refreshControl = refreshControl
        
        queryDatabase()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notes.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        if notes.count == 0 { return cell }
        cell.textLabel?.text = notes[indexPath.row].value(forKey: "content") as? String
        
        return cell
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
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
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
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
