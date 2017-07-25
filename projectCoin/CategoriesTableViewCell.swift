//
//  CategoriesTableViewCell.swift
//  projectCoin
//
//  Created by Apple on 13.07.17.
//  Copyright © 2017 kumardastan. All rights reserved.
//

import UIKit
import EasyPeasy

class CategoriesTableViewCell: UITableViewCell {

    lazy var label: UILabel = {
        let label = UILabel()
        label.text = "Hello"
        return label
    }()
    
    var checked: Bool = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
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
        addSubview(label)
    }
    
    func setupConstraints() {
        label <- [
            CenterY(0),
            Left(16),
            Width(300),
            Height(25)
        ]
    }
    
}
