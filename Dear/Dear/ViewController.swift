//
//  ViewController.swift
//  Dear
//
//  Created by Катя on 13.03.2022.
//

import UIKit
import UserNotifications

class ViewController: UIViewController {

    
    var timer = Timer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        timePicker.date = SaveTime().loadNum()
        // Do any additional setup after loading the view.
        timer = Timer.scheduledTimer(withTimeInterval: 3.0, repeats: true, block: { (timer) in
                    self.animateFunction(self.textTimeResponse)
                })


    }
    
    func animateFunction(_ view: UIView) {
        UIView.animate(withDuration: 1.0, delay: 0, options: .curveEaseIn) {
                    view.alpha = 1
                }
        completion: { (_) in
            UIView.animate(withDuration: 1.0, delay: 0, options: .curveEaseIn) {
                    view.alpha = 0
                }
        }
    }
    
    @IBOutlet weak var timePicker: UIDatePicker!
    
    @IBAction func triggerNotification(_ sender: Any) {
       
            AppDelegate().scheduleNotification(triggerDaily: datePicked())
        SaveTime().saveNum(datePicked())
        textTimeResponse.text = "Время установлено."

        
    }

    
    
    @IBOutlet weak var textTimeResponse: UILabel!
    
    
    
    func datePicked() -> Date{
        return timePicker.date
    }
    
}




class SaveTime{
    let KeyForUserDefaults = "time"
    func saveNum(_ num: Date) {
        UserDefaults.standard.set(num, forKey: KeyForUserDefaults)
    }

    func loadNum() -> Date {
        
        guard let encodedData = UserDefaults.standard.object(forKey: KeyForUserDefaults) as? Date else {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "HH:mm"
            return dateFormatter.date(from: "7:00")!
        }

        return encodedData
    }
        
}


class TextOutput{
    
    func bodyTextReturn()->String{
        let randNum = Int.random(in: 1..<10)
        switch randNum{
            case 1: return "Хорошего дня!"
            case 2: return "Доброе утро, милая!"
            case 3: return "С добрым утром!"
            case 4: return "❤️ ❤️ ❤️ "
            case 5: return "☀️☀️☀️"
            case 6: return "😊😊😊"
            case 7: return "🌹🌹🌹"
            default: return "Доброе утро, дорогая!"
            
        }
    }
    
    
}
