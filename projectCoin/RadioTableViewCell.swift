//
//  RadioTableViewCell.swift
//  projectCoin
//
//  Created by Apple on 16.07.17.
//  Copyright © 2017 kumardastan. All rights reserved.
//

import UIKit
import EasyPeasy
import LTHRadioButton

class RadioTableViewCell: UITableViewCell {
    
    private let selectedColor   = UIColor(red: 74/255, green: 144/255, blue: 226/255, alpha: 1.0)
    private let deselectedColor = UIColor.lightGray
    
    lazy var radiocell: LTHRadioButton = {
        let radiocell = LTHRadioButton()
        return radiocell
    }()
    
    lazy var label: UILabel = {
        let label = UILabel()
        label.text = "ASD"
        label.font = UIFont(name: "Helvetica", size: 14)
        return label
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
        setupConstraints()
    }
    
    func setupView() {
        addSubview(radiocell)
        addSubview(label)
    }
    
    func setupConstraints() {
        radiocell <- [
            CenterY(0),
            Left(6),
            Width(10),
            Height(25)
        ]
        
        label <- [
            Top(0).to(radiocell, .top),
            Left(15).to(radiocell, .right),
            Width(100),
            Height().like(radiocell)
        ]
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(with color: UIColor) {
        backgroundColor = color
        radiocell.selectedColor = color == .darkGray ? .white : selectedColor
        radiocell.deselectedColor = color == .darkGray ? .lightGray : deselectedColor
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        if selected {
            return radiocell.select(animated: animated)
        }
        
        radiocell.deselect(animated: animated)
        
    }
}
