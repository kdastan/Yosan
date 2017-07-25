//
//  TagsContainerView.swift
//  projectCoin
//
//  Created by Apple on 12.07.17.
//  Copyright © 2017 kumardastan. All rights reserved.
//

import UIKit
import EasyPeasy

class TagsContainerView: UIView {
    
    let sizeX = UIScreen.main.bounds.width

    lazy var image: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "iamge")
        return image
    }()
    
    lazy var textField: UITextField = {
        let textField = UITextField()
        textField.textColor = .white
        return textField
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
        [image, textField].forEach {
            self.addSubview($0)
        }
    }
    
    func setupConstraints() {
        image <- [
            CenterY(0),
            Left(5),
            Width(50),
            Size(24)
        ]
        
        textField <- [
            CenterY(0),
            Left(10).to(image, .right),
            Width(175)
        ]
        
    }
    
}
