//
//  PlanStatsViewController.swift
//  EatWell
//
//  Created by Timothy Van Ness on 12/6/16.
//  Copyright © 2016 Timothy Van Ness. All rights reserved.
//

import UIKit
import CoreData
import Charts

class PlanStatsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, SearchViewControllerDelegate {
    
    static var plan: Plan? = nil
    var add_recipe: Recipe? = nil
    
    var pieChart = PieChartView()
    let stat_names = ["Protein","Carbs","Fat"]
    let stat_colors = [UIColor(red:0.07, green:0.61, blue:0.60, alpha:1.0),
                       UIColor(red:0.35, green:0.73, blue:0.82, alpha:1.0),
                       UIColor(red:0.99, green:0.87, blue:0.35, alpha:1.0)]
    
    var views: [UIView] = []
    var labels: [UILabel] = []
    var tfs: [UITextField] = []
    var placeholders = ["0","Days", "0", "0", "0"]
    var units = ["C ","Days ","g "]
    
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
    
    var mealsView = UILabel()
    
    var addButton: UIButton!
    
    var mealsTableView = UITableView()
    
    var recipes: [Recipe] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        views = [calView,servView,protView,carbView,fatView]
        labels = [calLabel,servLabel,protLabel,carbLabel,fatLabel]
        tfs = [calTextField,servTextField,protTextField,carbTextField,fatTextField]
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editTapped))
        
        self.view.backgroundColor = UIColor.white
        
        pieChart.noDataText = "No Data for graph"
        
        findPlan()
        
        setData()
        
        setViews()
        
        mealsTableView.delegate = self
        mealsTableView.dataSource = self
        mealsTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        mealsTableView.tableFooterView = UIView()
        mealsTableView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(mealsTableView)
        
        mealsTableView.topAnchor.constraint(equalTo: mealsView.bottomAnchor).isActive = true
        mealsTableView.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        mealsTableView.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 1/3).isActive = true
        
        if PlanStatsViewController.plan == nil {
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
    
    func searchViewControllerResponse(recipe: Recipe!)
    {
        self.add_recipe = recipe
        if let recipe = self.add_recipe {
            recipes.append(recipe)
            tfs[0].text = String(Int(tfs[0].text!)! + recipe.calories)
            tfs[2].text = String(Float(tfs[2].text!)! + recipe.protein)
            tfs[3].text = String(Float(tfs[3].text!)! + recipe.carbs)
            tfs[4].text = String(Float(tfs[4].text!)! + recipe.fat)
        }
        findPlan()
        setData()
        mealsTableView.reloadData()
    }
    
    func searchViewControllerResponse(food: Food!) {
        
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
            
            if i < 2 {
                labels[i].text = units[i]
            } else {
                labels[i].text = units[2]
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
        
        for i in [0,2,3,4] {
            tfs[i].isEnabled = false
            tfs[i].isHighlighted = false
            
            tfs[0].text = "0"
            tfs[2].text = "0"
            tfs[3].text = "0"
            tfs[4].text = "0"
        }
        
        if let plan = PlanStatsViewController.plan {
            navigationItem.title = plan.name
            
            if let recp_meals = plan.meals {
                recipes = recp_meals.allObjects as! [Recipe]
            }
            
            tfs[1].isEnabled = false
            tfs[1].isHighlighted = false
            
            tfs[0].text = String(plan.calories)
            tfs[1].text = String(plan.days)
            tfs[2].text = String(plan.protein)
            tfs[3].text = String(plan.carbs)
            tfs[4].text = String(plan.fat)
        }
        
        mealsView.text = " Meals"
        mealsView.font = UIFont.boldSystemFont(ofSize: 18)
        mealsView.textAlignment = .left
        mealsView.backgroundColor = UIColor(red:0.63, green:0.45, blue:0.64, alpha:1.0)
        mealsView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(mealsView)
        
        mealsView.topAnchor.constraint(equalTo: tfs[4].bottomAnchor, constant: 10).isActive = true
        mealsView.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        mealsView.heightAnchor.constraint(equalToConstant: self.view.frame.height/20).isActive = true
        mealsView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        
        
    }
    
    func findPlan() {
        if let plan = PlanStatsViewController.plan {
            let appDel = UIApplication.shared.delegate as! AppDelegate
            let managedContext = appDel.persistentContainer.viewContext
            managedContext.refresh(plan, mergeChanges: true)
            PlanStatsViewController.plan = plan
        }
    }
    
    func setData () {
        if let plan = PlanStatsViewController.plan {
            navigationItem.title = plan.name
            let total_macros = plan.carbs + plan.protein + plan.fat
            var percents: [Double] = [Double(plan.protein / total_macros), Double(plan.carbs / total_macros), Double(plan.fat / total_macros)]
            
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
        tfs[1].isEnabled = true
        tfs[1].isHighlighted = true
        
        editNameView.frame = CGRect(x: 0, y: 0, width: (self.navigationController?.navigationBar.frame.size.width)!/2, height: 21.0)
        editNameView.placeholder = "Name"
        editNameView.textColor = UIColor(red:0.63, green:0.45, blue:0.64, alpha:1.0)
        editNameView.borderStyle = UITextBorderStyle.roundedRect
        editNameView.adjustsFontSizeToFitWidth = true
        editNameView.layer.borderWidth = 1
        editNameView.layer.borderColor = UIColor(red:0.63, green:0.45, blue:0.64, alpha:1.0).cgColor
        editNameView.layer.cornerRadius = 5
        editNameView.textAlignment = .center
        if let plan = PlanStatsViewController.plan {
            editNameView.text = plan.name
        }
        navigationItem.titleView = editNameView
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneTapped))
        
        addButton = UIButton(type: UIButtonType.contactAdd)
        addButton.addTarget(self, action: #selector(addPressed), for: .touchUpInside)
        addButton.tintColor = UIColor.white
        addButton.translatesAutoresizingMaskIntoConstraints = false
        addButton.tag = 3
        self.view.addSubview(addButton)
        
        addButton.centerYAnchor.constraint(equalTo: mealsView.centerYAnchor).isActive = true
        addButton.trailingAnchor.constraint(equalTo: mealsView.trailingAnchor, constant: -5).isActive = true
    }
    
    func addPressed() {
        SearchTableViewController.searchIndex = 1
        let searchVC = SearchTableViewController()
        searchVC.delegate = self
        self.navigationController?.pushViewController(searchVC, animated: true)
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
        
        if editNameView.text == "" || recipes.count == 0 {
            success = false
        }
        
        if success {
            var changing_plan: Plan
            let appDel = UIApplication.shared.delegate as! AppDelegate
            let managedContext = appDel.persistentContainer.viewContext
            if PlanStatsViewController.plan == nil {
                let entity = NSEntityDescription.entity(forEntityName: "Plan", in: managedContext)
                changing_plan = NSManagedObject(entity: entity!, insertInto: managedContext) as! Plan
            } else {
                changing_plan = PlanStatsViewController.plan!
            }
            changing_plan.name = editNameView.text
            changing_plan.calories = Int32(vals[0]) ?? 0
            changing_plan.days = Int32(vals[1]) ?? 1
            changing_plan.protein = Float(vals[2]) ?? 0
            changing_plan.carbs = Float(vals[3]) ?? 0
            changing_plan.fat = Float(vals[4]) ?? 0
            changing_plan.cpd = Float(changing_plan.calories) / Float(changing_plan.days)
            let meals = changing_plan.mutableSetValue(forKey: "meals")
            for recipe in recipes {
                meals.add(recipe)
            }
            do {
                try managedContext.save()
            } catch {
                fatalError("Failed to save new values: \(error)")
            }
            PlanStatsViewController.plan = changing_plan
            navigationItem.titleView = nil
            navigationItem.title = changing_plan.name
            
            tfs[1].isEnabled = false
            tfs[1].isHighlighted = false
            
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editTapped))
            
            if let viewWithTag = mealsView.viewWithTag(3) {
                viewWithTag.removeFromSuperview()
            }
            
            findPlan()
            
            setData()
            setViews()
        }
        
    }
    
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = recipes[indexPath.row].name
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .normal, title: "Delete") { action, index in
            let appDel = UIApplication.shared.delegate as! AppDelegate
            let managedContext = appDel.persistentContainer.viewContext
            let recipe = self.recipes[indexPath.row]
            self.recipes.remove(at: indexPath.row)
            let cur_cal = Int(self.tfs[0].text!)
            self.tfs[0].text = String(Int(cur_cal!) - Int(recipe.calories))
            self.tfs[2].text = String(Float(self.tfs[2].text!)! - recipe.protein)
            self.tfs[3].text = String(Float(self.tfs[3].text!)! - recipe.carbs)
            self.tfs[4].text = String(Float(self.tfs[4].text!)! - recipe.fat)
            if let changing_plan = PlanStatsViewController.plan {
                changing_plan.calories = Int32(self.tfs[0].text!)!
                changing_plan.protein = Float(self.tfs[2].text!)!
                changing_plan.carbs = Float(self.tfs[3].text!)!
                changing_plan.fat = Float(self.tfs[4].text!)!
                changing_plan.cpd = Float(changing_plan.calories) / Float(changing_plan.days)
                let meals = changing_plan.mutableSetValue(forKeyPath: "meals")
                meals.remove(recipe)
                do {
                    try managedContext.save()
                } catch {
                    fatalError("Failed to delete relationship: \(error)")
                }
            }
            self.findPlan()
            self.mealsTableView.reloadData()
        }
        delete.backgroundColor = UIColor.red
        return [delete]
    }
    
    
}
