//
//  MYTInitialViewController.swift
//  MYTPoC
//
//  Created by Mukesh on 27/05/18.
//  Copyright © 2018 com.murugananda. All rights reserved.
//

import UIKit

class MYTInitialViewController: UIViewController
{
    override func viewDidLoad() {
        
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    @IBAction func showListScreenBtnTapped(_ sender: Any) {
        
        self.performSegue(withIdentifier: "listViewSegue", sender: nil)
    }
}
