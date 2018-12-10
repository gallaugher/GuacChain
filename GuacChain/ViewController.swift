//
//  ViewController.swift
//  GuacChain
//
//  Created by John Gallaugher on 12/7/18.
//  Copyright © 2018 John Gallaugher. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ViewController: UIViewController {
    @IBOutlet weak var tacoQtyLabel: UILabel!
    @IBOutlet weak var burritoQtyLabel: UILabel!
    @IBOutlet weak var chipsQtyLabel: UILabel!
    @IBOutlet weak var horchataQtyLabel: UILabel!
    @IBOutlet weak var bitcoinTotalLabel: UILabel!
    @IBOutlet weak var currencyTotalLabel: UILabel!
    
    @IBOutlet weak var tacoStepper: UIStepper!
    @IBOutlet weak var burritoStepper: UIStepper!
    @IBOutlet weak var chipsStepper: UIStepper!
    @IBOutlet weak var horchataStepper: UIStepper!
    
    @IBOutlet weak var currencySegmentedControl: UISegmentedControl!
    
    let burritoPrice = 8.00
    let tacoPrice = 5.00
    let chipsPrice = 3.00
    let horchataPrice = 2.00
    
    var dollarPerBTC = 0.0
    var poundPerBTC = 0.0
    var euroPerBTC = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let url = "https://api.coindesk.com/v1/bpi/currentprice.json"
        Alamofire.request(url).responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                self.dollarPerBTC = json["bpi"]["USD"]["rate_float"].doubleValue
                self.poundPerBTC = json["bpi"]["GBP"]["rate_float"].doubleValue
                self.euroPerBTC = json["bpi"]["EUR"]["rate_float"].doubleValue
            case .failure(let error):
                print("😡😡 ERROR: \(error.localizedDescription) failed to get data from URL \(url)")
            }
            self.calcTotal()
        }
    }
    
    func calcTotal() {
        var dollarTotal = tacoStepper.value * tacoPrice
        dollarTotal += burritoStepper.value * burritoPrice
        dollarTotal += chipsStepper.value * chipsPrice
        dollarTotal += horchataStepper.value * horchataPrice
        
        let bitcoinTotal = dollarTotal / dollarPerBTC
        bitcoinTotalLabel.text = "฿\(bitcoinTotal)"
        switch currencySegmentedControl.selectedSegmentIndex {
        case 0:
            let value = String(format: "$%.02f", dollarTotal)
            currencyTotalLabel.text = value
        case 1:
            let value = String(format: "£%.02f", bitcoinTotal * poundPerBTC)
            currencyTotalLabel.text = value
        case 2:
            let value = String(format: "€%.02f", bitcoinTotal * euroPerBTC)
            currencyTotalLabel.text = value
        default:
            print("😡😡 This should not have happened - only 3 segments in the segmented control")
        }
    }

    @IBAction func tacoStepperPressed(_ sender: UIStepper) {
        tacoQtyLabel.text = String(Int(tacoStepper.value))
        calcTotal()
    }
    
    @IBAction func burritoStepperPressed(_ sender: UIStepper) {
        burritoQtyLabel.text = String(Int(burritoStepper.value))
        calcTotal()
    }
    
    @IBAction func chipsStepperPressed(_ sender: UIStepper) {
        chipsQtyLabel.text = String(Int(chipsStepper.value))
        calcTotal()
    }
    
    @IBAction func horchataStepperPressed(_ sender: UIStepper) {
        horchataQtyLabel.text = String(Int(horchataStepper.value))
        calcTotal()
    }
    
    @IBAction func currencySegmentPressed(_ sender: UISegmentedControl) {
        calcTotal()
    }
    
}

