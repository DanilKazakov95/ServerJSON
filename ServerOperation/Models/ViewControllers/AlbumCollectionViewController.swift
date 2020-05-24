import UIKit

class AlbumCollectionViewController: UICollectionViewController {
    
    var gettingIDFromUserInfo = UserDefaults.standard.integer(forKey: "userId")
    var photos = [Photo]()


    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Album ID: \(gettingIDFromUserInfo)"
        getPhotosJSONInformation()
    }
    
    //MARK: - JSON Parse
    
    func getPhotosJSONInformation(){
        
        let postId = gettingIDFromUserInfo
        
        APIManager.sharedInstance.getPostForPhotos(postId: postId, onSuccess: { data in
            DispatchQueue.main.async {
                
                do {
                    
                    
                    let products = try JSONDecoder()
                        .decode([FailableDecodable<Photo>].self, from: data)
                        .compactMap { $0.base } // .flatMap in Swift 4.0
                    
                    print(products)
                    
                    let decoder = JSONDecoder()
                    let model = try decoder.decode(FailableCodableArray<Photo>.self, from: data)
                        .elements
                    
                    self.photos = model
                    self.collectionView.reloadData()
                    
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
    
    //MARK: - CollectionViewSetup
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let photosRow = photos[indexPath.row]
        let url = "\(photosRow.url)"
        

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CollectionViewCell
        
        cell.label.text = "\(photosRow.title)"
        cell.image.downloaded(from: url)
        
        return cell
    }
}

extension UIImageView {
    func downloaded(from url: URL, contentMode mode: UIView.ContentMode = .scaleAspectFit) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() {
                self.image = image
            }
            }.resume()
    }
    func downloaded(from link: String, contentMode mode: UIView.ContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else { return }
        downloaded(from: url, contentMode: mode)
    }
}
