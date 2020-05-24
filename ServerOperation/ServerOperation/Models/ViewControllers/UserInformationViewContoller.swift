import UIKit
import MapKit
import CoreLocation


class UserInformationViewContoller: UIViewController, UITableViewDelegate, UITableViewDataSource{
   
    @IBOutlet var myTableView: UITableView!
    @IBOutlet var mapKit: MKMapView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var userNameLabel: UILabel!
    @IBOutlet var emailLabel: UILabel!
    @IBOutlet var adressLabel: UILabel!
    @IBOutlet var PhoneNumberLabel: UILabel!
    @IBOutlet var websiteLabel: UILabel!
    @IBOutlet var topView: UIView!
    @IBOutlet var bottomView: UIView!
    @IBOutlet var topDownloadingLabel: UILabel!
    @IBOutlet var bottomDownloadingLabel: UILabel!
    @IBOutlet var topIndicator: UIActivityIndicatorView!
    @IBOutlet var bottomIndicator: UIActivityIndicatorView!
    
    var user: User?
    var album = [Album]()
    var gettingIDFromTextField = UserDefaults.standard.integer(forKey: "userId")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "User ID: \(gettingIDFromTextField)"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getUserJSONInformation()
        getAlbumsJSONInformation()
        
        topView.alpha = 0
        bottomView.alpha = 0
        topIndicator.startAnimating()
        bottomIndicator.startAnimating()
    }
    
    //MARK: - JSON Parse
    
    func getUserJSONInformation(){
        
        let postId = gettingIDFromTextField
        
        APIManager.sharedInstance.getPostWithIdForUsers(postId: postId, onSuccess: { data in
            DispatchQueue.main.async {
            
        
                
                do {
                    let decoder = JSONDecoder()
                    let model = try decoder.decode(User.self, from: data)
                
                    self.user = model
                    
                    self.refreshUI()
                   
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
    
    func getAlbumsJSONInformation(){
        
        let postId = gettingIDFromTextField
        
        APIManager.sharedInstance.getPostWithIdForAlbums(postId: postId, onSuccess: { data in
            DispatchQueue.main.async {
                
                do {
                    
                    
                    let products = try JSONDecoder()
                        .decode([FailableDecodable<Album>].self, from: data)
                        .compactMap { $0.base }
                    
                    let decoder = JSONDecoder()
                    let model = try decoder.decode(FailableCodableArray<Album>.self, from: data)
                    .elements
                    
                    self.album = model
                    self.myTableView.reloadData()
                    
                    
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
    
    //MARK: - UI Setup

    func refreshUI(){
        
        mapControl()
        
        nameLabel.text = "Name: \(user!.name as String)"
        userNameLabel.text = "Username: \(user!.username as String)"
        emailLabel.text = "Email: \(user!.email as String)"
        adressLabel.text = "Address: \(user!.address.street as String)"
        PhoneNumberLabel.text = "Phone: \(user!.phone as String)"
        websiteLabel.text = "Website: \(user!.website as String)"
        if user != nil{
            topView.alpha = 1
            bottomView.alpha = 1
            topDownloadingLabel.alpha = 0
            bottomDownloadingLabel.alpha = 0
            bottomIndicator.alpha = 0
            bottomIndicator.stopAnimating()
            topIndicator.alpha = 0
            topIndicator.stopAnimating()
        } else {
            topView.alpha = 0
            bottomView.alpha = 0
            topDownloadingLabel.alpha = 1
            bottomDownloadingLabel.alpha = 1
            topIndicator.alpha = 1
            bottomIndicator.alpha = 1
        }
    }
    
    func mapControl(){
        var longitudeString = user?.address.geo.lng
        var latitudeSting = user?.address.geo.lat
        var longitudeDouble = Double(longitudeString!)
        var latitudeDouble = Double(latitudeSting!)
        
        
        var location = CLLocationCoordinate2DMake(latitudeDouble!, longitudeDouble!)
        var annotation = MKPointAnnotation()
        annotation.coordinate = location
        annotation.title = "User"
        mapKit.addAnnotation(annotation)
        let span = MKCoordinateSpan(latitudeDelta: 1, longitudeDelta: 1)
        let region = MKCoordinateRegion(center: location, span: span)
        mapKit.setRegion(region, animated: true)
        
    }
    
    //MARK: - TableView Setup
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return album.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = myTableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let albumRow = album[indexPath.row]
        
        let albumIdLabel = cell.viewWithTag(10) as! UILabel
        let albumTitleLabel = cell.viewWithTag(11) as! UILabel
        
        albumIdLabel.text = "ID Альбома: \(albumRow.id)"
        albumTitleLabel.text = "Title: \(albumRow.title)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let albumRow = album[indexPath.row]
        
        let thirdview = self.storyboard?.instantiateViewController(withIdentifier: "AlbumCollectionViewController") as! AlbumCollectionViewController
        print(albumRow.id)
        thirdview.gettingIDFromUserInfo = albumRow.id

        
        self.navigationController?.pushViewController(thirdview, animated: true)
    }
    @IBAction func openTasks(_ sender: Any) {
        
        let tasksview = self.storyboard?.instantiateViewController(withIdentifier: "TasksViewController") as! TasksViewController
        tasksview.gettingIDFromUserInfo = gettingIDFromTextField
        self.navigationController?.pushViewController(tasksview, animated: true)
    }
}



