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
    }
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        // ? _ = navigationController?.popViewController(animated: true)
    }

    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var captionTextField: UITextField!
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
