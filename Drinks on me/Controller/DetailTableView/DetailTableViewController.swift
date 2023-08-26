//
//  DetailTableViewController.swift
//  Drinks on me
//
//  Created by JimmyChao on 2023/8/17.
//

import UIKit

class DetailTableViewController: UITableViewController,UITextFieldDelegate {

    
    @IBOutlet var stepperView: UIStepper!
    @IBOutlet var footerView: UIView!
    @IBOutlet var headerDescription: UITextView!
    @IBOutlet var addToCart: UIButton!
    @IBOutlet var headerView: UIView!
    @IBOutlet var headerImage: UIImageView!
    @IBOutlet var notes: UITextField!
    @IBOutlet var clientName: UITextField!

    var originPrice = 0
    var drinkInfo:SearchRoot.Drinks?
    
    var orderInfo = OrderInfo(sweetness: "", ice: "", toppings: "", price: 0, cups: 1, size: "")
    

    // MARK: - Section defination for menu

    //Define sections
    struct Section {
        var headerTitle: String?
        var rows: [String]
        var isCollapsed: Bool = false
        var backgroundColor: UIColor
        var selectedRowIndex: Int? = nil
    }


    //Option sections
    var sections: [Section] = [
        
        Section(headerTitle: "甜度", rows: ["正常糖", "少糖","半糖", "微糖","無糖"], backgroundColor: .init(red: 0.8, green: 0.75, blue: 0.4, alpha: 0.95)),
        
        Section(headerTitle: "冰塊", rows: ["正常冰", "少冰","微冰","去冰", "完全去冰","常溫","溫", "熱"], backgroundColor: .init(red: 0.8, green: 0.75, blue: 0.4, alpha: 0.95)),
        
        Section(headerTitle: "配料", rows: ["水玉", "白玉珍珠"], backgroundColor: .init(red: 0.8, green: 0.75, blue: 0.4, alpha: 0.95)),
        
        Section(headerTitle: "Size", rows: ["中杯:", "大杯:"], backgroundColor: .init(red: 0.8, green: 0.75, blue: 0.4, alpha: 0.95))
    ]
    
    
    //Adjust section initializer
    func sectionInitializer(){
        sections[3].rows[0] += "    $ \(drinkInfo?.fields.medium ?? 0)"
        sections[3].rows[1] += "    $ \(drinkInfo?.fields.big ?? 0)"
    }
    
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Initialize tableview background
        tableView.backgroundColor = UIColor.init(red: 23/255, green: 61/255, blue: 80/255, alpha: 1)
        headerView.backgroundColor = tableView.backgroundColor
        footerView.backgroundColor = headerView.backgroundColor
        headerImage.layer.cornerRadius = 15
        headerImage.layer.borderWidth = 2.5
        headerImage.layer.borderColor = .init(red: 0.8, green: 0.75, blue: 0.4, alpha: 0.95)
        headerImage.layer.shadowRadius = 20
        
        
        //Set stepper appearance
        stepperView.layer.backgroundColor = UIColor.lightGray.cgColor
        stepperView.layer.cornerRadius = 10
        
        
        
        //Initialize description
        headerDescription.backgroundColor = .clear
        headerDescription.textColor = .white

        
        
        
        
        //Initialize price and options
        sectionInitializer()
        priceCalculate()
        

        //Initialize title image
        fetchAndSet(info: drinkInfo) { imageData, name, desc, price in
            self.headerImage.image = UIImage(data: imageData)
            self.headerDescription.text = desc
        }
        
        
        //Assign delegat
        clientName.delegate = self
        notes.delegate = self

    }
    
    
    
    
    //Alert function
    func showAlert(with message:String){
        
        let alertController = UIAlertController(title: "Missing Selection", message: message, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "Got it", style: .default)
        alertController.addAction(alertAction)
        present(alertController, animated: true)
    }
    
    
    
    // MARK: - implement text field delegate function
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    

    
    
    
    // MARK: - Add to cart
    
    @IBAction func stepperForCup(_ sender: UIStepper) {
        orderInfo.cups = Int(sender.value)
        priceCalculate()
    }
    
    
    @IBAction func addToCart(_ sender: Any) {
        
        // Check if the selections have been made
        if sections[0].selectedRowIndex == nil {
            showAlert(with: "Please select a 甜度 option.")
            return
            
        }
        if sections[1].selectedRowIndex == nil {
            showAlert(with: "Please select an 冰塊 option.")
            return
            
        }
        if sections[2].selectedRowIndex == nil {
            showAlert(with: "Please select a 配料 option.")
            return
            
        }
        if sections[3].selectedRowIndex == nil{
            showAlert(with: "Please select a size option")
        }
        
        

        postRequest()
        
    }
    
 

    func priceCalculate(){
        if orderInfo.size == "medium"{
            orderInfo.price = drinkInfo?.fields.medium ?? 10
            originPrice = orderInfo.price
            
        }else if orderInfo.size == "big"{
            orderInfo.price = drinkInfo?.fields.big ?? 10
            originPrice = orderInfo.price
            
        }else{
            orderInfo.price = 0
            originPrice = 0
        }
        
        orderInfo.price *= orderInfo.cups
        addToCart.setTitle("Add \(orderInfo.cups) cups $ \(orderInfo.price) to cart", for: .normal)
    }
    
    
    

    //Post request
    func postRequest(){
        
        let urlStr = "https://api.airtable.com/v0/appN21f5f7mgnzUIi/order"
        if let url = URL(string: urlStr){
            var urlRequest = URLRequest(url: url)
            urlRequest.httpMethod = "POST"
            urlRequest.setValue("Bearer patVvuJLhCGDlIA5N.bb43e3d5bf2d60015a897eff3ed89c044143a0c5fc967a59bcb9d20d8cc5043a", forHTTPHeaderField: "Authorization")
            urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
            urlRequest.setValue("application/json", forHTTPHeaderField: "Accept")
            
            //Extract and post drink info
            guard let drinkInfo else{ return }
            
            
            let inputName = (clientName.text == "" ? "Defualt client":clientName.text)!
            let inputNote = (notes.text == "" ? "None" : notes.text)!
     
            
            
            let orderFields = PostFields(
                orderedDrinkName: drinkInfo.fields.name,
                sweetness: orderInfo.sweetness,
                ice: orderInfo.ice,
                clientName: inputName,
                notes: inputNote,
                toppings: orderInfo.toppings,
                price: orderInfo.price,
                originPrice: self.originPrice,
                size: orderInfo.size,
                cups: orderInfo.cups,
                menuID: drinkInfo.id
            )
            
            
            let orderRecord = PostRecords(fields: orderFields)
            let orderData = PostRoot(records: [orderRecord])
            
            let encoder = JSONEncoder()
            urlRequest.httpBody = try? encoder.encode(orderData)
           
            URLSession.shared.dataTask(with: urlRequest) { data, _, _ in
                if let data{
                    
                    print(String(data: data, encoding: .utf8) ?? "Invalid data")
                    
                    let decoder = JSONDecoder()
                    decoder.dateDecodingStrategy = .iso8601
                    
                    
                    do {
                        let postResponse =  try decoder.decode(ResponseRoot.self, from: data)
                      
                        print("Token: \(postResponse)")
                    } catch  {
                        print(error)
                    }
                }
            }.resume()
        }
    }
    
    
    

    
    // MARK: - Set Cell Config seperately
    

    
    func cellConfig(_ cell:DetailTableViewCell,_ indexPath:IndexPath){
        
        let data = sections[indexPath.section].rows[indexPath.row]
        cell.textLabel?.text = data
        
        if sections[indexPath.section].selectedRowIndex == indexPath.row {
            cell.backgroundColor = UIColor(red: 0.6, green: 0.6, blue: 0.2, alpha: 0.95)
            cell.imageView?.image = UIImage(systemName: "circle.circle.fill")?.withTintColor(.brown)
            
        }else{
            cell.imageView?.image = UIImage(systemName: "circle.circle")?.withTintColor(.brown)
        }
        
        
        
        
        //Adjust callapseable
        if sections[indexPath.section].isCollapsed {
                cell.contentView.alpha = 0 // Hide content if collapsed
            } else {
                cell.contentView.alpha = 1 // Show content if expanded
            }
        
        //Set backgroundColor accordingly
        cell.backgroundColor = sections[indexPath.section].backgroundColor
    }
    
    
    
    
    
    // MARK: - Cell in table view
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: DetailTableViewCell.reuseIdentifier, for: indexPath) as? DetailTableViewCell else{
            fatalError("unable to find cell")
        }
        

        
        
        cellConfig(cell, indexPath)
        
        return cell
    }
    

    
    
    
    // MARK: - Tapped action
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            
            sections[indexPath.section].selectedRowIndex = indexPath.row
                
                //Extract order info
            switch indexPath.section {
                case 0: orderInfo.sweetness = sections[0].rows[indexPath.row]
                    print(orderInfo.sweetness)
                case 1: orderInfo.ice = sections[1].rows[indexPath.row]
                    print(orderInfo.ice)
                case 2: orderInfo.toppings = sections[2].rows[indexPath.row]
                    print(orderInfo.toppings)
                case 3:
                
                print(sections[3].rows[indexPath.row])
                switch indexPath.row {
                case 0: orderInfo.size = "medium"
                case 1: orderInfo.size = "big"
                default : orderInfo.size = "medium"
                }
                
                default: return
            }
                
                
            //Calculate when tapped
            priceCalculate()
        
            tableView.reloadData()

        }
    
    
    
    
    
    // MARK: - Table view rows and sections

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        sections.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].isCollapsed ? 0 : sections[section].rows.count
    }
    
    
    
    


    
    
    // MARK: - Table view height for row and header
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 44 // Default row height
    }

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 50 // Default header height
    }
    
    
    
    

    
    
    
    
    // MARK: - Header modification
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section].headerTitle
    }
    

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = sections[section].backgroundColor
        headerView.layer.cornerRadius = 10
        headerView.layer.borderWidth = 2
        headerView.layer.shadowRadius = 10
        headerView.tag = section
        
        
        let label = UILabel()
        label.text = sections[section].headerTitle
        label.frame = CGRect(x: 15, y: 0, width: tableView.bounds.width, height: 44)
        headerView.addSubview(label)

        // Add tap gesture to the header
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleSectionHeaderTap))
        
        headerView.addGestureRecognizer(tapGesture)
        
        return headerView
    }

    
    
    
    
    
    // MARK: - Objc func
    
    @objc func handleSectionHeaderTap(gesture: UITapGestureRecognizer) {
        guard let section = gesture.view?.tag else { return }

        let rowsInRange = 0..<sections[section].rows.count
        let indexPathsToReload = rowsInRange.map { IndexPath(row: $0, section: section) }
     
        
        
        tableView.beginUpdates()

        if sections[section].isCollapsed {
            sections[section].isCollapsed = false
            tableView.insertRows(at: indexPathsToReload, with: .fade)
            
        } else {
            sections[section].isCollapsed = true
            tableView.deleteRows(at: indexPathsToReload, with: .fade)
        }

        tableView.endUpdates()
    }

    


    

}
