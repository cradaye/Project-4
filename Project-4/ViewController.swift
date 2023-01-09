//
//  ViewController.swift
//  Project-4
//
//  Created by BigAdmin on 08/01/23.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    

    @IBOutlet weak var tableView: UITableView!
    var moviesArray: [Movies] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "DC COMICS"
        // Do any additional setup after loading the view.
        callAPI { [weak self] moviesList in
            self?.moviesArray = moviesList
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
            
            
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return moviesArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell: MovieCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? MovieCell{
            let movie:Movies = moviesArray[indexPath.row]
            cell.titleLabel.text = movie.name
            if let likeCount = movie.likeCount {
                cell.likesLabel.text = "Likes: \(likeCount)"
            }
            
            
            cell.ImageView.layer.cornerRadius = 8.0
            cell.ImageView.layer.masksToBounds = true
            
            if let imageUrl = movie.image_url,
               let url = URL(string: imageUrl),
               let data = try? Data(contentsOf: url){
                cell.ImageView.image = UIImage(data: data)
            } else {
                cell.ImageView.image = UIImage(named: "placeholder")
            }
            
            
            return cell
        }
        return UITableViewCell()
    }
    
    func callAPI(completion: @escaping([Movies]) -> ()) {
        var request = URLRequest(url: URL(string: "https://demo2782755.mockable.io/superheroes")!)
        request.httpMethod = "GET"

        URLSession.shared.dataTask(with: request, completionHandler: { data, response, error -> Void in
            do {
                let jsonDecoder = JSONDecoder()
                //let responseModel = try jsonDecoder.decode(CustomDtoClass.self, from: data!)
                
                guard let data = data else {
                    return
                }
                
                let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String:Any]
                
                
                if let movieJson = json?["dc"] as? [[String: Any]]
                {
                    let movieData = try JSONSerialization.data(withJSONObject: movieJson, options: .prettyPrinted)
                    
                    let movieArray:[Movies] = try jsonDecoder.decode([Movies].self, from: movieData)
                    completion(movieArray)
                }
                
                
            } catch {
                print("JSON Serialization error")
            }
        }).resume()
    }


}

