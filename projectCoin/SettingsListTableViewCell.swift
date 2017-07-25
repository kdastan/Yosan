//
//  SettingsListTableViewCell.swift
//  projectCoin
//
//  Created by Apple on 13.07.17.
//  Copyright © 2017 kumardastan. All rights reserved.
//

import UIKit
import EasyPeasy

class SettingsListTableViewCell: UITableViewCell {

    lazy var labelView: UILabel = {
        let labelView = UILabel()
        labelView.text = "Asdasd"
        return labelView
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
  
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupView()
        setupConstraints()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        self.addSubview(labelView)
    }
    
    func setupConstraints() {
        labelView <- [
            CenterY(0),
            Left(16),
            Width(100),
            Height(50)
        ]
    }

}
