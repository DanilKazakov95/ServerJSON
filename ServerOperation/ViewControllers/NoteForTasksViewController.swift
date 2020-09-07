//
//  NoteForTasksViewController.swift
//  ServerOperation
//
//  Created by Данил Казаков on 03/12/2018.
//  Copyright © 2018 Danivaroguchiy. All rights reserved.
//

import UIKit


protocol NoteTasksViewControllerDelegate {
    func getNewTask(info: Task)
}

class NoteForTasksViewController: UIViewController {
    
    var delegate: NoteTasksViewControllerDelegate?
    @IBOutlet var textView: UITextView!
    @IBOutlet var textField: UITextField!
    var gettingIDFromUserInfo: Int?
    let textFromTextView: String? = nil
    let textFromTextField: String? = nil
    let info = [Task]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textView.text = textFromTextView
        textField.text = textFromTextField
        
    }
    
    @IBAction func saveButton(_ sender: Any) {
        
        let tasksview = self.storyboard?.instantiateViewController(withIdentifier: "TasksViewController") as! TasksViewController
        
        tasksview.textField = textFromTextField
        tasksview.textView = textFromTextView
        
        postNoteInfo()
        
        navigationController?.popViewController(animated: true)
    }
    
    //MARK: - POST Information
    
    func postNoteInfo() {
        
        let parameters = ["title": "\(textField.text!)", "body": "\(textView.text!)"]
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/posts") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        guard let httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: []) else { return }
        request.httpBody = httpBody
        
        let session = URLSession.shared
        session.dataTask(with: request) {(data, response, error) in
            if let response = response {
                print(response)
            }
            
            if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    print(json)
                    
                    let newTask = try JSONDecoder()
                        .decode(Task.self, from: data)
                    
                    print(newTask)
                    let info = newTask
                    self.delegate?.getNewTask(info: info)
                } catch {
                    print(error)
                }
            }
        }.resume()
    }
}
