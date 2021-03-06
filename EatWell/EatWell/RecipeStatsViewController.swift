//
//  RecipeStatsViewController.swift
//  EatWell
//
//  Created by Timothy Van Ness on 12/6/16.
//  Copyright © 2016 Timothy Van Ness. All rights reserved.
//

import UIKit
import CoreData
import Charts

class RecipeStatsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, SearchViewControllerDelegate {
    
    static var recipe: Recipe? = nil
    var add_food: Food? = nil
    
    var pieChart = PieChartView()
    let stat_names = ["Protein","Carbs","Fat"]
    let stat_colors = [UIColor(red:0.07, green:0.61, blue:0.60, alpha:1.0),
                       UIColor(red:0.35, green:0.73, blue:0.82, alpha:1.0),
                       UIColor(red:0.99, green:0.87, blue:0.35, alpha:1.0)]
    
    var views: [UIView] = []
    var labels: [UILabel] = []
    var tfs: [UITextField] = []
    var placeholders = ["0","Servings", "0", "0", "0"]
    var units = ["C ","Servings ","g "]
    
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
    
    var ingredientsView = UILabel()
    
    var addButton: UIButton!
    
    var ingredientsTableView = UITableView()
    
    var recipe_ingreds: [RecipeIngredient] = []
    
    var foods: [Food] = []
    var food_amounts: [Float] = []

    var isEditTapped: Bool = false
    
    var init_graph: Bool = true
    
    class subclassedUITextField: UITextField {
        var index: Int!
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        views = [calView,servView,protView,carbView,fatView]
        labels = [calLabel,servLabel,protLabel,carbLabel,fatLabel]
        tfs = [calTextField,servTextField,protTextField,carbTextField,fatTextField]
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editTapped))
        
        self.view.backgroundColor = UIColor.white
        
        pieChart.noDataText = "No Data for graph"
        
        findRecipe()
        
        setData()
        init_graph = false
        
        setViews()
        
        ingredientsTableView.delegate = self
        ingredientsTableView.dataSource = self
        ingredientsTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        ingredientsTableView.tableFooterView = UIView()
        ingredientsTableView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(ingredientsTableView)
        
        ingredientsTableView.topAnchor.constraint(equalTo: ingredientsView.bottomAnchor).isActive = true
        ingredientsTableView.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        ingredientsTableView.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 1/3).isActive = true

        if RecipeStatsViewController.recipe == nil {
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
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    func searchViewControllerResponse(food: Food!)
    {
        self.add_food = food
        if let food = self.add_food {
            foods.append(food)
            food_amounts.append(food.weight)
            let r_i: RecipeIngredient
            let appDel = UIApplication.shared.delegate as! AppDelegate
            let managedContext = appDel.persistentContainer.viewContext
            let entity = NSEntityDescription.entity(forEntityName: "RecipeIngredient", in: managedContext)
            r_i = NSManagedObject(entity: entity!, insertInto: managedContext) as! RecipeIngredient
            r_i.amount = food.weight
            r_i.ingredient = food
            recipe_ingreds.append(r_i)
            tfs[0].text = String(Int(tfs[0].text!)! + food.calories)
            tfs[2].text = String(Float(tfs[2].text!)! + food.protein)
            tfs[3].text = String(Float(tfs[3].text!)! + food.carbs)
            tfs[4].text = String(Float(tfs[4].text!)! + food.fat)
        }
        findRecipe()
        setData()
        ingredientsTableView.reloadData()
    }
    
    func searchViewControllerResponse(recipe: Recipe!) {
        
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
        
        if let recipe = RecipeStatsViewController.recipe {
            navigationItem.title = recipe.name
    
            if let recp_ingredients = recipe.recipeingredients {
                foods = []
                food_amounts = []
                recipe_ingreds = recp_ingredients.allObjects as! [RecipeIngredient]
                for recipe_ingred in recipe_ingreds {
                    foods.append(recipe_ingred.ingredient!)
                    food_amounts.append(recipe_ingred.amount)
                }
            }
            
            tfs[1].isEnabled = false
            tfs[1].isHighlighted = false
            
            tfs[0].text = String(recipe.calories)
            tfs[1].text = String(recipe.servings)
            tfs[2].text = String(recipe.protein)
            tfs[3].text = String(recipe.carbs)
            tfs[4].text = String(recipe.fat)
        }
        
        ingredientsView.text = " Ingredients"
        ingredientsView.font = UIFont.boldSystemFont(ofSize: 18)
        ingredientsView.textAlignment = .left
        ingredientsView.backgroundColor = UIColor(red:0.63, green:0.45, blue:0.64, alpha:1.0)
        ingredientsView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(ingredientsView)
        
        ingredientsView.topAnchor.constraint(equalTo: tfs[4].bottomAnchor, constant: 10).isActive = true
        ingredientsView.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        ingredientsView.heightAnchor.constraint(equalToConstant: self.view.frame.height/20).isActive = true
        ingredientsView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        
        
    }
    
    func findRecipe() {
        if let recipe = RecipeStatsViewController.recipe {
            let appDel = UIApplication.shared.delegate as! AppDelegate
            let managedContext = appDel.persistentContainer.viewContext
            managedContext.refresh(recipe, mergeChanges: true)
            RecipeStatsViewController.recipe = recipe
        }
    }
    
    func setData () {
        if let recipe = RecipeStatsViewController.recipe {
            navigationItem.title = recipe.name
            let total_macros = recipe.carbs + recipe.protein + recipe.fat
            var percents: [Double] = [Double(recipe.protein / total_macros), Double(recipe.carbs / total_macros), Double(recipe.fat / total_macros)]
            
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
//            if init_graph {
                pieChart.animate(xAxisDuration: 1.5, yAxisDuration: 1.5, easingOption: ChartEasingOption.easeOutExpo)
//            }
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
        if let recipe = RecipeStatsViewController.recipe {
            editNameView.text = recipe.name
        }
        navigationItem.titleView = editNameView
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneTapped))
        
        addButton = UIButton(type: UIButtonType.contactAdd)
        addButton.addTarget(self, action: #selector(addPressed), for: .touchUpInside)
        addButton.tintColor = UIColor.white
        addButton.translatesAutoresizingMaskIntoConstraints = false
        addButton.tag = 3
        self.view.addSubview(addButton)
        
        addButton.centerYAnchor.constraint(equalTo: ingredientsView.centerYAnchor).isActive = true
        addButton.trailingAnchor.constraint(equalTo: ingredientsView.trailingAnchor, constant: -5).isActive = true
        
        isEditTapped = true
        ingredientsTableView.reloadData()
    }
    
    func addPressed() {
        SearchTableViewController.searchIndex = 2
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
        
        if editNameView.text == "" || recipe_ingreds.count == 0 {
            success = false
        }
                
        if success {
            var changing_recipe: Recipe
            let appDel = UIApplication.shared.delegate as! AppDelegate
            let managedContext = appDel.persistentContainer.viewContext
            if RecipeStatsViewController.recipe == nil {
                let entity = NSEntityDescription.entity(forEntityName: "Recipe", in: managedContext)
                changing_recipe = NSManagedObject(entity: entity!, insertInto: managedContext) as! Recipe
            } else {
                changing_recipe = RecipeStatsViewController.recipe!
            }
            changing_recipe.name = editNameView.text
            changing_recipe.calories = Int32(vals[0])  ?? 0
            changing_recipe.servings = Float(vals[1]) ?? 1
            changing_recipe.protein = Float(vals[2]) ?? 0
            changing_recipe.carbs = Float(vals[3]) ?? 0
            changing_recipe.fat = Float(vals[4]) ?? 0
            changing_recipe.cps = Float(changing_recipe.calories) / Float(changing_recipe.servings)
            let ingredients = changing_recipe.mutableSetValue(forKey: "recipeingredients")
            print(foods.count)
            print(recipe_ingreds.count)
            for i in 0...foods.count-1 {
                recipe_ingreds[i].amount = food_amounts[i]
                recipe_ingreds[i].ingredient = foods[i]
                ingredients.add(recipe_ingreds[i])
            }
            do {
                try managedContext.save()
            } catch {
                fatalError("Failed to save new values: \(error)")
            }
            RecipeStatsViewController.recipe = changing_recipe
            navigationItem.titleView = nil
            navigationItem.title = changing_recipe.name
            
            tfs[1].isEnabled = false
            tfs[1].isHighlighted = false
            
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editTapped))
            
            if let viewWithTag = ingredientsView.viewWithTag(3) {
                viewWithTag.removeFromSuperview()
            }
            
            findRecipe()
            
            setData()
            setViews()
            isEditTapped = false
            ingredientsTableView.reloadData()
        }
        
    }
    
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return foods.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        
//        let amount = UILabel()
//        amount.text = String(format: "%.1f g", food_amounts[indexPath.row])
//        amount.tag = 6
//        amount.translatesAutoresizingMaskIntoConstraints = false
//        cell.addSubview(amount)
//        
//        amount.trailingAnchor.constraint(equalTo: cell.trailingAnchor, constant: -5).isActive = true
//        amount.centerYAnchor.constraint(equalTo: cell.centerYAnchor).isActive = true
        
        if isEditTapped {
            if let viewWithTag = cell.viewWithTag(6) {
                viewWithTag.removeFromSuperview()
            }
            
            let amountTF = subclassedUITextField()
            amountTF.placeholder = "0.0"
            amountTF.tag = 5
            if indexPath.row < food_amounts.count {
                amountTF.text = String(format: "%.1f", food_amounts[indexPath.row])
            }
            let gramLabel = UILabel()
            gramLabel.text = " g"
            cell.addSubview(gramLabel)
            amountTF.rightView = gramLabel
            amountTF.textAlignment = .right
            amountTF.rightViewMode = UITextFieldViewMode.always
            amountTF.borderStyle = UITextBorderStyle.roundedRect
            amountTF.adjustsFontSizeToFitWidth = true
            amountTF.layer.borderWidth = 1
            amountTF.layer.borderColor = UIColor(red:0.63, green:0.45, blue:0.64, alpha:1.0).cgColor
            amountTF.layer.cornerRadius = 5
            amountTF.keyboardType = UIKeyboardType.decimalPad
            amountTF.addTarget(self, action: #selector(amountChanged), for: .editingDidEnd)
            amountTF.index = indexPath.row
            amountTF.translatesAutoresizingMaskIntoConstraints = false
            cell.addSubview(amountTF)
            
            amountTF.trailingAnchor.constraint(equalTo: cell.trailingAnchor, constant: -5).isActive = true
            amountTF.centerYAnchor.constraint(equalTo: cell.centerYAnchor).isActive = true
//            let stepper = subclassedUIStepper()
//            stepper.autorepeat = true
//            stepper.index = indexPath.row
//            stepper.cell = cell
//            stepper.tag = 5
//            stepper.stepValue = 0.1
//            stepper.value = Double(food_amounts[indexPath.row])
//            stepper.translatesAutoresizingMaskIntoConstraints = false
//            stepper.addTarget(self, action: #selector(stepperValueChanged), for: UIControlEvents.allTouchEvents)
//            cell.addSubview(stepper)
//        
//            stepper.trailingAnchor.constraint(equalTo: amount.leadingAnchor, constant: -5).isActive = true
//            stepper.centerYAnchor.constraint(equalTo: cell.centerYAnchor).isActive = true
        } else {
            if let viewWithTag = cell.viewWithTag(5) {
                viewWithTag.removeFromSuperview()
            }

            let amount = UILabel()
            amount.text = String(format: "%.1f g", food_amounts[indexPath.row])
            amount.tag = 6
            amount.translatesAutoresizingMaskIntoConstraints = false
            cell.addSubview(amount)
            
            amount.trailingAnchor.constraint(equalTo: cell.trailingAnchor, constant: -5).isActive = true
            amount.centerYAnchor.constraint(equalTo: cell.centerYAnchor).isActive = true
        }
        
        cell.textLabel?.text = foods[indexPath.row].name
        
        return cell
    }
    
    func amountChanged(sender: subclassedUITextField) {
        if let new_amount = sender.text {
//            label.text = String(format: "%.1f g", Double(sender.value).description)
            food_amounts[(sender.index)!] = Float(new_amount)!
        
        
            var cur_cals: Float = 0.0
            var cur_prot: Float = 0.0
            var cur_carbs: Float = 0.0
            var cur_fat: Float = 0.0
            for i in 0...foods.count - 1 {
                let food = foods[i]
                let food_amount = food_amounts[i]
                cur_cals += (Float(food.calories) * food_amount) / food.weight
                cur_prot += (food.protein * food_amount) / food.weight
                cur_carbs += (food.carbs * food_amount) / food.weight
                cur_fat += (food.fat * food_amount) / food.weight
            }
            tfs[0].text = String(format: "%.0f", cur_cals)
            tfs[2].text = String(format: "%.1f", cur_prot)
            tfs[3].text = String(format: "%.1f", cur_carbs)
            tfs[4].text = String(format: "%.1f", cur_fat)
        
            setData()
        }
        sender.endEditing(true)
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .normal, title: "Delete") { action, index in
            let appDel = UIApplication.shared.delegate as! AppDelegate
            let managedContext = appDel.persistentContainer.viewContext
            let food = self.foods[indexPath.row]
            self.foods.remove(at: indexPath.row)
            let food_amount = self.food_amounts[indexPath.row]
            self.food_amounts.remove(at: indexPath.row)
            let recp_ingrd = self.recipe_ingreds[indexPath.row]
            self.recipe_ingreds.remove(at: indexPath.row)
            let cur_cal = Int(self.tfs[0].text!)
            self.tfs[0].text = String(Int(cur_cal!) - Int((Float(food.calories) * food_amount) / food.weight))
            self.tfs[2].text = String(Float(self.tfs[2].text!)! - ((food.protein * food_amount) / food.weight))
            self.tfs[3].text = String(Float(self.tfs[3].text!)! - ((food.carbs * food_amount) / food.weight))
            self.tfs[4].text = String(Float(self.tfs[4].text!)! - ((food.fat * food_amount) / food.weight))
            if let changing_recipe = RecipeStatsViewController.recipe {
                changing_recipe.calories = Int32(self.tfs[0].text!)!
                changing_recipe.protein = Float(self.tfs[2].text!)!
                changing_recipe.carbs = Float(self.tfs[3].text!)!
                changing_recipe.fat = Float(self.tfs[4].text!)!
                changing_recipe.cps = Float(changing_recipe.calories) / Float(changing_recipe.servings)
                let ingredients = changing_recipe.mutableSetValue(forKeyPath: "recipeingredients")
                ingredients.remove(recp_ingrd)
                do {
                    try managedContext.save()
                } catch {
                    fatalError("Failed to delete relationship: \(error)")
                }
            }
            self.findRecipe()
            self.ingredientsTableView.reloadData()
        }
        delete.backgroundColor = UIColor.red
        return [delete]
    }

    
}
