//
//  ViewController.swift
//  ByteCoin
//
//  Created by Angela Yu on 11/09/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var currencyRateLabel: UILabel!
    @IBOutlet weak var currencyTypeLabel: UILabel!
    @IBOutlet weak var currencyPicker: UIPickerView!
    var coinManager = CoinManager()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        currencyPicker.delegate = self
        currencyPicker.dataSource = self
        coinManager.delegate = self
    }

    
    
}

//MARK: - UIPickerViewDataSource Section

extension ViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int{
        return 1;
    }
    
    func pickerView(_ pickerView: UIPickerView,
                    numberOfRowsInComponent component: Int) -> Int {
        return coinManager.currencyArray.count;
    }
    
}

//MARK: - UIPickerViewDelegate section

extension ViewController: UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView,
                 titleForRow row: Int,
                 forComponent component: Int) -> String? {
        return coinManager.currencyArray[row]
    }
    
    //Función que se activa por defecto cuando se mueve el picker:
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let selectedCurrency: String = coinManager.currencyArray[row]
        coinManager.chosenCurrency = selectedCurrency
        coinManager.performQuery()
        
    }
    
}

//MARK: - coinMagagement section

extension ViewController: CoinManagement {
    func didUpdateCurrency(_ coinManager: CoinManager, rate: Double, currency: String) {
        DispatchQueue.main.async {
                let currencyFormatter = NumberFormatter()
                currencyFormatter.usesGroupingSeparator = true
                currencyFormatter.numberStyle = .currency
                
                // localize to your grouping and decimal separator
                currencyFormatter.locale = Locale.current
                currencyFormatter.currencySymbol = "" //Quitar el tipo de moneda ($)

                let priceString = currencyFormatter.string(from: NSNumber(value: rate))
                
                self.currencyRateLabel.text = priceString
                self.currencyTypeLabel.text = currency
        }
    }
    
    func didFailWithError(_ coinManager: CoinManager, error: Error) {
        print(error)
    }
}
