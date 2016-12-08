//
//  FoodEditViewController.swift
//  EatWell
//
//  Created by Timothy Van Ness on 12/6/16.
//  Copyright © 2016 Timothy Van Ness. All rights reserved.
//

import UIKit
import CoreData

class FoodEditViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var tableView = UITableView()
    let tf_name = UITextField()
    let tf_serv = UITextField()
    let tf_cal = UITextField()
    let tf_prot = UITextField()
    let tf_carb = UITextField()
    let tf_fat = UITextField()

    static var food:Food? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.white
        if FoodEditViewController.food == nil {
            navigationItem.title = "Create Food"
        } else {
            navigationItem.title = "Edit Food"
        }
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.plain, target: self, action: #selector(doneTapped))
        
        self.view.frame = CGRect(x: 0, y: self.view.bounds.height * 0.1, width: self.view.bounds.width, height: self.view.bounds.height * 0.95)
        
        tableView.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width , height: self.view.bounds.height * 0.85)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.backgroundColor = UIColor.white
        tableView.tableFooterView = UIView()
        self.view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        if let food = FoodEditViewController.food {
            tf_name.text = food.name
            tf_serv.text = String(food.weight)
            tf_cal.text = String(food.calories)
            tf_prot.text = String(food.protein)
            tf_carb.text = String(food.carbs)
            tf_fat.text = String(food.fat)
        }
        tf_name.translatesAutoresizingMaskIntoConstraints = false
        tf_serv.translatesAutoresizingMaskIntoConstraints = false
        tf_cal.translatesAutoresizingMaskIntoConstraints = false
        tf_prot.translatesAutoresizingMaskIntoConstraints = false
        tf_carb.translatesAutoresizingMaskIntoConstraints = false
        tf_fat.translatesAutoresizingMaskIntoConstraints = false
        
                
        self.view.backgroundColor = UIColor.white
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func doneTapped(_sender: UIBarButtonItem!) {
        if let name = tf_name.text, let serv = tf_serv.text, let cal = tf_cal.text,
           let prot = tf_prot.text, let carb = tf_carb.text, let fat = tf_fat.text {
            if (name != "" && serv != "" && cal != "" && prot != "" && carb != "" && fat != "") {
                var changing_food: Food
                let appDel = UIApplication.shared.delegate as! AppDelegate
                let managedContext = appDel.persistentContainer.viewContext
                if FoodEditViewController.food == nil {
                    let entity = NSEntityDescription.entity(forEntityName: "Food", in: managedContext)
                    changing_food = NSManagedObject(entity: entity!, insertInto: managedContext) as! Food
                } else {
                    changing_food = FoodEditViewController.food!
                }
                changing_food.name = name
                changing_food.weight = Float(serv) ?? 0
                changing_food.calories = Int32(cal) ?? 0
                changing_food.protein = Float(prot) ?? 0
                changing_food.carbs = Float(carb) ?? 0
                changing_food.fat = Float(fat) ?? 0
                do {
                    try managedContext.save()
                } catch {
                    fatalError("Failed to save new values: \(error)")
                }
                self.navigationController?.popViewController(animated: true)
            } else {
                
            }
        } else {
            
        }
    }
    
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        switch indexPath.row {
        case 0:
            tf_name.placeholder = "Food Name"
            cell.addSubview(tf_name);
            tf_name.heightAnchor.constraint(equalTo: cell.heightAnchor).isActive = true
            tf_name.widthAnchor.constraint(equalTo: cell.widthAnchor).isActive = true
            tf_name.leadingAnchor.constraint(equalTo: cell.leadingAnchor, constant: 25).isActive = true
            break;
        case 1:
            tf_serv.placeholder = "Grams per serving"
            cell.addSubview(tf_serv);
            tf_serv.heightAnchor.constraint(equalTo: cell.heightAnchor).isActive = true
            tf_serv.widthAnchor.constraint(equalTo: cell.widthAnchor).isActive = true
            tf_serv.leadingAnchor.constraint(equalTo: cell.leadingAnchor, constant: 25).isActive = true
            break;
        case 2:
            tf_cal.placeholder = "Calories per serving"
            cell.addSubview(tf_cal);
            tf_cal.heightAnchor.constraint(equalTo: cell.heightAnchor).isActive = true
            tf_cal.widthAnchor.constraint(equalTo: cell.widthAnchor).isActive = true
            tf_cal.leadingAnchor.constraint(equalTo: cell.leadingAnchor, constant: 25).isActive = true
            break;
        case 3:
            tf_prot.placeholder = "Grams protein per serving"
            cell.addSubview(tf_prot);
            tf_prot.heightAnchor.constraint(equalTo: cell.heightAnchor).isActive = true
            tf_prot.widthAnchor.constraint(equalTo: cell.widthAnchor).isActive = true
            tf_prot.leadingAnchor.constraint(equalTo: cell.leadingAnchor, constant: 25).isActive = true
            break;
        case 4:
            tf_carb.placeholder = "Grams carbohydrates per serving"
            cell.addSubview(tf_carb);
            tf_carb.heightAnchor.constraint(equalTo: cell.heightAnchor).isActive = true
            tf_carb.widthAnchor.constraint(equalTo: cell.widthAnchor).isActive = true
            tf_carb.leadingAnchor.constraint(equalTo: cell.leadingAnchor, constant: 25).isActive = true
            break;
        case 5:
            tf_fat.placeholder = "Grams fat per serving"
            cell.addSubview(self.tf_fat);
            tf_fat.heightAnchor.constraint(equalTo: cell.heightAnchor).isActive = true
            tf_fat.widthAnchor.constraint(equalTo: cell.widthAnchor).isActive = true
            tf_fat.leadingAnchor.constraint(equalTo: cell.leadingAnchor, constant: 25).isActive = true
            break;
        default:
            break
        }
        
        return cell
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
