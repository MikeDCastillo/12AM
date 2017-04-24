//
//  ImageController.swift
//  12AM
//
//  Created by Michael Castillo on 4/21/17.
//  Copyright © 2017 Michael Castillo. All rights reserved.
//


import UIKit

class ImageController {
    
    static func image(forURL url: String, completion: @escaping (UIImage?) -> Void) {
        
        guard let url = URL(string: url) else {
            fatalError("Image URL optional is nil")
        }
        
        NetworkController.performRequest(for: url, httpMethod: .get, urlParameters: nil, body: nil) { (data, error) in
            guard let data = data,
                let image = UIImage(data: data) else {
                    completion(nil)
                    return
            }
            
            DispatchQueue.main.async {
                completion(image)
            }
        }
    }
}
