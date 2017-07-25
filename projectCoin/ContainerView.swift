//
//  ContainerView.swift
//  projectCoin
//
//  Created by Apple on 12.07.17.
//  Copyright © 2017 kumardastan. All rights reserved.
//

import UIKit
import EasyPeasy

class ContainerView: UIView {
    
    let size = (UIScreen.main.bounds.width-15)/3

    lazy var labelData: UILabel = {
        let label = UILabel()
        label.text = "Last"
        label.font = UIFont(name: "Helvetica", size: 15)
        label.textColor = .white
        return label
    }()
    
    lazy var labelSpent: UILabel = {
        let label = UILabel()
        label.text = "Spent"
        label.textColor = .moneyInfoColor
        return label
    }()
    
    lazy var labelMoney: UILabel = {
        let label = UILabel()
        label.text = "7,000 KZT"
        label.textColor = .moneyColor
        return label
    }()
    
    lazy var labelDate: UILabel = {
        let label = UILabel()
        label.text = "5 days"
        label.font = UIFont(name: "Helvetica", size: 14)
        label.textColor = UIColor(red: 255, green: 255, blue: 255, alpha: 0.2)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
        setupConstraints()
    
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setupViews() {
        [labelData, labelSpent, labelMoney, labelDate].forEach {
            self.addSubview($0)
        }
    }
    
    func setupConstraints() {
        labelData <- [
            Width(size),
            Top(5),
            Left(5)
        ]
        
        labelSpent <- [
            Width(0).like(labelData),
            Top(0).to(labelData, .bottom),
            Left(0).to(labelData, .left)
        ]
        
        labelMoney <- [
            Width(0).like(labelData),
            Top(5).to(labelSpent, .bottom),
            Left(0).to(labelSpent, .left)
        ]
        
        labelDate <- [
            Width(0).like(labelData),
            Top(5).to(labelMoney, .bottom),
            Left(0).to(labelMoney, .left)
        ]
    }
}
