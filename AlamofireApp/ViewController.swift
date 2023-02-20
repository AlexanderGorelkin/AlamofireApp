//
//  ViewController.swift
//  AlamofireApp
//
//  Created by Александр Горелкин on 20.02.2023.
//

import UIKit
import Alamofire

class ViewController: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var progressView: UIProgressView!
    
    let imageUrl: String = "https://i.stack.imgur.com/cdCSj.jpg"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        indicator.startAnimating()
        getImage(imageUrl)
        
    }
    
    func getImage(_ url: String) {
        AF.download(url)
            .validate()
            .downloadProgress { (progress) in
                self.label.text = progress.localizedDescription
                self.progressView.setProgress(Float(progress.fractionCompleted), animated: true)
            }
            .responseData { (response) in
                guard let data = response.value else { return }
                self.imageView.image = UIImage(data: data)
                self.indicator.stopAnimating()
                self.indicator.isHidden = true
                self.progressView.isHidden = true
                
            }
        
        
    }
    
    
}

