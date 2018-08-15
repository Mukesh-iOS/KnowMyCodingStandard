//
//  MYTListViewController.swift
//  MYTPoC
//
//  Created by Mukesh on 27/05/18.
//  Copyright © 2018 com.murugananda. All rights reserved.
//

import UIKit

class MYTListViewController: UIViewController, ListDetailNotification {
    
    var listScreenVM: MYTListScreenViewModel?
    
    @IBOutlet var listTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewSetup()
    }
    
    // MARK: Initial Setup
    
    func viewSetup()
    {
        listScreenVM = MYTListScreenViewModel()
        listScreenVM?.delegate = self
        
        listTableView.dataSource = listScreenVM
        listTableView.delegate = listScreenVM
        
        listScreenVM?.getScheduleDetailsFromServer()
        
        let backBtn = self.addNavigationButton(withImage: UIImage.init(named: "BackNavigation")!, isBackButton: true)
        backBtn.addTarget(self, action: #selector(popToBackScreen), for: .touchUpInside)

        let forwardBtn = self.addNavigationButton(withTitle: "Next", isBackButton: false)
        forwardBtn.addTarget(self, action: #selector(pushToMapScreen), for: .touchUpInside)
        
        self.navigationItem.title = "Lists"
    }

    // MARK: Delegate Methods
    
    func updateData() {
        
        listScreenVM?.sortData(listScreenVM?.model)
        listTableView.reloadData()
    }
    
    // MARK: Helper Methods
    
    @objc func popToBackScreen()
    {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    @objc func pushToMapScreen()
    {
        self.performSegue(withIdentifier: "MapViewSegue", sender: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
