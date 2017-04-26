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
    
    var activityIndicatorView: UIView?
    var activityIndicator: UIActivityIndicatorView?
    var meteorites: [Meteor?]?
    let originalColor = DynamicColor(hexString: "#007aff")
    let cellId = "cellId"
    let cellDetailId = "cellDetailId"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Meteorites"
        let refreshButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.refresh, target: self, action: #selector(refreshData))
        navigationItem.rightBarButtonItem = refreshButton
        
        let manager = DataManager()
//        manager.deleteAll()
        
        if let results = manager.objects(type: Meteor.self) {
            self.meteorites = Array(results).sorted(by: { $0.mass > $1.mass})
            if (self.meteorites?.count)! > 0 && InternetReachability.isConnectedToNetwork(){
                let oneMeteorLastUpdateTime = Int32((self.meteorites?[0]?.lastUpdate.timeIntervalSinceNow)!)
                if abs(oneMeteorLastUpdateTime) > 1 {
                    refreshData()
                }
            }
        }
        
        setupTableView()
        
        if self.meteorites?.count == 0 {
            refreshData()
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
            
            let cellExpandButton = MyButton(type: .custom)
            cellExpandButton.frame = CGRect(x: 0, y: 0, width: 15, height: 15)
            cellExpandButton.addTarget(self, action: #selector(handleShowDetail(sender:)), for: .touchUpInside)
            cellExpandButton.addedTouchArea = 24
            cellExpandButton.setImage(UIImage(named: "expand"), for: .normal)
            cellExpandButton.contentMode = .scaleAspectFit
            cellExpandButton.alpha = 0.5
            cellExpandButton.tag = indexPath.row
            
            cell?.selectionStyle = .none
            cell?.accessoryView = cellExpandButton as UIView
            
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
                dateFormatter.dateFormat = "yyyy"
                let str = dateFormatter.string(from:m.date)
                
                cell?.isUserInteractionEnabled = false
                cell?.dateLabel.text = str
                cell?.idLabel.text = m.id.stringValue
//                cell?.nameLabel.text = m.name + " - " + m.id.stringValue
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
            return 50
        }
        else {
            return 137
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
    
    public func getMeteorites() -> [Meteor?]{
        return self.meteorites!
    }
    
    func refreshDB() {
        let manager = DataManager()
        manager.deleteAll()
        
        for m in meteorites! {
            manager.add(meteor: m!)
        }
    }
    
    func refreshData() {

        showActivityIndicatory(uiView: self.view)
        
        fetchMeteorites { (err) in
            if (err != nil) {
                let alert = UIAlertController(title: "Error", message: "Can't download data from site. Try again later please.", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
            self.hideActivityIndicator(uiView: self.activityIndicatorView!)
        }
    }
    
    public func fetchMeteorites(completion: @escaping (APIError<Service.JSONError>?) -> ()) {
        
        Service.sharedInstance.fetchData { (meteorites,error) in
            if ((error) != nil) {
                completion(error)
            } else {
                
                self.meteorites = Array(meteorites!).sorted(by: { $0.mass > $1.mass})
                self.refreshDB()
                self.tableView.reloadData()
                completion(nil)
            }
        }
    }
    
    func setupTableView() {
        self.tableView.backgroundColor = originalColor.lighter(amount: 0.5)
        self.tableView.register(MeteorDetailCell.self, forCellReuseIdentifier: cellDetailId)
        self.tableView.register(MeteorCell.self, forCellReuseIdentifier: cellId)
        self.tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    func showActivityIndicatory(uiView: UIView) {
        activityIndicatorView = UIView()
        activityIndicatorView?.frame = uiView.frame
        activityIndicatorView?.center = uiView.center
        
        let loadingView: UIView = UIView()
        loadingView.frame = CGRect(x: 0, y: 0, width: 80, height: 80)
        loadingView.center = uiView.center
        loadingView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        loadingView.clipsToBounds = true
        loadingView.layer.cornerRadius = 10
        
        activityIndicator = UIActivityIndicatorView()
        activityIndicator?.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        activityIndicator?.activityIndicatorViewStyle =
            UIActivityIndicatorViewStyle.whiteLarge
        activityIndicator?.center = CGPoint(x: loadingView.frame.size.width / 2, y: loadingView.frame.size.height / 2)
        loadingView.addSubview(activityIndicator!)
        activityIndicatorView?.addSubview(loadingView)
        uiView.addSubview(activityIndicatorView!)
        activityIndicator?.startAnimating()
    }
    
    func hideActivityIndicator(uiView: UIView) {
        activityIndicator?.stopAnimating()
        uiView.removeFromSuperview()
    }
    
}


