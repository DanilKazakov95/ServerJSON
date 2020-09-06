import UIKit

class TasksViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, NoteTasksViewControllerDelegate {

    var gettingIDFromUserInfo = UserDefaults.standard.integer(forKey: "userId")
    var tasks = [Task]()
    var textField: String?
    var textView: String?
    @IBOutlet var tasksTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewWillAppear(_ animated: Bool) {
        getPostForTasks()
    }
    
    func getNewTask(info: Task) {
        
        let newTaskFromNote = info
        tasks.insert(newTaskFromNote, at: 0)
        DispatchQueue.main.async {
            self.tasksTableView.reloadData()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "getDataSegue" {
            let destinationVC = segue.destination as! NoteForTasksViewController
            destinationVC.delegate = self
        }
    }
    
    //MARK: - JSON Parse

    func getPostForTasks(){
        
        let postId = gettingIDFromUserInfo
        
        APIManager.sharedInstance.getPostForTasks(postId: postId, onSuccess: { data in
            DispatchQueue.main.async {
                
                do {
                    let products = try JSONDecoder()
                        .decode([FailableDecodable<Task>].self, from: data)
                        .compactMap { $0.base } // .flatMap in Swift 4.0
                    
                    print(products)
                    
                    let decoder = JSONDecoder()
                    let model = try decoder.decode(FailableCodableArray<Task>.self, from: data)
                        .elements
                    
                    self.tasks = model
                    
                    self.tasksTableView.reloadData()
                    
                } catch let parsingError {
                    print("Error", parsingError)
                }
                
                
            }
        }, onFailure: { error in
            let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
            self.show(alert, sender: nil)
        })
    }
    
    //MARK: - TableView Setup
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tasksTableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let tasksRow = tasks[indexPath.row]
        
        let tasksIdLabel = cell.viewWithTag(15) as! UILabel
        let tasksTitleLabel = cell.viewWithTag(16) as! UILabel
        let tasksBodyLabel = cell.viewWithTag(17) as! UILabel

        tasksIdLabel.text = "Id: \(tasksRow.id)"
        tasksTitleLabel.text = "Title: \(tasksRow.title)"
        tasksBodyLabel.text = "Body: \(tasksRow.body)"
        
        return cell
    }
}
