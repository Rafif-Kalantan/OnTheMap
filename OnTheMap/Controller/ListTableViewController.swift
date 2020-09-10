//
//  ListTableViewController.swift
//  OnTheMap
//
//  Created by Rafif Kalantan on 04/09/2020.
//  Copyright © 2020 Rafif Kalantan. All rights reserved.
//

import UIKit

class ListTableViewController: UITableViewController {
    
    // MARK: Declarations
    @IBOutlet weak var studentTableView: UITableView!
    
    var students = [StudentInformation]()
    var myIndicator: UIActivityIndicatorView!
    

    override func viewDidLoad() {
        myIndicator = UIActivityIndicatorView (style: UIActivityIndicatorView.Style.gray)
        self.view.addSubview(myIndicator)
        myIndicator.bringSubviewToFront(self.view)
        myIndicator.center = self.view.center
        showActivityIndicator()
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        getStudentsList()
    }
    
    // MARK: Logging Out
    @IBAction func logout(_ sender: UIBarButtonItem) {
        showActivityIndicator()
        UdacityClient.logout {
            DispatchQueue.main.async {
                self.dismiss(animated: true, completion: nil)
                self.hideActivityIndicator()
            }
        }
    }
    
    // MARK: Refreshing The List
    @IBAction func refreshList(_ sender: UIBarButtonItem) {
        getStudentsList()
    }
    
    // MARK: Getting the Students List
    func getStudentsList() {
        showActivityIndicator()
        UdacityClient.getStudentLocations() {students, error in
            self.students = students ?? []
            DispatchQueue.main.async {
                if error != nil {
                    let alert = UIAlertController(title: "Fail", message: "sorry, we could not fetch data", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    print("error")
                    return
                }else{
                self.tableView.reloadData()
                self.hideActivityIndicator()
                }
                
            }
        }
    }

    // MARK: Table View
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return students.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StudentTableViewCell", for: indexPath)
        let student = students[indexPath.row]
        cell.textLabel?.text = "\(student.firstName)" + " " + "\(student.lastName)"
        cell.detailTextLabel?.text = "\(student.mediaURL ?? "")"
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let student = students[indexPath.row]
        openLink(student.mediaURL ?? "")
    }
    
    // MARK: Toggle Activity Indicator
    func showActivityIndicator() {
        myIndicator.isHidden = false
        myIndicator.startAnimating()
    }
    
    func hideActivityIndicator() {
        myIndicator.stopAnimating()
        myIndicator.isHidden = true
    }
    
}
