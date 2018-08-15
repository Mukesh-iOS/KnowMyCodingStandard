//
//  MYTSwiftCategories.swift
//  MYTPoC
//
//  Created by Mukesh on 27/05/18.
//  Copyright © 2018 com.murugananda. All rights reserved.
//

import UIKit

typealias okMethod = () -> Void

extension FloatingPoint {
    var degreesToRadians: Self { return self * .pi / 180 }
    var radiansToDegrees: Self { return self * 180 / .pi }
}

extension NSDictionary
{
    func dictionaryWithData(_ receiveData : Data?) -> NSDictionary? {
        
        if receiveData == nil {
            return nil
        }
        
        do{
            
            let dictionary = try JSONSerialization.jsonObject(with: receiveData!, options: JSONSerialization.ReadingOptions.allowFragments)
            
            return dictionary as? NSDictionary
            
        }
        catch let error as NSError
        {
            print(error.localizedDescription)
            return nil
        }
        
    }
}

@objc extension UIViewController
{
    func addNavigationButton(withImage : UIImage, isBackButton : Bool) -> UIButton {
        
        self.navigationController?.isNavigationBarHidden = false
        
        self.navigationItem.setHidesBackButton(true, animated:false)
        self.navigationController?.navigationBar.backgroundColor = UIColor.black
        
        let button = UIButton(type: UIButtonType.custom)
        
        button.frame = CGRect(x: 0, y: 0, width: 25, height: 25)
        
        button.setImage(withImage, for: UIControlState.normal)
        
        if isBackButton {
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: button)
        }else
        {
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: button)
        }
    
        return button
    }
    
    func addNavigationButton(withTitle : String, isBackButton : Bool) -> UIButton {
        
        self.navigationController?.isNavigationBarHidden = false
        
        self.navigationItem.setHidesBackButton(true, animated:false)
        self.navigationController?.navigationBar.backgroundColor = UIColor.black
        
        let button = UIButton(type: UIButtonType.custom)
        
        button.frame = CGRect(x: 0, y: 0, width: 80, height: 25)
        
        button.setTitle(withTitle, for: .normal)
        
        if isBackButton {
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: button)
        }else
        {
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: button)
        }
        
        return button
    }
}
