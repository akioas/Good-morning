import UIKit
import RealmSwift

class ImageVC: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    var cellId = "Cell"
    let imagePicker = UIImagePickerController()
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        view.backgroundColor = .gray
        setupButton()
        setupButtonBack()
        
        self.tableView.contentInset = UIEdgeInsets(top: 70, left: 0, bottom: 0, right: 0)
        
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
        
        images = realm.objects(ImageList.self)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            let timeName = String(Int(Date().timeIntervalSince1970)) + "imgName.jpg"
            let filePath = UrlOutput().documents().appendingPathComponent(timeName)
            addImgURL(timeName)
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    func setupButton(){
        let button = UIButton(frame: CGRect(x: 40, y: 100, width: 250, height: 50))
        button.backgroundColor = .systemIndigo
        button.setTitle("Добавить картинку", for: .normal)
        button.addTarget(self, action: #selector(loadImage), for: .touchUpInside)
        
        self.view.addSubview(button)
        button.frame.origin.y = -60
    }
    
    func setupButtonBack(){
        let buttonBack = UIButton(frame: CGRect(x: 5, y: 10, width: 30, height: 50))
        buttonBack.backgroundColor = .systemIndigo
        buttonBack.setTitle("<", for: .normal)
        
        buttonBack.addTarget(self, action: #selector(dismissButton), for: .touchUpInside)
        
        
        self.view.addSubview(buttonBack)
        buttonBack.frame.origin.y = -60
    }
    
    
    
    func addImgURL(_ pickedImage:String){
        let newLine = ImageList()
        
        let URLString = pickedImage
        
        try? newLine.lines = URLString
        
        try! realm.write {
            realm.add(newLine)
        }
        self.tableView.insertRows(at: [IndexPath.init(row: images.count-1, section: 0)], with: .automatic)
    }
    
    @objc func loadImage(_ sender: AnyObject) {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        
        present(imagePicker, animated: true, completion: nil)
    }
   
    
    @objc func dismissButton(_ sender: UIButton){
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if images.count != 0 {
            return images.count
        }
        return 0
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        let item = images[indexPath.row]
        cell.textLabel?.text = item.lines
        return cell
    }
    
    
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let editingRow = images[indexPath.row]
        
        let deleteAction = UITableViewRowAction(style: .normal, title: "Удалить") { _,_ in
            try! realm.write {
                
                realm.delete(editingRow)
                tableView.reloadData()
            }
            
        }
        
        return [deleteAction]
    }
    
}
