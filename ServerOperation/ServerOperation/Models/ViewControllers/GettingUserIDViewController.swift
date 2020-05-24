import UIKit

class GettingUserIDViewController: UIViewController {
    @IBOutlet var textField: UITextField!
    var userIdentifier: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textField.delegate = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let defaults = UserDefaults.standard
         defaults.removeObject(forKey: "userId")
         self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
         self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    @IBAction func goToNextView(_ sender: Any) {
        
        let gettingUserId = textField.text
        let gettingUserIdAsInteger = Int(gettingUserId!)
        if gettingUserIdAsInteger == nil{
            print("error")
        } else {
            if gettingUserIdAsInteger! <= 10 && gettingUserIdAsInteger! >= 0{
                
                userIdentifier = gettingUserIdAsInteger!
               
                UserDefaults.standard.set(userIdentifier, forKey: "userId")
                
            } else {
                print("wrong")
            }
        }
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        textField.resignFirstResponder()
        
    }
    
}

extension UIViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
