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
    
    var meteorites: [Meteor?]?
    let originalColor = DynamicColor(hexString: "#c0392b")
    let cellId = "cellId"
    let cellDetailId = "cellDetailId"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Meteorites"
        let manager = DataManager()
//        manager.deleteAll()
        
        if let results = manager.objects(type: Meteor.self) {
            self.meteorites = Array(results).sorted(by: { $0.mass > $1.mass})
            if (self.meteorites?.count)! > 0 && InternetReachability.isConnectedToNetwork(){
                let oneMeteorLastUpdateTime = Int32((self.meteorites?[0]?.lastUpdate.timeIntervalSinceNow)!)
                if abs(oneMeteorLastUpdateTime) > 86400 {
                    Service.sharedInstance.fetchData(completion: { (meteorites, err) in
                        let manager = DataManager()
                        manager.deleteAll()
                        
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
        self.tableView.register(MeteorDetailCell.self, forCellReuseIdentifier: cellDetailId)
        self.tableView.register(MeteorCell.self, forCellReuseIdentifier: cellId)
        self.tableView.rowHeight = UITableViewAutomaticDimension
        
        if self.meteorites?.count == 0 {
            let myActivityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
            myActivityIndicator.center = view.center
            myActivityIndicator.hidesWhenStopped = true
            myActivityIndicator.startAnimating()
            view.addSubview(myActivityIndicator)
            
            Service.sharedInstance.fetchData(completion: { (meteorites, err) in
                let manager = DataManager()
                
                for m in meteorites! {
                    manager.add(meteor: m)
                }
                
                self.meteorites = Array(meteorites!).sorted(by: { $0.mass > $1.mass})
                self.tableView.dataSource = self
                self.tableView.delegate = self
                myActivityIndicator.stopAnimating()
                self.tableView.reloadData()
            })
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let singleMeteor = meteorites?[indexPath.row] {
            var cell : MeteorCell? = tableView.dequeueReusableCell(withIdentifier: cellId) as? MeteorCell
            if cell == nil {
                cell = UITableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: cellId) as? MeteorCell
            }
            
            cell?.nameLabel.text = singleMeteor.name
            cell?.detailNameLabel.text = (singleMeteor.mass.stringValue) + " g"
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
            
            let parentIndex = getParentCellIndex(expansionIndex: indexPath.row)
                
            if let m = meteorites?[parentIndex] {
                var cell : MeteorDetailCell? = tableView.dequeueReusableCell(withIdentifier: cellDetailId) as? MeteorDetailCell
                if cell == nil {
                    cell = UITableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: cellDetailId) as? MeteorDetailCell
                }
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                let str = dateFormatter.string(from:m.date)
                
                cell?.isUserInteractionEnabled = false
                cell?.dateLabel.text = str
                cell?.nameLabel.text = m.name + " - " + m.id.stringValue
                cell?.gramsLabel.text = m.mass.stringValue + " g"
                cell?.geoLabel.text = m.reclat.toString() + "," + m.reclong.toString()
                cell?.backgroundColor = originalColor.lighter(amount: 0.5)
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
        if let _ = meteorites?[sender.tag] {
            
            if(sender.tag + 1 >= (meteorites?.count)!) {
                expandCell(tableView: tableView, index: sender.tag)
            }
            else {
                if(meteorites?[sender.tag+1] != nil) {
                    expandCell(tableView: tableView, index: sender.tag)
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
        if let _ = meteorites?[indexPath.row] {
            return 60
        }
        else {
            return 128
        }
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
        if let _ = meteorites?[index] {
            
            CATransaction.begin()
            CATransaction.setCompletionBlock({ 
                tableView.reloadData()
            })
            meteorites?.insert(nil, at: index + 1)
            tableView.insertRows(at: [NSIndexPath(row: index + 1, section: 0) as IndexPath] , with: .top)
            
            CATransaction.commit()
        }
    }
    
    private func contractCell(tableView: UITableView, index: Int) {
        if let _ = meteorites?[index] {
            
            CATransaction.begin()
            CATransaction.setCompletionBlock({ 
                tableView.reloadData()
            })
            meteorites?.remove(at: index+1)
            tableView.deleteRows(at: [NSIndexPath(row: index + 1, section: 0) as IndexPath], with: .top)
            CATransaction.commit()
        }
    }
    
}


