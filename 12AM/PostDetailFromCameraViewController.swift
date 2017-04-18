//
//  PostDetailFromCameraViewController.swift
//  12AM
//
//  Created by Alex Whitlock on 4/10/17.
//  Copyright © 2017 Michael Castillo. All rights reserved.
//

import UIKit

class PostDetailFromCameraViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        
        
        
        let _ = self.navigationController?.popToRootViewController(animated: true)
        
    }
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        
        let _ = self.navigationController?.popViewController(animated: true)

    }
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var captionTextField: UITextField!
    
    
    @IBAction func unwind(segue ofType: UIStoryboardSegue) {
    }
    
    
    func saveImage() {
        
        
        
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
