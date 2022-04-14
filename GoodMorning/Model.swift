

import Foundation
import RealmSwift

class UrlOutput{
    func documents() -> URL {
        let path = try! FileManager.default.url(for: FileManager.SearchPathDirectory.documentDirectory, in: FileManager.SearchPathDomainMask.userDomainMask, appropriateFor: nil, create: true)
        return path
    }


    func copyAttachedImg(_ imgURL:String) -> URL{
        let attachImgURL = "Attachment" + imgURL
        let oldURL = documents().appendingPathComponent(imgURL)
        let newURL = documents().appendingPathComponent(attachImgURL)
        try! FileManager().copyItem(atPath: oldURL.path, toPath: newURL.path)
        return newURL
        
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
            return dateFormatter.date(from: "8:00")!
        }
        
        return encodedData
    }
    
}


class TextOutput{
    
    
    func bodyTextReturn()->String{
        let stringGreet = items
      
        print(stringGreet)
        guard let countLines = stringGreet?.count else { return "Доброе утро!" }
        if !(countLines > 0){
            return "Доброе утро!"
        }
        let randNum = Int.random(in: 0..<(stringGreet?.count)!)
        return stringGreet![randNum].lines
    }
    
    
    func imageTextReturn()->String{
        let stringGreet = images
        print("!!!!!")
        print(stringGreet)
        guard let countLines = stringGreet?.count else { return "" }
        if !(countLines > 0){
            return ""
        }
        let randNum = Int.random(in: 0..<(stringGreet?.count)!)
        return stringGreet![randNum].lines
    }
    
    
    
}

class NotificationList: Object {
    @objc dynamic var lines = ""
    
}

class ImageList: Object {
    @objc dynamic var lines = ""
    
}

let realm = try! Realm()
var items: Results<NotificationList>!
var images: Results<ImageList>!
