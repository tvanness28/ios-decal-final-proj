//
//  MainTableViewCell.swift
//  EatWell
//
//  Created by Timothy Van Ness on 12/6/16.
//  Copyright © 2016 Timothy Van Ness. All rights reserved.
//

import UIKit
import Charts

class MainTableViewCell: UITableViewCell {
    
//    var keyImgView = UIImageView(image: #imageLiteral(resourceName: "pexels-photo-41123.jpg"))
    var label = UILabel()
    var calLabel = UILabel()
    var barChart = HorizontalBarChartView()
    let stat_colors = [UIColor(red:0.07, green:0.61, blue:0.60, alpha:1.0),
                       UIColor(red:0.35, green:0.73, blue:0.82, alpha:1.0),
                       UIColor(red:0.99, green:0.87, blue:0.35, alpha:1.0)]
    
    static var food: Food? = nil
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style:style, reuseIdentifier: reuseIdentifier)
        
        
//        keyImgView.clipsToBounds = true
//        contentView.addSubview(keyImgView)
//        keyImgView.translatesAutoresizingMaskIntoConstraints = false
//        
//        keyImgView.heightAnchor.constraint(equalTo: contentView.heightAnchor).isActive = true
//        keyImgView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.25).isActive = true
//        keyImgView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textColor = UIColor.black
        label.textAlignment = .center
        
        contentView.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10).isActive = true
        label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10).isActive = true
        
        calLabel.font = UIFont.systemFont(ofSize: 14)
        calLabel.textColor = UIColor.black
        calLabel.textAlignment = .center
        
        contentView.addSubview(calLabel)
        calLabel.translatesAutoresizingMaskIntoConstraints = false
        
        calLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10).isActive = true
        calLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10).isActive = true
        
//        setData()
//        contentView.addSubview(barChart)
//        barChart.translatesAutoresizingMaskIntoConstraints = false
//        
//        barChart.noDataText = "No Data for this thing"
//        barChart.topAnchor.constraint(equalTo: label.bottomAnchor).isActive = true
//        barChart.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
//        barChart.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: -10).isActive = true
//        barChart.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.5).isActive = true

        
        
    }
    
    func setData () {
        if let food = MainTableViewCell.food {
            let total_macros = food.carbs + food.protein + food.fat
            var percents: [Double] = [Double(food.protein / total_macros), Double(food.carbs / total_macros), Double(food.fat / total_macros)]
            
            var stats_vals: [BarChartDataEntry] = []
            var data_colors: [UIColor] = []
            for i in [2,1,0] {
                data_colors.append(stat_colors[i])
                stats_vals.append(BarChartDataEntry(x: Double(i), y: percents[i]))
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
            barChart.animate(xAxisDuration: 1.5, yAxisDuration: 1.5, easingOption: ChartEasingOption.easeOutExpo)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
