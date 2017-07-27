//
//  ViewController.swift
//  projectCoin
//
//  Created by Apple on 10.07.17.
//  Copyright © 2017 kumardastan. All rights reserved.
//

import UIKit
import EasyPeasy
import Charts
import SCLAlertView
import RealmSwift
import NotificationBannerSwift
import Instructions

class ViewController: UIViewController {
    
    var arr: [UIView] = []
    
    let isFirstLaunch = UIApplication.isFirstLaunch()

    var arrOfDescription = [descDeadline, descRemainMoney, descButton, descAvailableMoneyToday, descAvailableMoneyTomorrow, descChart]
    var todayFromBalance = 0
    var tomorrowFromBalance  = 0
    var amountBalance = 0
    var totalBalance = 0
    var dateFromBalance = ""
    var deadlineFromBalance = ""
    var dayInterval = 1
    var formatter = DateFormatter()
    var resultToday = ""
    var resultYesterday = ""
    var resultTomorrow = ""
    
    var categories = ["transport", "food", "entertainment", "products", "others"]
    var chartCategoryData: [Double] = [10, 0, 0, 0, 0]
    let days = ["Yesterday", "Today", "Tomorrow"]
    var selectedIndex = 0
    
    let sizeX = (UIScreen.main.bounds.width-15)/3 - 1.5
    let sizeY = UIScreen.main.bounds.height/5
    
    lazy var intro: CoachMarksController = {
        let intro = CoachMarksController()
        return intro
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(RadioTableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.isScrollEnabled = false
        tableView.rowHeight = 35
        return tableView
    }()
    
    lazy var lastContainer: ContainerView = {
        let container = ContainerView()
        container.labelData.text = "YESTERDAY"
        container.labelDate.text = ""
        container.labelSpent.text = "spent"
        container.labelMoney.text = "2.210 KZT"
        return container
    }()
    
    lazy var secondContainer: ContainerView = {
        let container = ContainerView()
        container.labelData.text = "TODAY"
        container.labelDate.text = ""
        container.labelSpent.text = "available"
        container.labelMoney.text = "3.100 KZT"
        return container
    }()
    
    lazy var nextContainer: ContainerView = {
        let container = ContainerView()
        container.labelData.text = "NEXT DAY"
        container.labelDate.text = ""
        container.labelSpent.text = "available"
        container.labelMoney.text = "3.100 KZT"
        return container
    }()
    
    lazy var container: UIView = {
        let container = UIView()
        return container
    }()
    
    lazy var labelRemainingAmountText: UILabel = {
        let label = UILabel()
        label.text = "Balance"
        label.font = UIFont(name: "Helvetica", size: 34)
        label.textColor = .white
        return label
    }()

    lazy var labelRemaingAmountDeadline: UILabel = {
        let label = UILabel()
        label.text = "27.07.17"
        label.font = UIFont(name: "Helvetica", size: 16)
        label.textColor = UIColor(red: 255, green: 255, blue: 255, alpha: 0.2)
        return label
    }()
    
    lazy var labelRemaingAmountMoney: UILabel = {
        let label = UILabel()
        label.text = "35,000 KZT"
        label.font = UIFont(name: "Helvetica", size: 37)
        label.textColor = .moneyColor
        return label
    }()
    
    lazy var containerPieChart: UIView = {
        let container = UIView()
        return container
    }()
    
    lazy var chart: PieChartView = {
        let chart = PieChartView()
        chart.drawEntryLabelsEnabled = false
        
        return chart
    }()

    lazy var addRecordButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "plus"), for: .normal)
        button.addTarget(self, action: #selector(addRecord), for: .touchUpInside)
        return button
    }()
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    //MARK: Adds new expens. Works fine
    func addRecord() {
        let appearance = SCLAlertView.SCLAppearance(
            kTitleFont: UIFont(name: "HelveticaNeue", size: 20)!,
            kTextFont: UIFont(name: "HelveticaNeue", size: 14)!,
            kButtonFont: UIFont(name: "HelveticaNeue-Bold", size: 14)!,
            showCloseButton: true,
            disableTapGesture: true
        )
        
        let alert = SCLAlertView(appearance: appearance)
        let txt = alert.addTextField("How much money spent?")
        txt.keyboardType = .numberPad
        alert.addButton("Submit") {
            guard let data = txt.text, txt.text != "" else {
                return
            }
            
            let newData = Int(data)
            let selectedCategory = self.categories[self.selectedIndex]
            
            self.setCategoriesData(category: selectedCategory, money: newData!)
            self.updateBalanceData(money: newData!)
            self.getBalanceData()
            self.getExpenseDataForChart()
        }
        tableView.frame = CGRect(x: 0, y: 0, width: 200, height: 175)
        
        alert.customSubview = tableView
        alert.showEdit("New expense", subTitle: "", closeButtonTitle: "Cancel")
    }
    
    func addRecord3D(category: String) {
        let appearance = SCLAlertView.SCLAppearance(
            kTitleFont: UIFont(name: "HelveticaNeue", size: 20)!,
            kTextFont: UIFont(name: "HelveticaNeue", size: 14)!,
            kButtonFont: UIFont(name: "HelveticaNeue-Bold", size: 14)!,
            showCloseButton: true,
            disableTapGesture: true
        )
        
        let alert = SCLAlertView(appearance: appearance)
        let txt = alert.addTextField("Enter here")
        txt.keyboardType = .numberPad
        alert.addButton("Submit") {
            guard let data = txt.text, txt.text != "" else {
                return
            }
            
            let newData = Int(data)
            let selectedCategory = category
            
            self.setCategoriesData(category: selectedCategory, money: newData!)
            self.updateBalanceData(money: newData!)
            self.getBalanceData()
            self.getExpenseDataForChart()
        }
        
        alert.showEdit("New record", subTitle: "How much money did you spent for \(category) ?", closeButtonTitle: "Cancel")
    }
    
    //MARK: Updates balance model. Works fine
    func updateBalanceData(money: Int) {
        let balance = Balance()
        
        totalBalance -= money
        todayFromBalance -= money
        
        balance.anountBalance = totalBalance
        balance.date = dateFromBalance
        balance.deadline = deadlineFromBalance
        
        balance.temporaryBalance = totalBalance
        balance.today = todayFromBalance
        balance.tomorrow = tomorrowFromBalance
        
        balance.objectID = "reusablecell"
        
        let realm = try! Realm()
        try! realm.write {
            realm.add(balance, update: true)
        }
    }
    
    func yesterdayExpens() {
        var yesterday = 0
        let realm = try! Realm()
        let yesterdaySpentTotalAmount = realm.objects(Expens).filter("date = %@", resultYesterday)
        for spentMoney in yesterdaySpentTotalAmount {
            yesterday += spentMoney.amount
        }
        lastContainer.labelMoney.text = "\(yesterday) KZT"
        
        uploadDays()
    }
    
    //MARK: Loads data from Expens for chart
    func getExpenseDataForChart() {
        var transport = 0
        var food = 0
        var entertainment = 0
        var products = 0
        var other = 0
        
        let realm = try! Realm()
        
        let datas = realm.objects(Expens).filter("date = %@", resultToday)
        for data in datas {
            switch data.categories {
            case "transport":
                transport += data.amount
            case "food":
                food += data.amount
            case "entertainment":
                entertainment += data.amount
            case "products":
                products += data.amount
            case "others":
                other += data.amount
            default:
                print("No data")
            }
        }
        
        self.chartCategoryData[0] = Double(transport)
        self.chartCategoryData[1] = Double(food)
        self.chartCategoryData[2] = Double(entertainment)
        self.chartCategoryData[3] = Double(products)
        self.chartCategoryData[4] = Double(other)
        
        setupDataForChart()
    }
    
    //MARK: Displaying chart. Works fine
    func setupDataForChart(){
        
        let track = ["Transport", "Food", "Entertain", "Products", "Other"]
        
        var entries: [PieChartDataEntry] = []
        for (index, value) in chartCategoryData.enumerated() {
            let entry = PieChartDataEntry()
            entry.y = value
            entry.label = track[index]
            entries.append(entry)
        }
        let set = PieChartDataSet( values: entries, label: "")
        set.drawValuesEnabled = false
        
        let colors: [UIColor] = [.moneyColor, .dateColor, .moneyInfoColor, .infoColor, .calendarTodayColor]
        set.colors = colors
        
        let data = PieChartData(dataSet: set)
        chart.data = data
        chart.noDataText = "No data available"
        chart.drawSlicesUnderHoleEnabled = false
        chart.legend.enabled = false
        
        
        chart.isUserInteractionEnabled = true
        
        let d = Description()
        d.text = ""
        chart.chartDescription = d
        
        let myAttribute = [ NSFontAttributeName: UIFont(name: "Helvetica", size: 18.0)! ]
        let myAttrString = NSAttributedString(string: "Today", attributes: myAttribute)
        
        chart.centerAttributedText = myAttrString
        
        chart.holeRadiusPercent = 0.4
        chart.transparentCircleRadiusPercent = 0.45
    }
    
    //MARK: Adds new record in Expens model. Works fine
    func setCategoriesData(category: String, money: Int) {
        let categories = Expens()
        
        categories.amount = money
        categories.date = self.resultToday
        categories.categories = category
        
        let realm = try! Realm()
        
        try? realm.write {
            realm.add(categories)
        }
    }
    
    //MARK: Loads data from Balance to represent in ViewController
    func getBalanceData() {
        
        resultToday = formatter.string(from: Date())
        resultYesterday = formatter.string(from: Date().yesterday)

        self.yesterdayExpens()
      
        let realm = try! Realm()
        let datas = realm.objects(Balance)
        
        for data in datas {
            labelRemaingAmountDeadline.text = data.deadline
            labelRemaingAmountMoney.text = "\(String(data.anountBalance)) KZT"
            
            todayFromBalance = data.today
            tomorrowFromBalance  = data.tomorrow
            totalBalance = data.anountBalance
            
            dateFromBalance = data.date
            deadlineFromBalance = data.deadline
        }
        
        if dateFromBalance == "" {
            secondContainer.labelMoney.text = "\(todayFromBalance) KZT"
            nextContainer.labelMoney.text = "0 KZT"
            labelRemaingAmountMoney.text = "\(totalBalance) KZT"
        }
        
        else if resultToday != dateFromBalance {
            
            let select = formatter.date(from: deadlineFromBalance)
            let seconds = Int((select?.timeIntervalSinceNow)!)
            dayInterval = (seconds/60/60/24)
            if resultToday != deadlineFromBalance {
                if dayInterval < 0 {
                    dayInterval = 0
                } else {
                    dayInterval += 2
                }
            }
            else {
                dayInterval = 0
            }
            print(dayInterval)
            
            if dayInterval == 1 {
                todayFromBalance = totalBalance/2
                tomorrowFromBalance = 0
            } else if dayInterval == 0  {
                tomorrowFromBalance = 0
                todayFromBalance = totalBalance
                
                let banner = StatusBarNotificationBanner(title: "Interval is ends, please select new", style: .info)
                banner.show()
            } else {
                todayFromBalance = totalBalance/dayInterval
                tomorrowFromBalance = todayFromBalance
            }
            
            dateFromBalance = resultToday
            
            updateBalanceData(money: 0)
            self.getBalanceData()
            
        } else {
            if deadlineFromBalance != "" {
                let select = formatter.date(from: deadlineFromBalance)
                let seconds = Int((select?.timeIntervalSinceNow)!)
                dayInterval = (seconds/60/60/24)
                
                if resultToday != deadlineFromBalance {
                    dayInterval += 2
                }
                else {
                    dayInterval = 0
                }
            } else {
                dayInterval = 0
            }
            
            if dayInterval == 0 {
                nextContainer.labelMoney.text = "0 KZT"
            } else {
                nextContainer.labelMoney.text = "\(tomorrowFromBalance) KZT"
            }
            self.yesterdayExpens()
        }
        
        secondContainer.labelMoney.text = "\(todayFromBalance) KZT"
        labelRemaingAmountMoney.text = "\(totalBalance) KZT"
        self.yesterdayExpens()
    }
    
    func firstLaunch() {
        if isFirstLaunch {
            fLaunch()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .backgroundColor
        tableView.dataSource = self
        tableView.delegate = self
        chart.delegate = self
        intro.dataSource = self
        
        //print(Realm.Configuration.defaultConfiguration.fileURL!)
        
        formatter.dateFormat = "dd/MM/yy"
        resultToday = formatter.string(from: Date())
        
        labelRemaingAmountDeadline.text = "dd/mm/yyyy"
        labelRemaingAmountMoney.text = "No data available"

        arr = [labelRemaingAmountDeadline, labelRemaingAmountMoney, addRecordButton, secondContainer.labelMoney, nextContainer.labelMoney, chart]
        
        firstLaunch()
        
        uploadDays()
        
        setupViews()
        setupConstraints()
        getBalanceData()
        
    }
    
    func uploadDays() {
        resultYesterday = formatter.string(from: Date().yesterday)
        resultToday = formatter.string(from: Date())
        resultTomorrow = formatter.string(from: Date().tomorrow)
 
        secondContainer.labelDate.text = resultToday
        nextContainer.labelDate.text = resultTomorrow
        lastContainer.labelDate.text = resultYesterday
    }
    
    func fLaunch() {
        self.intro.start(on: self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        uploadDays()
        getBalanceData()
        getExpenseDataForChart()
       
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.intro.stop(immediately: true)
    }
  
    func setupViews() {
        edgesForExtendedLayout = []
        
        view.addSubview(container)
        container.addSubview(labelRemainingAmountText)
        container.addSubview(labelRemaingAmountDeadline)
        container.addSubview(labelRemaingAmountMoney)
        container.addSubview(addRecordButton)
        
        view.addSubview(lastContainer)
        view.addSubview(secondContainer)
        view.addSubview(nextContainer)
        
        view.addSubview(containerPieChart)
        containerPieChart.addSubview(chart)
    }
    
    func setupConstraints() {
        container <- [
            Width(UIScreen.main.bounds.width-15),
            Height(sizeY*0.95),
            CenterX(0),
            Top(20)
        ]
        
        lastContainer <- [
            Width(sizeX),
            Height(sizeY*0.95),
            Top(14).to(container, .bottom),
            Left(0).to(container, .left)
        ]
        
        secondContainer <- [
            Width(sizeX),
            Height(sizeY*0.95),
            Top(0).to(lastContainer, .top),
            CenterX(0)
        ]
        
        nextContainer <- [
            Width(sizeX),
            Height(sizeY),
            Top(0).to(lastContainer, .top),
            Right(0).to(container, .right)
        ]
        
        labelRemainingAmountText <- [
            Bottom(0).to(labelRemaingAmountDeadline, .top),
            Left(10),
            Width(UIScreen.main.bounds.width)
        ]
        
        labelRemaingAmountDeadline <- [
            CenterY(0),
            Left(0).to(labelRemainingAmountText, .left),
            Width(UIScreen.main.bounds.width/2)
        ]
        
        labelRemaingAmountMoney <- [
            Top(5).to(labelRemaingAmountDeadline, .bottom),
            Left(0).to(labelRemaingAmountDeadline, .left),
            Width(UIScreen.main.bounds.width-25)
        ]
        
        containerPieChart <- [
            Width(UIScreen.main.bounds.width-15),
            Top(0).to(lastContainer, .bottom),
            CenterX(0),
            Bottom(5)
        ]
    
        chart <- [
            Top(0),
            Left(0),
            Width().like(containerPieChart),
            Height().like(containerPieChart)
        ]
    
        addRecordButton <- [
            CenterY(0).to(labelRemainingAmountText),
            Right(10),
            Right(0)
        ]
    }
}

