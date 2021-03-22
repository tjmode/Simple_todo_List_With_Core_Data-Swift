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
    var todoListArray = [String]()
    @IBOutlet weak var todoListTableView : UITableView? {
        didSet {
            todoListTableView?.delegate          = self
            todoListTableView?.dataSource        = self
        }
    }
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var context: NSManagedObjectContext?

    override func viewDidLoad() {
        super.viewDidLoad()
        context = appDelegate.persistentContainer.viewContext
        fectData()
    }

    func saveData(todoData: String) {
        if todoData != "", todoData != " "{
            if todoListArray.contains(todoData) {
                let alert = UIAlertController(title: "Can't Add", message: "Because same todo in list", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Okay", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            } else {
                let person = NSEntityDescription.insertNewObject(forEntityName: "Todolist", into: context!)
                person.setValue(todoData, forKey: "todolist")
                do {
                    try context?.save()
                    fectData()
                    todoListTableView?.reloadData()
                } catch {
                    print("No error")
                }
            }
        }
    }

    func fectData() {
        todoListArray = []
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Todolist")
        request.returnsObjectsAsFaults = false
        do {
            let results = try context?.fetch(request)
            
            let count = results?.count
            
            if 0 < count ?? 0 {
                for todoList in results! as! [NSManagedObject] {
                    if let todoList = todoList.value(forKey: "todolist") as? String {
                        todoListArray.append(todoList)
                    }
                }
            }
        } catch {
            print("Error")
        }
    }

    func clearAll() {
        let managedContext = appDelegate.persistentContainer.viewContext
        let DelAllReqVar = NSBatchDeleteRequest(fetchRequest: NSFetchRequest<NSFetchRequestResult>(entityName: "Todolist"))
        do {
            try managedContext.execute(DelAllReqVar)
        }
        catch {
            print(error)
        }
    }

    func deleteData(todoList: String) {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Todolist")
        let pred = NSPredicate(format: "todolist=%@", todoList)
        request.predicate = pred
        do {
            self.fectData()
            let test = try context?.fetch(request)

            if test?.count == 1 {
                let objectDelete = test![0] as! NSManagedObject
                context?.delete(objectDelete)
                do {
                    try context?.save()
                    print("DELETED")
                    fectData()
                    todoListTableView?.reloadData()
                } catch {
                    print("ERRR")
                }
            }
        } catch {
            print("ERROR")
        }
    }
    
    @IBAction func addTodoListAction(_ sender: Any) {
        //1. Create the alert controller.
        let alert = UIAlertController(title: "Some Title", message: "Enter a text", preferredStyle: .alert)

        //2. Add the text field. You can configure it however you need.
        alert.addTextField { (textField) in
            textField.text = ""
        }

        // 3. Grab the value from the text field, and print it when the user clicks OK.
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
            let textField = alert?.textFields![0] // Force unwrapping because we know it exists.
            self.saveData(todoData: textField?.text ?? "")
        }))

        // 4. Present the alert.
        self.present(alert, animated: true, completion: nil)
        fectData()
        todoListTableView?.reloadData()
    }
    
    @IBAction func allClearButtonAction(_ sender: Any) {
        clearAll()
        fectData()
        todoListTableView?.reloadData()
    }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoListArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as! TableViewCell
        cell.todoListLabel?.text = todoListArray[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return UITableViewCell.EditingStyle.delete
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.setEditing(true, animated: true)
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        deleteData(todoList: todoListArray[indexPath.row])
    }
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let value = todoListArray.remove(at: sourceIndexPath.row)
        todoListArray.insert(value, at: destinationIndexPath.row)
        tableView.setEditing(false, animated: true)
    }
}
