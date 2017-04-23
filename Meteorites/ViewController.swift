//
//  ViewController.swift
//  Meteorites
//
//  Created by Adam Bezák on 21.4.17.
//  Copyright © 2017 Adam Bezák. All rights reserved.
//

import UIKit
import TRON
import SwiftyJSON
import RealmSwift
import DynamicColor

class ViewController: UITableViewController {
    
    var meteorites : [Meteor?]?
    let originalColor = DynamicColor(hexString: "#c0392b")
    let cellId = "cellId"
    let cellDetailId = "cellDetailId"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Meteorites"
        let manager = DataManager()
//        smanager.deleteAll()
        
        if let results = manager.objects(type: Meteor.self) {
            self.meteorites = Array(results).sorted(by: { $0.mass > $1.mass})
            if (self.meteorites?.count)! > 0 && InternetReachability.isConnectedToNetwork(){
                let oneMeteorLastUpdateTime = Int32((self.meteorites?[0]?.lastUpdate.timeIntervalSinceNow)!)
                if abs(oneMeteorLastUpdateTime) > 86400 {
                    manager.deleteAll()
                    Service.sharedInstance.fetchData(completion: { (meteorites, err) in
                        let manager = DataManager()
                        
                        for m in meteorites! {
                            manager.add(meteor: m)
                        }
                        self.meteorites = Array(meteorites!).sorted(by: { $0.mass > $1.mass})
                        self.tableView.dataSource = self
                        self.tableView.delegate = self
                        self.tableView.reloadData()
                    })
                }
            }
        }
        
        self.tableView.backgroundColor = originalColor.lighter(amount: 0.5)
        self.tableView.rowHeight = UITableViewAutomaticDimension
        
        if self.meteorites?.count == 0 {
            Service.sharedInstance.fetchData(completion: { (meteorites, err) in
                let manager = DataManager()
                
                for m in meteorites! {
                    manager.add(meteor: m)
                }
                
                self.meteorites = Array(meteorites!).sorted(by: { $0.mass > $1.mass})
                self.tableView.dataSource = self
                self.tableView.delegate = self
                self.tableView.reloadData()
            })
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let singleMeteor = meteorites?[indexPath.row] {
            var cell : UITableViewCell? = tableView.dequeueReusableCell(withIdentifier: cellId) as? MeteorCell
            if cell == nil {
                cell = UITableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: cellId)
            }
            
            cell?.textLabel?.text = singleMeteor.name
            cell?.detailTextLabel?.text = (singleMeteor.mass.stringValue) + " g"
            cell?.backgroundColor = originalColor.lighter(amount: 0.45)
            
            let cellAudioButton = UIButton(type: .custom)
            cellAudioButton.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
            cellAudioButton.addTarget(self, action: #selector(handleShowDetail(sender:)), for: .touchUpInside)
            cellAudioButton.setImage(UIImage(named: "expand"), for: .normal)
            cellAudioButton.contentMode = .scaleAspectFit
            cellAudioButton.tag = indexPath.row
            cell?.selectionStyle = .none
            cell?.accessoryView = cellAudioButton as UIView
            
            return cell!
        }
        else {
            if let rowData = meteorites?[getParentCellIndex(expansionIndex: indexPath.row)] {
                //  Create an ExpansionCell
                var cell : UITableViewCell? = tableView.dequeueReusableCell(withIdentifier: cellId) as? MeteorDetailCell
                if cell == nil {
                    cell = UITableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: cellId)
                }
                
                //  Get the index of the parent Cell (containing the data)
                let parentCellIndex = getParentCellIndex(expansionIndex: indexPath.row)
                
                //  Get the index of the flight data (e.g. if there are multiple ExpansionCells
                let flightIndex = indexPath.row - parentCellIndex - 1
                
                //  Set the cell's data
                cell?.textLabel?.text = "test"
                cell?.selectionStyle = .none
                return cell!
            }
        }
        return UITableViewCell()
    }
    
    private func getParentCellIndex(expansionIndex: Int) -> Int {
        
        var selectedCell: Meteor?
        var selectedCellIndex = expansionIndex
        
        while(selectedCell == nil && selectedCellIndex >= 0) {
            selectedCellIndex -= 1
            selectedCell = meteorites?[selectedCellIndex]
        }
        
        return selectedCellIndex
    }
    
    func handleShowDetail(sender : UIButton){
        print(sender.tag)
        print("Tapped")
        if let data = meteorites?[sender.tag] {
            
            // If user clicked last cell, do not try to access cell+1 (out of range)
            if(sender.tag + 1 >= (meteorites?.count)!) {
                expandCell(tableView: tableView, index: sender.tag)
            }
            else {
                // If next cell is not nil, then cell is not expanded
                if(meteorites?[sender.tag+1] != nil) {
                    expandCell(tableView: tableView, index: sender.tag)
                    // Close Cell (remove ExpansionCells)
                } else {
                    contractCell(tableView: tableView, index: sender.tag)
                    
                }
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (meteorites!.count)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedMeteor = meteorites?[indexPath.row]
        let vc = MeteorController()
        vc.meteor = selectedMeteor
        vc.meteorites = meteorites?.removeNils()
        tableView.deselectRow(at: indexPath, animated: false)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func expandCell(tableView: UITableView, index: Int) {
        // Expand Cell (add ExpansionCells
        meteorites?.insert(nil, at: index + 1)
        tableView.insertRows(at: [NSIndexPath(row: index + 1, section: 0) as IndexPath] , with: .top)
    }
    
    private func contractCell(tableView: UITableView, index: Int) {
        for i in 1...5 {
            tableView.insertRows(at: [NSIndexPath(row: index + i, section: 0) as IndexPath] , with: .top)
        }
    }
    
}


