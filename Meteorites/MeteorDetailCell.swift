//
//  MeteorDetailCell.swift
//  Meteorites
//
//  Created by Adam Bezák on 23.4.17.
//  Copyright © 2017 Adam Bezák. All rights reserved.
//

import UIKit

class MeteorDetailCell: UITableViewCell {

    let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20)
        label.textColor = UIColor.black
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let idImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "id")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    let idLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = UIColor.black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let dateImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "date")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    let dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = UIColor.black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let gramsImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "grams")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    let gramsLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = UIColor.black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let geoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "geo")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    let geoLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = UIColor.black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        addSubview(dateImageView)
        addSubview(gramsImageView)
        addSubview(geoImageView)
        addSubview(idLabel)
        addSubview(idImageView)
        addSubview(gramsLabel)
        addSubview(geoLabel)
        addSubview(dateLabel)
        
        //x,y,width,height
        
        idImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 13).isActive = true
        idImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 8).isActive = true
        idImageView.widthAnchor.constraint(equalToConstant: 25).isActive = true
        idImageView.heightAnchor.constraint(equalToConstant: 25).isActive = true
        
        idLabel.leftAnchor.constraint(equalTo: idImageView.rightAnchor, constant: 13).isActive = true
        idLabel.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        idLabel.topAnchor.constraint(equalTo: idImageView.topAnchor).isActive = true
        idLabel.bottomAnchor.constraint(equalTo: idImageView.bottomAnchor).isActive = true
        
        dateImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 13).isActive = true
        dateImageView.topAnchor.constraint(equalTo: self.idImageView.bottomAnchor, constant: 8).isActive = true
        dateImageView.widthAnchor.constraint(equalToConstant: 25).isActive = true
        dateImageView.heightAnchor.constraint(equalToConstant: 25).isActive = true
        
        dateLabel.leftAnchor.constraint(equalTo: dateImageView.rightAnchor, constant: 13).isActive = true
        dateLabel.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        dateLabel.topAnchor.constraint(equalTo: dateImageView.topAnchor).isActive = true
        dateLabel.bottomAnchor.constraint(equalTo: dateImageView.bottomAnchor).isActive = true
        
        gramsImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 13).isActive = true
        gramsImageView.topAnchor.constraint(equalTo: self.dateImageView.bottomAnchor, constant: 8).isActive = true
        gramsImageView.widthAnchor.constraint(equalToConstant: 25).isActive = true
        gramsImageView.heightAnchor.constraint(equalToConstant: 25).isActive = true
        
        gramsLabel.leftAnchor.constraint(equalTo: gramsImageView.rightAnchor, constant: 13).isActive = true
        gramsLabel.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        gramsLabel.topAnchor.constraint(equalTo: gramsImageView.topAnchor).isActive = true
        gramsLabel.bottomAnchor.constraint(equalTo: gramsImageView.bottomAnchor).isActive = true
        
        geoImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 13).isActive = true
        geoImageView.topAnchor.constraint(equalTo: self.gramsImageView.bottomAnchor, constant: 8).isActive = true
        geoImageView.widthAnchor.constraint(equalToConstant: 25).isActive = true
        geoImageView.heightAnchor.constraint(equalToConstant: 25).isActive = true
        
        geoLabel.leftAnchor.constraint(equalTo: geoImageView.rightAnchor, constant: 13).isActive = true
        geoLabel.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        geoLabel.topAnchor.constraint(equalTo: geoImageView.topAnchor).isActive = true
        geoLabel.bottomAnchor.constraint(equalTo: geoImageView.bottomAnchor).isActive = true
        
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
