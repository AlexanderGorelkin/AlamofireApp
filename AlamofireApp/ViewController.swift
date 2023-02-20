//
//  ViewController.swift
//  AlamofireApp
//
//  Created by Александр Горелкин on 20.02.2023.
//

import UIKit
import Alamofire

class ViewController: UIViewController {
    
    
    
    @IBOutlet weak var tableView: UITableView!
    
    var array: [String] = []
    
    let url = "https://api.apilayer.com/fixer/latest"
    let key = "8umKjg7XvTw5YP8jMgfW3Oxrpbhsvbym"
    let base = "EUR"
//    let symbols = "USD,RUB"
   
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        let parameters = ["apikey": key, "base": base]
        getPrice(url, parameters)
        title = base
        
    }
    
    
    private func getPrice(_ url: String, _ params: [String: String]) {
        AF.request(url,
                   method: .get,
                   parameters: params)
        .validate()
        .downloadProgress { progress in
            // Called on main dispatch queue by default
            print("download progress: \(progress.fractionCompleted)")
        }
        .responseDecodable(of: Model.self) { response in
            switch response.result {
            case .success(let data):
                self.updateTableView(data)
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }

    }
    
    private func updateTableView(_ model: Model) {
        for (name, price) in model.rates {
            self.array.append("\(base) to \(name) - \(price)")
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    
    }
    
    
}
extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return array.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        var content = cell.defaultContentConfiguration()
        content.text = array[indexPath.row]
        cell.contentConfiguration = content
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
}

struct Model: Codable {
    let base: String
    let date: String
    let rates: [String: Float]
}

enum Currency: String {
    case USD = "USD"
    case RUB = "RUB"
    
}
