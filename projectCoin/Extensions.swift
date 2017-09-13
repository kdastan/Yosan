//
//  Extensions.swift
//  projectCoin
//
//  Created by Apple on 18.07.17.
//  Copyright © 2017 kumardastan. All rights reserved.
//

import UIKit
import FSCalendar
import Charts
import Instructions

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! RadioTableViewCell
        cell.label.text = categories[indexPath.row]
        return cell
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        tableView.cellForRow(at: indexPath)?.setSelected(true, animated: true)
        selectedIndex = indexPath.row
        return indexPath
    }
    func tableView(_ tableView: UITableView, willDeselectRowAt indexPath: IndexPath) -> IndexPath? {
        tableView.cellForRow(at: indexPath)?.setSelected(false, animated: true)
        return indexPath
    }
}

extension SetUpViewController:  FSCalendarDelegate {
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yy"
        let seconds = Int(date.timeIntervalSinceNow)
        dayInterval = seconds/60/60/24
        let resultToday = formatter.string(from: Date()) //Today date
        selectedDate = formatter.string(from: date)
        if selectedDate != resultToday {
            dayInterval += 2
        } else {
            dayInterval = 0
        }
        if dayInterval < 0 {
            calendar.deselect(date)
        }
        
    }
}

extension ViewController: ChartViewDelegate {
    
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        let track = ["Transport", "Food", "Entertainment", "Products", "Other"]
        
        chart.centerText = "\(track[Int(highlight.x)]) \n \(Int(highlight.y)) \(currentCurrency)"
    }
    
    func chartValueNothingSelected(_ chartView: ChartViewBase) {
        let myAttribute = [ NSFontAttributeName: UIFont(name: "Helvetica", size: 18.0)! ]
        let myAttrString = NSAttributedString(string: "Today", attributes: myAttribute)
        
        chart.centerAttributedText = myAttrString
    }
}

extension SetUpViewController: CoachMarksControllerDataSource {
    
    func numberOfCoachMarks(for coachMarksController: CoachMarksController) -> Int {
        return 3
    }
    
    func coachMarksController(_ coachMarksController: CoachMarksController, coachMarkAt index: Int) -> CoachMark {
        return coachMarksController.helper.makeCoachMark(for: arr[index])
    }
    
    func coachMarksController(_ coachMarksController: CoachMarksController, coachMarkViewsAt index: Int, madeFrom coachMark: CoachMark) -> (bodyView: CoachMarkBodyView, arrowView: CoachMarkArrowView?) {
        
        let coachViews = coachMarksController.helper.makeDefaultCoachViews(withArrow: true, arrowOrientation: coachMark.arrowOrientation)
        
        coachViews.bodyView.hintLabel.text = descriptionText[index]
        coachViews.bodyView.nextLabel.text = "Ok!"
        
        return (bodyView: coachViews.bodyView, arrowView: coachViews.arrowView)
    }
    
}

extension ViewController: CoachMarksControllerDataSource {

    func numberOfCoachMarks(for coachMarksController: CoachMarksController) -> Int {
        return 7
    }
    
    func coachMarksController(_ coachMarksController: CoachMarksController, coachMarkAt index: Int) -> CoachMark {
        return coachMarksController.helper.makeCoachMark(for: arr[index])
    }
    
    func coachMarksController(_ coachMarksController: CoachMarksController, coachMarkViewsAt index: Int, madeFrom coachMark: CoachMark) -> (bodyView: CoachMarkBodyView, arrowView: CoachMarkArrowView?) {
        
        let coachViews = coachMarksController.helper.makeDefaultCoachViews(withArrow: true, arrowOrientation: coachMark.arrowOrientation)
        
        coachViews.bodyView.hintLabel.text = arrOfDescription[index]
        coachViews.bodyView.nextLabel.text = "Ok!"
        
        return (bodyView: coachViews.bodyView, arrowView: coachViews.arrowView)
    }

}
private var firstLaunch : Bool = false

extension UIApplication {
    
    static func isFirstLaunch() -> Bool {
        let firstLaunchFlag = "isFirstLaunchFlag"
        let isFirstLaunch = UserDefaults.standard.string(forKey: firstLaunchFlag) == nil
        if (isFirstLaunch) {
            firstLaunch = isFirstLaunch
            UserDefaults.standard.set("false", forKey: firstLaunchFlag)
            UserDefaults.standard.synchronize()
        }
        return firstLaunch || isFirstLaunch
    }
}
