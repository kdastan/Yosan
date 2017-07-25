//
//  SetUpViewController.swift
//  projectCoin
//
//  Created by Apple on 10.07.17.
//  Copyright © 2017 kumardastan. All rights reserved.
//

import UIKit
import EasyPeasy
import FSCalendar
import JVFloatLabeledTextField
import NotificationBannerSwift
import RealmSwift
import Instructions

class SetUpViewController: UIViewController {
    
    let isFirstLaunch = UIApplication.isFirstLaunch()
    
    var arr: [UIView] = []
    var descriptionText = ["Select interval", "Enter amount of money, ready to spent", "Submit changes"]
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    let pointOfInterest = UIView()
    
    let sizeX = UIScreen.main.bounds.width
    let sizeY = UIScreen.main.bounds.height/5
    
    var dayInterval = 0
    var selectedDate = ""
    
    var inputText = ""
    
    lazy var intro: CoachMarksController = {
        let intro = CoachMarksController()
        return intro
    }()
    
    lazy var calendar: FSCalendar = {
        let calendar = FSCalendar()
        
        var formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        
        calendar.backgroundColor = UIColor.clear
        calendar.appearance.selectionColor = .infoColor
        calendar.appearance.weekdayTextColor = .moneyColor
        calendar.appearance.headerTitleColor = .moneyColor
        calendar.appearance.titleDefaultColor = .white
        calendar.clipsToBounds = true
        
        return calendar
    }()
    
    lazy var textField: JVFloatLabeledTextField = {
        let textField = JVFloatLabeledTextField()
        textField.placeholder = "Enter money here: "
        textField.placeholderColor = .white
        textField.keyboardType = .numberPad
        textField.textColor = .white
        textField.font = UIFont.systemFont(ofSize: 14)
        
        return textField
    }()
    
    lazy var button: UIButton = {
        let button = UIButton()
        button.setTitle("OK", for: .normal)
        button.backgroundColor = .calendarTodayColor
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
        return button
    }()
    
    lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "piggy")
        return imageView
    }()

    public enum SelectionMode {
        case single(style: Style), multiple(style: Style), sequence(style: SequenceStyle), none
        
        public enum SequenceStyle { case background, circle, semicircleEdge, line }
        public enum Style { case background, circle, line }
    }
  
    public var selectionMode: SelectionMode = .single(style: .circle)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        calendar.delegate = self
        intro.dataSource = self
        
        view.backgroundColor = .backgroundColor
        //print(Realm.Configuration.defaultConfiguration.fileURL!)
        setupViews()
        setupConstraints()
        firstLaunc()
        arr = [calendar, textField, button]
    }
    
    func firstLaunc() {
        if isFirstLaunch {
            fLaunc()
        }
    }
    
    func clearBalance() {
        let realm = try! Realm()
        try! realm.write {
            let data = realm.objects(Balance)
            realm.delete(data)
        }
    }
    
    func addBalnce() {
        let balance = Balance()
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yy"
        let resultToday = formatter.string(from: Date())
        
        balance.anountBalance = Int(self.textField.text!)!
        balance.deadline = self.selectedDate
        balance.date = resultToday
        
        let tempBalance = Int(self.textField.text!)!/self.dayInterval
        balance.today = tempBalance
        
        if self.dayInterval > 1 {
            balance.tomorrow = tempBalance
        } else {
            balance.tomorrow = 0
        }
        
        balance.temporaryBalance = Int(self.textField.text!)!
            
        balance.objectID = "reusablecell"
            
        let realm = try! Realm()
        try! realm.write {
            realm.add(balance, update: true)
        }
    }
    
    func buttonPressed() {
        if let text = self.textField.text, text != "", self.dayInterval != 0 {

            clearBalance()
            addBalnce()
            clearExpens()
            
            let banner = StatusBarNotificationBanner(title: "Datas Saved", style: .success)
            banner.show()
            
            self.tabBarController?.selectedIndex = 0
        } else {
            let banner1 = StatusBarNotificationBanner(title: "Please select another date", style: .warning)
            banner1.show()
        }
    }
    
    func fLaunc() {
        self.intro.start(on: self)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        self.intro.stop(immediately: true)
    }
    
    func clearExpens() {
        let realm = try! Realm()
        let data = realm.objects(Expens)
        try! realm.write {
            realm.delete(data)
        }
    }
    
    func setupViews() {
        edgesForExtendedLayout = []
        view.addSubview(calendar)
        view.addSubview(textField)
        view.addSubview(button)
        view.addSubview(imageView)
    }
    
    func setupConstraints() {
        calendar <- [
            Top(20),
            Left(0),
            Width(sizeX),
            Height(sizeX)
        ]
        
        textField <- [
            Width(185),
            Height(50),
            CenterX(0),
            Top(25).to(calendar, .bottom)
        ]
        
        imageView <- [
            Size(24),
            CenterY(0).to(textField),
            Right(10).to(textField, .left)
        ]
        
        button <- [
            Width().like(textField),
            Height(25),
            CenterX(0),
            Top(20).to(textField, .bottom)
        ]
        
    }
}


