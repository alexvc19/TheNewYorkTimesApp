//
//  Extension.swift
//  TheNewYorkTimes
//
//  Created by Alejandro Velasco on 18/10/24.
//

import UIKit
extension UIImageView {
    func imageURL(urlString: String, placeHolder: UIImage){
        if self.image == nil {
            self.image = placeHolder
        }
        URLSession.shared.dataTask(with: URL(string: urlString)!) { data, response, error in
            if error != nil {
                return
            }
            DispatchQueue.main.async {
                guard let data = data else {
                    return
                }
                let image = UIImage(data: data)
                self.image = image
            }
        }.resume()
    }
}
