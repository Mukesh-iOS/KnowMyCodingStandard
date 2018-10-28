//
//  MYTListViewCell.swift
//  MYTPoC
//
//  Created by Mukesh on 27/05/18.
//  Copyright © 2018 com.murugananda. All rights reserved.
//

import UIKit

class MYTListViewCell : UITableViewCell {

    @IBOutlet var vehicle: UIImageView!
    @IBOutlet var vehicleID: UILabel!
    @IBOutlet var vehicleLatitude: UILabel!
    @IBOutlet var vehicleLongitude: UILabel!
    @IBOutlet var headingArrow: UIImageView!
    
    override func awakeFromNib() {
        vehicle.layer.cornerRadius = self.vehicle.frame.size.width / 2
        vehicle.clipsToBounds = true
    }
    
    func loadData(_ model : Lists){
        
        let imageName : String = model.fleetType == "TAXI" ? "PrivateCar" : "Pooling"
        vehicle.image = UIImage.init(named: imageName)
        vehicle.image = vehicle.image!.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        vehicle.tintColor = UIColor.darkGray
        
        headingArrow.transform = CGAffineTransform(rotationAngle: CGFloat(model.heading.degreesToRadians))
        headingArrow.image = headingArrow.image!.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        headingArrow.tintColor = UIColor.darkGray
        
        vehicleID.text = String(format:"Vehicle Id - %d", model.id)
        
        vehicleLatitude.text = "Latitude    : \(model.coordinate?.latitude ?? 0)"
        vehicleLongitude.text = "Longitude : \(model.coordinate?.longitude ?? 0)"
    }
}
