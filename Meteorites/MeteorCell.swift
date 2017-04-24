//
//  MeteorCell.swift
//  Meteorites
//
//  Created by Adam Bezák on 21.4.17.
//  Copyright © 2017 Adam Bezák. All rights reserved.
//

import UIKit

class MeteorCell: UITableViewCell {
    
    var countLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "HelveticaNeue-Light", size: 17)
        label.textColor = UIColor.black
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "HelveticaNeue-Light", size: 20)
        label.textColor = UIColor.black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var detailNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "HelveticaNeue-Light", size: 12)
        label.textColor = UIColor.black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        addSubview(countLabel)
        addSubview(nameLabel)
        addSubview(detailNameLabel)
        
        //x,y,width,heigh
        countLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 10).isActive = true
        countLabel.widthAnchor.constraint(equalToConstant: 40).isActive = true
        countLabel.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        
        nameLabel.leftAnchor.constraint(equalTo: countLabel.rightAnchor).isActive = true
        nameLabel.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        nameLabel.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        nameLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        detailNameLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor).isActive = true
        detailNameLabel.widthAnchor.constraint(equalTo: nameLabel.widthAnchor).isActive = true
        detailNameLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        detailNameLabel.leftAnchor.constraint(equalTo: countLabel.rightAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
