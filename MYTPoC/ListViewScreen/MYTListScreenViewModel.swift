//
//  MYTListScreenViewModel.swift
//  MYTPoC
//
//  Created by Mukesh on 27/05/18.
//  Copyright © 2018 com.murugananda. All rights reserved.
//

import UIKit

protocol ListDetailNotification: class {
    
     func updateData()
}

class MYTListScreenViewModel: NSObject, UITableViewDataSource, UITableViewDelegate{
    
    weak var delegate: ListDetailNotification?
    var model: CodableContainer?
    
    enum TableSection: Int {
        case taxi = 0, pooling, total
    }
    
    let SectionHeaderHeight: CGFloat = 30
    
    var data = [TableSection: [lists]]()
    
    // MARK: Grouping Types
    
    func sortData(_ model : CodableContainer?) {
        
        data[.taxi] = model?.poiList?.filter({ $0.fleetType == "TAXI" })
        data[.pooling] = model?.poiList?.filter({ $0.fleetType == "POOLING" })
    }
    
    // MARK: Getting List details
    
    func getScheduleDetailsFromServer()
    {
        let params =  ["p1Lat": 53.694865, "p1Lon": 9.757589, "p2Lat": 53.394655, "p2Lon": 10.099891]
        
        MYTModel().getListDetailsFromRest(parameter: params as NSDictionary, withSuccess: { (response, userInfo) in
            self.model = response!
            self.delegate?.updateData()
        }) { (error, userInfo) in
            print(error?.localizedDescription as Any)
        }
    }
    
    // MARK: List TableView Datasource and Delegates
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return TableSection.total.rawValue
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        if let tableSection = TableSection(rawValue: section), let listData = data[tableSection] {
            return listData.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {

        if let tableSection = TableSection(rawValue: section), let listData = data[tableSection], listData.count > 0 {
            return SectionHeaderHeight
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 100
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.width, height: SectionHeaderHeight))
        view.backgroundColor = UIColor(red: 253.0/255.0, green: 240.0/255.0, blue: 196.0/255.0, alpha: 1)
        let label = UILabel(frame: CGRect(x: 15, y: 0, width: tableView.bounds.width - 30, height: SectionHeaderHeight))
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.textColor = UIColor.black
        if let tableSection = TableSection(rawValue: section) {
            switch tableSection {
            case .taxi:
                label.text = "Taxi"
            case .pooling:
                label.text = "Pooling"
            default:
                label.text = ""
            }
        }
        view.addSubview(label)
        return view
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListCell", for: indexPath) as! MYTListViewCell

        if let tableSection = TableSection(rawValue: indexPath.section), let list = data[tableSection]?[indexPath.row] {

            cell.loadData(list)
        }
        return cell
    }
}
