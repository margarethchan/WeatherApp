//
//  ViewController.swift
//  WeatherApp-Chan
//
//  Created by C4Q on 9/28/18.
//  Copyright © 2018 C4Q. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    
    let cellSpacing = UIScreen.main.bounds.size.width * 0.05
    
    var weather = [Day]() {
        didSet {
            print("didSet: \(weather.count)")
            weatherCollectionView.reloadData()
        }
    }
    
    @IBOutlet weak var tempTypeToggle: UISegmentedControl!
    
    @IBOutlet weak var weatherCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // load data
        WeatherAPIClient.manager.getWeather(completionHandler: { (weekWeather: Response) in
            self.weather = weekWeather.periods
        }) { (error: Error) in
            print(error)
        }
        
        weatherCollectionView.delegate = self
        weatherCollectionView.dataSource = self
    }



    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print(weather.count)
        return weather.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "dayCell", for: indexPath) as! DayCollectionViewCell
        let day = weather[indexPath.row]
        cell.dateLabel.text = day.dateTimeISO
        cell.highTempLabel.text = "High: \(day.maxTempF)F"
        cell.lowTempLabel.text = "Low: \(day.minTempF)F"
        return cell
    }
    
    
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

