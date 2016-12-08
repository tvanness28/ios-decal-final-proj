//
//  MainTableViewController.swift
//  EatWell
//
//  Created by Timothy Van Ness on 12/6/16.
//  Copyright © 2016 Timothy Van Ness. All rights reserved.
//

import UIKit
import Charts
import CoreData

class MainTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var items = ["Plan", "Recipe", "Food"]
    var tableView: UITableView = UITableView()
    var addView = UIView()
    var addButton = UIButton()
    var plans:[Plan] = []
    var recipes:[Recipe] = []
    var foods:[Food] = []
    let stat_colors = [UIColor(red:0.07, green:0.61, blue:0.60, alpha:1.0),
                       UIColor(red:0.35, green:0.73, blue:0.82, alpha:1.0),
                       UIColor(red:0.99, green:0.87, blue:0.35, alpha:1.0)]
    
    static var segCont_index = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateData()
        
        tableView.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width , height: self.view.bounds.height * 0.8)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(MainTableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.backgroundColor = UIColor.white
        tableView.tableFooterView = UIView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(tableView)
        self.view.tag = 1
        
        addButton.setTitle("Add \(items[MainTableViewController.segCont_index])", for: UIControlState.normal)
        addButton.addTarget(self, action: #selector(addPressed), for: .touchUpInside)
        addView.addSubview(addButton)
        addButton.translatesAutoresizingMaskIntoConstraints = false
        
        addButton.centerYAnchor.constraint(equalTo: addView.centerYAnchor).isActive = true
        addButton.centerXAnchor.constraint(equalTo: addView.centerXAnchor).isActive = true
        
        addView.frame = CGRect(x: 0, y: self.view.bounds.height * 0.8, width: self.view.bounds.width , height: self.view.bounds.height * 0.11)
        addView.backgroundColor = UIColor(red:0.63, green:0.45, blue:0.64, alpha:1.0)
        self.view.addSubview(addView)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateData()
        tableView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        updateData()
        tableView.reloadData()
    }
//
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
//        updateData()
        tableView.reloadData()
    }
    
    func setBarData (_ protein: Float, _ carbs: Float, _ fat: Float, _ contentView: MainTableViewCell!) {
        let barChart = HorizontalBarChartView()
        barChart.tag = 2
        var count = 0
//        if let food = inputFood {
            let total_macros = carbs + protein + fat
            var percents: [Double] = [Double(protein / total_macros), Double(carbs / total_macros), Double(fat / total_macros)]
            
            var stats_vals: [BarChartDataEntry] = []
            var data_colors: [UIColor] = []
            for i in [0,1,2] {
                if percents[i] != 0.0 {
                    count += 1
                    stats_vals.append(BarChartDataEntry(x: Double(i), y: percents[i]))
                } else {
                    stats_vals.append(BarChartDataEntry(x: Double(i), y: 0.01))
                }
                data_colors.append(stat_colors[i])
            }
            
            let data_set = BarChartDataSet(values: stats_vals, label: nil)
            data_set.colors = data_colors
            data_set.drawValuesEnabled = false
            
            let data = BarChartData(dataSet: data_set)
            
            barChart.data = data
            barChart.legend.enabled = false
            barChart.chartDescription = nil
            barChart.scaleXEnabled = false
            barChart.scaleYEnabled = false
            barChart.drawValueAboveBarEnabled = false
            barChart.drawGridBackgroundEnabled = false
            barChart.xAxis.drawLabelsEnabled = false
            barChart.xAxis.drawAxisLineEnabled = false
            barChart.xAxis.drawGridLinesEnabled = false
            barChart.leftAxis.drawGridLinesEnabled = false
            barChart.leftAxis.drawAxisLineEnabled = false
            barChart.leftAxis.drawLabelsEnabled = false
            barChart.rightAxis.drawLabelsEnabled = false
            barChart.rightAxis.drawAxisLineEnabled = false
            barChart.rightAxis.drawGridLinesEnabled = false
            barChart.isUserInteractionEnabled = false
//            barChart.animate(xAxisDuration: 1.5, yAxisDuration: 1.5, easingOption: ChartEasingOption.easeOutExpo)
//        }
        
        if let viewWithTag = contentView.viewWithTag(2) {
            viewWithTag.removeFromSuperview()
        }
        contentView.addSubview(barChart)
        barChart.translatesAutoresizingMaskIntoConstraints = false
        
        barChart.noDataText = "No Data for this thing"
        if count == 3 {
            barChart.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5).isActive = true
        } else {
            barChart.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: -5).isActive = true
        }
        barChart.topAnchor.constraint(equalTo: contentView.label.bottomAnchor).isActive = true
        barChart.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        barChart.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.5).isActive = true
    }
    
    func updateData() {
        let appDel = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDel.persistentContainer.viewContext
        
        switch MainTableViewController.segCont_index {
        case 0:
            let fetchRequest:NSFetchRequest<Plan> = Plan.fetchRequest()
            do {
                plans = try managedContext.fetch(fetchRequest)
            } catch {
                fatalError("Failed to fetch \(items[MainTableViewController.segCont_index]): \(error)")
            }
            break
        case 1:
            let fetchRequest:NSFetchRequest<Recipe> = Recipe.fetchRequest()
            do {
                recipes = try managedContext.fetch(fetchRequest)
            } catch {
                fatalError("Failed to fetch \(items[MainTableViewController.segCont_index]): \(error)")
            }
            break
        case 2:
            let fetchRequest:NSFetchRequest<Food> = Food.fetchRequest()
            do {
                foods = try managedContext.fetch(fetchRequest)
            } catch {
                fatalError("Failed to fetch \(items[MainTableViewController.segCont_index]): \(error)")
            }
            break
        default:
            break
        }
//        self.tableView.reloadData()
    }
    
    func addPressed(_sender: UIButton!) {
        switch MainTableViewController.segCont_index {
        case 0:
            break
        case 1:
            RecipeStatsViewController.recipe = nil
            self.navigationController?.pushViewController(RecipeStatsViewController(), animated: true)
            break
        case 2:
            FoodStatsViewController.food = nil
            self.navigationController?.pushViewController(FoodStatsViewController(), animated: true)
            break
        default:
            break
        }
    }
    
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        updateData()
        switch MainTableViewController.segCont_index {
        case 0:
            return plans.count
        case 1:
            return recipes.count
        case 2:
            return foods.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: MainTableViewCell? = nil
//        updateData()
        switch MainTableViewController.segCont_index {
        case 0:
            if (plans.count > 0) {
                let plan = plans[indexPath.row]
                cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? MainTableViewCell
                cell?.label.text = plan.name
            }
            break
        case 1:
            if (recipes.count > 0) {
                let recipe = recipes[indexPath.row]
                cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? MainTableViewCell
                cell?.label.text = recipe.name
                cell?.calLabel.text = String(format: "~%.1f C/serving", recipe.cps)
                setBarData(recipe.protein, recipe.carbs, recipe.fat, cell)
            }
            break
        case 2:
            if (foods.count > 0) {
                let food = foods[indexPath.row]
                cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? MainTableViewCell
                cell?.label.text = food.name
                cell?.calLabel.text = String(format: "~%.1f C/gram", food.cpg)
                setBarData(food.protein, food.carbs, food.fat, cell)
            }
            break
        default:
            break
        }
        
        return cell!
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        updateData()
        switch MainTableViewController.segCont_index {
        case 0:
            if (plans.count > 0) {
                let plan = plans[indexPath.row]
            }
            break
        case 1:
            if (recipes.count > 0) {
                let recipe = recipes[indexPath.row]
                RecipeStatsViewController.recipe = recipe
                self.navigationController?.pushViewController(RecipeStatsViewController(), animated: true)
            }
            break
        case 2:
            if (foods.count > 0) {
                let food = foods[indexPath.row]
                FoodStatsViewController.food = food
                self.navigationController?.pushViewController(FoodStatsViewController(), animated: true)
            }
            break
        default:
            break
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.view.frame.width / 4
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .normal, title: "Delete") { action, index in
            let appDel = UIApplication.shared.delegate as! AppDelegate
            let managedContext = appDel.persistentContainer.viewContext
            switch MainTableViewController.segCont_index {
            case 0:
                managedContext.delete(self.plans[indexPath.row] as NSManagedObject)
                do {
                    try managedContext.save()
                } catch {
                    fatalError("Failed to delete values: \(error)")
                }
                break
            case 1:
                managedContext.delete(self.recipes[indexPath.row] as NSManagedObject)
                do {
                    try managedContext.save()
                } catch {
                    fatalError("Failed to delete values: \(error)")
                }
                break
            case 2:
                managedContext.delete(self.foods[indexPath.row] as NSManagedObject)
                do {
                    try managedContext.save()
                } catch {
                    fatalError("Failed to delete values: \(error)")
                }
                break
            default:
                break
            }
            self.updateData()
            self.tableView.reloadData()
        }
        delete.backgroundColor = UIColor.red
        return [delete]
    }
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    
}
