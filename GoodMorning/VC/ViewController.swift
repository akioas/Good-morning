

import UIKit
import UserNotifications


class ViewController: UIViewController {
     
    @IBAction func closeAppButton(_ sender: Any) {
        exit(-1)
    }
    
    var timer = Timer()
  
    @IBOutlet weak var timePicker: UIDatePicker!
    
    @IBAction func triggerNotification(_ sender: Any) {
        
        AppDelegate().scheduleNotification(triggerDaily: datePicked())
        SaveTime().saveNum(datePicked())
        textTimeResponse.text = "Время установлено."

    }
    
    @IBAction func cancelNotification(_ sender: Any) {
        let center = UNUserNotificationCenter.current()
        center.removePendingNotificationRequests(withIdentifiers: ["Local Notification"])
        textTimeResponse.text = "Отмена уведомлений."
     
    }
    
    
    
    @IBOutlet weak var textTimeResponse: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        timePicker.date = SaveTime().loadNum()
        
        items = realm.objects(NotificationList.self)
        images = realm.objects(ImageList.self)
        
    }
    
    func datePicked() -> Date{
        return timePicker.date
    }
    
}

