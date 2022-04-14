
import UIKit
import RealmSwift


class ListVC: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{

    var cellId = "Cell"
    let imagePicker = UIImagePickerController()
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        view.backgroundColor = .gray
        setupButton()
        setupButtonNext()
        setupButtonBack()
         
        self.tableView.contentInset = UIEdgeInsets(top: 70, left: 0, bottom: 0, right: 0)
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
        
        items = realm.objects(NotificationList.self)
        
    }
  
    func setupButton(){
        let button = UIButton(frame: CGRect(x: 40, y: 100, width: 250, height: 50))
        button.backgroundColor = .systemIndigo
        button.setTitle("Добавить приветствие", for: .normal)
        button.addTarget(self, action: #selector(addItem), for: .touchUpInside)
        
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
    
    func setupButtonNext(){
        let buttonNext = UIButton(frame: CGRect(x: 300, y: 10, width: 30, height: 50))
        buttonNext.backgroundColor = .systemIndigo
        buttonNext.setTitle(">", for: .normal)
        
        buttonNext.addTarget(self, action: #selector(nextView), for: .touchUpInside)
        self.view.addSubview(buttonNext)
        buttonNext.frame.origin.y = -60
    }
    
    @objc func nextView(_ sender: AnyObject) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "VCID")
        self.present(nextViewController, animated:true, completion:nil)
        
    }
    
    @objc func addItem(_ sender: AnyObject) {
        
        addAlertForNewItem()
        
    }
    
    @objc func dismissButton(_ sender: UIButton){
        
        self.dismiss(animated: true, completion: nil)
        
    }
 
    func addAlertForNewItem() {
        let alert = UIAlertController(title: "Новое приветствие", message: "Добавьте желаемое приветствие", preferredStyle: .alert)
        
        
        var alertTextField: UITextField!
        alert.addTextField { textField in
            alertTextField = textField
            textField.placeholder = "Доброе утро"
        }
        
        
        let saveAction = UIAlertAction(title: "Сохранить", style: .default) { action in
            guard let text = alertTextField.text , !text.isEmpty else { return }
            
            let newLine = NotificationList()
            newLine.lines = text
            
            try! realm.write {
                realm.add(newLine)
            }
            
            
            self.tableView.insertRows(at: [IndexPath.init(row: items.count-1, section: 0)], with: .automatic)
            
        }
        
        let cancelAction = UIAlertAction(title: "Отмена", style: .destructive, handler: nil)
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if items.count != 0 {
            return items.count
        }
        return 0
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        let item = items[indexPath.row]
        cell.textLabel?.text = item.lines
        return cell
    }
    
    
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let editingRow = items[indexPath.row]
        
        let deleteAction = UITableViewRowAction(style: .normal, title: "Удалить") { _,_ in
            try! realm.write {
                
                realm.delete(editingRow)
                tableView.reloadData()
            }
            
        }
        
        return [deleteAction]
    }
 
}
