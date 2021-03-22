//
//  ViewController.swift
//  todoList
//
//  Created by Tonywilson Jesuraj on 19/03/21.
//  Copyright © 2021 Tonywilson Jesuraj. All rights reserved.
//

import UIKit
import CoreData
class ViewController: UIViewController {
    var viewModel = ViewControllerVM()
    @IBOutlet weak var todoListTableView : UITableView? {
        didSet {
            todoListTableView?.delegate          = self
            todoListTableView?.dataSource        = self
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.fectData()
    }
    @IBAction func addTodoListAction(_ sender: Any) {
        //1. Create the alert controller.
        let alert = UIAlertController(title: "Add todo list", message: nil, preferredStyle: .alert)

        //2. Add the text field. You can configure it however you need.
        alert.addTextField { (textField) in
            textField.text = ""
        }

        // 3. Grab the value from the text field, and print it when the user clicks OK.
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
            let textField = alert?.textFields![0] // Force unwrapping because we know it exists.
            self.viewModel.saveData(todoData: textField?.text ?? "")
            self.viewModel.fectData()
            self.todoListTableView?.reloadData()
        }))

        // 4. Present the alert.
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func allClearButtonAction(_ sender: Any) {
        viewModel.clearAll()
        viewModel.fectData()
        todoListTableView?.reloadData()
    }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.todoListArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as! TableViewCell
        cell.todoListLabel?.text = viewModel.todoListArray[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return UITableViewCell.EditingStyle.delete
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.setEditing(true, animated: true)
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        viewModel.deleteData(todoList: viewModel.todoListArray[indexPath.row])
        todoListTableView?.reloadData()
    }
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let value = viewModel.todoListArray.remove(at: sourceIndexPath.row)
        viewModel.todoListArray.insert(value, at: destinationIndexPath.row)
        tableView.setEditing(false, animated: true)
    }
}
