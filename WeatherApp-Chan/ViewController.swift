//
//  ViewController.swift
//  WeatherApp-Chan
//
//  Created by C4Q on 9/28/18.
//  Copyright © 2018 C4Q. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    let cellSpacing = UIScreen.main.bounds.size.width * 0.05
    
    var weather = [Day]() {
        didSet {
            print("didSet: \(weather.count)")
            weatherCollectionView.reloadData()
        }
    }
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var tempTypeToggle: UISegmentedControl!
    
    @IBOutlet weak var weatherCollectionView: UICollectionView!
    
    @IBAction func toggleSegmentedControl(_ sender: UISegmentedControl) {
        weatherCollectionView.reloadData()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        // load data
        WeatherAPIClient.manager.getWeather(completionHandler: { (weekWeather: Response) in
            self.weather = weekWeather.periods
        }) { (error: Error) in
            print(error)
        }

        weatherCollectionView.delegate = self
        weatherCollectionView.dataSource = self
        self.weatherCollectionView.backgroundColor = UIColor.white.withAlphaComponent(0.5)
    }

}
extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return weather.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "dayCell", for: indexPath) as! DayCollectionViewCell
        let day = weather[indexPath.row]
        
        let dateFullString = day.dateTimeISO
        // edit date
        let dateOnly = dateFullString.components(separatedBy: "T")[0]
        cell.dateLabel.text = dateOnly

        cell.iconImageView.image = UIImage(named: day.icon)
        
        switch tempTypeToggle.selectedSegmentIndex {
        case 0:
            cell.highTempLabel.text = "High: \(day.maxTempF)°F"
            cell.lowTempLabel.text = "Low: \(day.minTempF)°F"
        case 1:
            cell.highTempLabel.text = "High: \(day.maxTempC)°C"
            cell.lowTempLabel.text = "Low: \(day.minTempC)°C"
        default:
            break
        }
        
        cell.contentView.layer.cornerRadius = 5.0
        cell.contentView.layer.borderWidth = 1.0
        cell.contentView.layer.borderColor = UIColor.clear.cgColor
        cell.contentView.layer.masksToBounds = true
        
        cell.layer.shadowColor = UIColor.darkGray.cgColor
        cell.layer.shadowOffset = CGSize(width: 0, height: 2.0)
        cell.layer.shadowRadius = 6.0
        cell.layer.shadowOpacity = 1.0
        cell.layer.masksToBounds = false
        cell.layer.shadowPath = UIBezierPath(roundedRect:cell.bounds, cornerRadius:cell.contentView.layer.cornerRadius).cgPath
        
        return cell
    }
}


extension ViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let numCells: CGFloat = 3
        let numSpaces: CGFloat = numCells + 1
        let screenWidth = UIScreen.main.bounds.width
        let screenHeight = UIScreen.main.bounds.height
        return CGSize(width: (screenWidth - (cellSpacing * numSpaces)) / numCells, height: screenHeight * 0.25)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: cellSpacing, left: cellSpacing, bottom: 0, right: cellSpacing)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return cellSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return cellSpacing
    }
}

