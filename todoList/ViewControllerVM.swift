//
//  ViewControllerVM.swift
//  todoList
//
//  Created by Tonywilson Jesuraj on 22/03/21.
//  Copyright © 2021 Tonywilson Jesuraj. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class ViewControllerVM {
    var todoListArray = [String]()
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var context: NSManagedObjectContext?
    func fectData() {
        context = appDelegate.persistentContainer.viewContext
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
        context = appDelegate.persistentContainer.viewContext
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
        context = appDelegate.persistentContainer.viewContext
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
                } catch {
                    print("ERRR")
                }
            }
        } catch {
            print("ERROR")
        }
    }
    func saveData(todoData: String) {
        if todoData != "", todoData != " "{
            if todoListArray.contains(todoData) {
//                let alert = UIAlertController(title: "Can't Add", message: "Because same todo in list", preferredStyle: UIAlertController.Style.alert)
//                alert.addAction(UIAlertAction(title: "Okay", style: UIAlertAction.Style.default, handler: nil))
//                self.present(alert, animated: true, completion: nil)
            } else {
                let person = NSEntityDescription.insertNewObject(forEntityName: "Todolist", into: context!)
                person.setValue(todoData, forKey: "todolist")
                do {
                    try context?.save()
                    fectData()
                } catch {
                    print("No error")
                }
            }
        }
    }
}
