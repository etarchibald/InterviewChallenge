//
//  ViewController.swift
//  RandomizingTableViewCodeChallenge
//
//  Created by Ethan Archibald on 2/28/24.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var numberOfRandom: UITextField!
    @IBOutlet weak var randomizeButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var addUserTextField: UITextField!
    
    var userController = UserController.shared
    
    var sourceUsers = [User]()
    var displayUsers = [User]()
    var randomUsers = [User]()
    
    var areUsersRandom = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        numberOfRandom.text = "1"
        sourceUsers = userController.loadUsers()
        displayUsers = sourceUsers
    }
    
    @IBAction func addButtonTapped(_ sender: UIButton) {
        guard let newUserName = addUserTextField.text, !newUserName.isEmpty else { return }
        sourceUsers.append(User(name: newUserName))
        displayUsers = sourceUsers
        tableView.reloadData()
        userController.saveUsers(sourceUsers)
        addUserTextField.text = ""
    }
    
    @IBAction func randomizeButtonTapped(_ sender: UIButton) {
        if areUsersRandom {
            randomizeButton.setTitle("Get Random", for: .normal)
            areUsersRandom = false
            randomUsers.removeAll()
            displayUsers = sourceUsers
            tableView.reloadData()
        } else {
            randomizeButton.setTitle("Cancel", for: .normal)
            areUsersRandom = true
            var array = displayUsers
            if let numberOfRandom = Int(numberOfRandom.text ?? "1") {
                for _ in 0..<numberOfRandom {
                    array.shuffle()
                    randomUsers.append(array.first!)
                    array.removeFirst()
                }
            }
            displayUsers = randomUsers
            tableView.reloadData()
        }
    }
    
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        displayUsers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "user", for: indexPath) as! UserTableViewCell
        
        let user = displayUsers[indexPath.row]
        
        cell.titleLabel.text = user.name
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            displayUsers.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.reloadData()
        }
    }
    
}
