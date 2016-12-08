//
//  FoodStatsViewController.swift
//  EatWell
//
//  Created by Timothy Van Ness on 12/6/16.
//  Copyright © 2016 Timothy Van Ness. All rights reserved.
//

import UIKit
import CoreData
import Charts

class FoodStatsViewController: UIViewController {
    
    static var food: Food? = nil

    var pieChart = PieChartView()
    let stat_names = ["Protein","Carbs","Fat"]
    let stat_colors = [UIColor(red:0.07, green:0.61, blue:0.60, alpha:1.0),
                       UIColor(red:0.35, green:0.73, blue:0.82, alpha:1.0),
                       UIColor(red:0.99, green:0.87, blue:0.35, alpha:1.0)]
    
    var views: [UIView] = []
    var labels: [UILabel] = []
    var tfs: [UITextField] = []
    var placeholders = ["Calories","Grams", "Protein", "Carbs", "Fat"]
    var units = ["C ","g "]
    
    var calView = UIView()
    var calLabel = UILabel()
    var calTextField = UITextField()
    
    var servView = UIView()
    var servLabel = UILabel()
    var servTextField = UITextField()
    
    var protView = UIView()
    var protLabel = UILabel()
    var protTextField = UITextField()
    
    var carbView = UIView()
    var carbLabel = UILabel()
    var carbTextField = UITextField()
    
    var fatView = UIView()
    var fatLabel = UILabel()
    var fatTextField = UITextField()
    
    var editNameView = UITextField()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        views = [calView,servView,protView,carbView,fatView]
        labels = [calLabel,servLabel,protLabel,carbLabel,fatLabel]
        tfs = [calTextField,servTextField,protTextField,carbTextField,fatTextField]
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editTapped))
        
        self.view.backgroundColor = UIColor.white
        
        pieChart.noDataText = "No Data for graph"
        
        setData()
        
        setViews()
        
        if FoodStatsViewController.food == nil {
            editTapped()
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        calTextField.endEditing(true)
        servTextField.endEditing(true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setData()
    }
    
    func setViews() {
        for i in [0,1,2,3,4] {
            views[i].translatesAutoresizingMaskIntoConstraints = false
            self.view.addSubview(views[i])
        
            if i == 0 || i == 2{
                views[i].leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
            } else {
                views[i].leadingAnchor.constraint(equalTo: views[i-1].trailingAnchor).isActive = true
            }
            if i < 2 {
                views[i].widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 1/2).isActive = true
                views[i].topAnchor.constraint(equalTo: pieChart.bottomAnchor, constant: 10).isActive = true
            } else {
                views[i].widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 1/3).isActive = true
                views[i].topAnchor.constraint(equalTo: views[0].bottomAnchor, constant: 10).isActive = true
            }
            views[i].heightAnchor.constraint(equalToConstant: self.view.frame.height/20).isActive = true
        
            if i == 0 {
                labels[i].text = units[i]
            } else {
                labels[i].text = units[1]
            }
            labels[i].textColor = UIColor.black
            labels[i].translatesAutoresizingMaskIntoConstraints = false
            views[i].addSubview(labels[i])
            
            labels[i].topAnchor.constraint(equalTo: views[i].topAnchor).isActive = true
            labels[i].trailingAnchor.constraint(equalTo: views[i].trailingAnchor, constant: -10).isActive = true
            labels[i].centerYAnchor.constraint(equalTo: views[i].centerYAnchor).isActive = true
        
            tfs[i].placeholder = placeholders[i]
            if i > 1{
                tfs[i].backgroundColor = stat_colors[i-2]
            }
            tfs[i].rightView = labels[i]
            tfs[i].textAlignment = .right
            tfs[i].rightViewMode = UITextFieldViewMode.always
            tfs[i].borderStyle = UITextBorderStyle.roundedRect
            tfs[i].adjustsFontSizeToFitWidth = true
            tfs[i].layer.borderWidth = 1
            tfs[i].layer.borderColor = UIColor(red:0.63, green:0.45, blue:0.64, alpha:1.0).cgColor
            tfs[i].layer.cornerRadius = 5
            tfs[i].keyboardType = UIKeyboardType.decimalPad
            tfs[i].translatesAutoresizingMaskIntoConstraints = false
            views[i].addSubview(tfs[i])
        
            tfs[i].topAnchor.constraint(equalTo: views[i].topAnchor).isActive = true
            tfs[i].leadingAnchor.constraint(equalTo: views[i].leadingAnchor, constant: 5).isActive = true
            tfs[i].trailingAnchor.constraint(equalTo: views[i].trailingAnchor, constant: -5).isActive = true
            tfs[i].centerYAnchor.constraint(equalTo: views[i].centerYAnchor).isActive = true
        }
        
        if let food = FoodStatsViewController.food {
            navigationItem.title = food.name
            for i in [0,1,2,3,4] {
                tfs[i].isEnabled = false
                tfs[i].isHighlighted = false
            }
            tfs[0].text = String(food.calories)
            tfs[1].text = String(food.weight)
            tfs[2].text = String(food.protein)
            tfs[3].text = String(food.carbs)
            tfs[4].text = String(food.fat)
        }

    }
    
    func findFood() {
        if let food = FoodStatsViewController.food {
            let appDel = UIApplication.shared.delegate as! AppDelegate
            let managedContext = appDel.persistentContainer.viewContext
            managedContext.refresh(food, mergeChanges: true)
            FoodStatsViewController.food = food
        }
    }
    
    func setData () {
        if let food = FoodStatsViewController.food {
            navigationItem.title = food.name
            let total_macros = food.carbs + food.protein + food.fat
            var percents: [Double] = [Double(food.protein / total_macros), Double(food.carbs / total_macros), Double(food.fat / total_macros)]
            
            var stats_vals: [PieChartDataEntry] = []
            var data_colors: [UIColor] = []
            for i in [0,1,2] {
                data_colors.append(stat_colors[i])
                stats_vals.append(PieChartDataEntry(value: percents[i], label: stat_names[i]))
            }
            
            let data_set = PieChartDataSet(values: stats_vals, label: nil)
            data_set.colors = data_colors
            data_set.drawValuesEnabled = false
            
            let data = PieChartData(dataSet: data_set)
            
            pieChart.data = data
            pieChart.drawEntryLabelsEnabled = false
            pieChart.usePercentValuesEnabled = true
            pieChart.drawHoleEnabled = false
            pieChart.chartDescription = nil
            pieChart.animate(xAxisDuration: 1.5, yAxisDuration: 1.5, easingOption: ChartEasingOption.easeOutExpo)
        }
        
        self.view.addSubview(pieChart)
        pieChart.translatesAutoresizingMaskIntoConstraints = false
        
        pieChart.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        pieChart.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 2/3).isActive = true
        pieChart.heightAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 2/3).isActive = true
    }
    
    func editTapped() {
        for i in [0,1,2,3,4] {
            tfs[i].isEnabled = true
            tfs[i].isHighlighted = true
        }
        editNameView.frame = CGRect(x: 0, y: 0, width: (self.navigationController?.navigationBar.frame.size.width)!/2, height: 21.0)
        editNameView.placeholder = "Name"
        editNameView.textColor = UIColor(red:0.63, green:0.45, blue:0.64, alpha:1.0)
        editNameView.borderStyle = UITextBorderStyle.roundedRect
        editNameView.adjustsFontSizeToFitWidth = true
        editNameView.layer.borderWidth = 1
        editNameView.layer.borderColor = UIColor(red:0.63, green:0.45, blue:0.64, alpha:1.0).cgColor
        editNameView.layer.cornerRadius = 5
        editNameView.textAlignment = .center
        if let food = FoodStatsViewController.food {
            editNameView.text = food.name
        }
        navigationItem.titleView = editNameView
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneTapped))
    }
    
    func doneTapped() {
        var vals: [String] = []
        var success = true
        for i in [0,1,2,3,4] {
            if let val = tfs[i].text {
                if val == "" {
                    success = false
                    break
                }
                vals.append(val)
            } else {
                success = false
            }
        }
        
        if editNameView.text == "" {
            success = false
        }
        
        if success {
            var changing_food: Food
            let appDel = UIApplication.shared.delegate as! AppDelegate
            let managedContext = appDel.persistentContainer.viewContext
            if FoodStatsViewController.food == nil {
                let entity = NSEntityDescription.entity(forEntityName: "Food", in: managedContext)
                changing_food = NSManagedObject(entity: entity!, insertInto: managedContext) as! Food
            } else {
                changing_food = FoodStatsViewController.food!
            }
            changing_food.name = editNameView.text
            changing_food.calories = Int32(vals[0]) ?? 0
            changing_food.weight = Float(vals[1]) ?? 0
            changing_food.protein = Float(vals[2]) ?? 0
            changing_food.carbs = Float(vals[3]) ?? 0
            changing_food.fat = Float(vals[4]) ?? 0
            changing_food.cpg = Float(changing_food.calories) / Float(changing_food.weight)
            do {
                try managedContext.save()
            } catch {
                fatalError("Failed to save new values: \(error)")
            }
            FoodStatsViewController.food = changing_food
            navigationItem.titleView = nil
            navigationItem.title = changing_food.name
            
            for i in [0,1,2,3,4] {
                tfs[i].isEnabled = false
                tfs[i].isHighlighted = false
            }
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editTapped))
            
            findFood()
            
            setData()
            setViews()
        }
        
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
