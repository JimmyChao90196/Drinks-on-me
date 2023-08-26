//
//  CartViewController.swift
//  Drinks on me
//
//  Created by JimmyChao on 2023/8/18.
//

import UIKit

class CartViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    
 
    @IBOutlet var orderButton: UIButton!
 
    @IBOutlet var footerView: UIView!
    @IBOutlet var cartView: UIView!
    var patchInfo = PatchInfo()
    var recordsToDelete:String?
    var recordsToRevise:String?
    var orderRoot:ResponseRoot?
    
    var updateTimer: Timer?
    @IBOutlet var inlineTableView: UITableView!
    
    



    override func viewDidLoad() {
        super.viewDidLoad()

        
        
        //Initialize background color
        inlineTableView.backgroundColor = UIColor.init(red: 23/255, green: 61/255, blue: 80/255, alpha: 1)
        cartView.backgroundColor = inlineTableView.backgroundColor
        footerView.backgroundColor = inlineTableView.backgroundColor
        
        
        
        // Start the timer to fetch orders every 15 seconds
            updateTimer = Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(updateOrders), userInfo: nil, repeats: true)
        
        
        fetchOrder { fetchedOrderRoot in
            self.orderRoot = fetchedOrderRoot
            print("\(String(describing: self.orderRoot))")
            self.inlineTableView.reloadData()
            
            self.calculateSum()
        }
    }
    
    
    //Order alert
    
    func showAlert(){
        let alertController = UIAlertController(title: "訂單確認", message: "確定要撥打電話？", preferredStyle: .actionSheet)
        let callAlertAction = UIAlertAction(title: "02-26562288", style: .default)
        let cancelAlertAction = UIAlertAction(title: "Cancel", style: .destructive)
        
        alertController.addAction(callAlertAction)
        alertController.addAction(cancelAlertAction)
        
        present(alertController, animated: true)
    }
    
    
    
    @IBAction func orderButton(_ sender: Any) {
        showAlert()
    }
    
    
    
    
    
    
    
    
    
   
    
    // MARK: - objc Timer function
    
    @objc func updateOrders() {
        
        fetchOrder { fetchedOrderRoot in
            self.orderRoot = fetchedOrderRoot
            UIView.transition(with: self.inlineTableView,
                                      duration: 0.4,
                                      options: .transitionCrossDissolve,
                                      animations: { self.inlineTableView.reloadData() })
        }
        calculateSum()
    }


    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // Start the timer to fetch orders every 15 seconds
        updateTimer = Timer.scheduledTimer(timeInterval: 10.0, target: self, selector: #selector(updateOrders), userInfo: nil, repeats: true)
    }
    
    
    //Make sure to invalidate the timer when the view controller is no longer visible to avoid unnecessary API calls
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        updateTimer?.invalidate()
        updateTimer = nil
    }


    
    
    
    // MARK: - Calculate sum function
    
    func calculateSum(){
        let records = orderRoot?.records ?? []
        totalPrice = 0

        for record in records {
            let pricePerCup = record.fields.originPrice
            let cups = record.fields.cups
            totalPrice += pricePerCup * cups
        }
        orderButton.setTitle("Order for $ \(totalPrice)", for: .normal)
    }

    
    
    
    
    
    
    
    // MARK: - Revise api functions

    @IBAction func reviseOrder(_ sender: UIStepper) {
    
        print(sender.value)
        
        let point = sender.convert(CGPoint.zero, to: inlineTableView)
            if let indexPath = inlineTableView.indexPathForRow(at: point),
               let originalCup = orderRoot?.records[indexPath.row].fields.cups {
                
                
                // Update local data source
                patchInfo.cups = originalCup + Int(sender.value)
                //patchInfo.price =
                
                
                orderRoot?.records[indexPath.row].fields.cups = patchInfo.cups
                
                // Reload the specific row with animation
                inlineTableView.reloadRows(at: [indexPath], with: .automatic)

                // Fetch the record ID to be revised
                let reviseID = orderRoot?.records[indexPath.row].id
                recordsToRevise = reviseID
                reviseRecord()
            }
        sender.value = 0
        
        calculateSum()
    }
    
    
    
    
    func reviseRecord(){
        let urlStr = "https://api.airtable.com/v0/appN21f5f7mgnzUIi/order"
        

        print(urlStr)
        
        if let url = URL(string: urlStr){
            var urlRequest = URLRequest(url: url)
            urlRequest.httpMethod = "PATCH"
            urlRequest.setValue("Bearer patVvuJLhCGDlIA5N.bb43e3d5bf2d60015a897eff3ed89c044143a0c5fc967a59bcb9d20d8cc5043a", forHTTPHeaderField: "Authorization")
            urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
            urlRequest.setValue("application/json", forHTTPHeaderField: "Accept")
            

            //Patch order
            let patchRecord = PatchRecords(fields: PatchFields.init(cups: patchInfo.cups), id: recordsToRevise ?? "")
            let patchData = PatchRoot(records: [patchRecord])
            
            
            let encoder = JSONEncoder()
            urlRequest.httpBody = try? encoder.encode(patchData)
           
            URLSession.shared.dataTask(with: urlRequest) { data, _, _ in
                if let data{
                    
                    print(String(data: data, encoding: .utf8) ?? "Invalid data")
                    
                    let decoder = JSONDecoder()
                    decoder.dateDecodingStrategy = .iso8601
                    
                    do {
                        let patchResponse =  try decoder.decode(PatchRoot.self, from: data)
                        DispatchQueue.main.async {
                            self.calculateSum()
                        }
                      
                        
                        print("Token: \(patchResponse)")
                    } catch  {
                        print(error)
                    }     
                }
            }.resume()
        }
    }
    
    
    
    
    
    
    
    
    
    
    
    
    // MARK: - Delete corresponding function
    
    @IBAction func deleteOrder(_ sender: UIButton) {
        let point = sender.convert(CGPoint.zero, to: inlineTableView)
        if let indexPath = inlineTableView.indexPathForRow(at: point){
            let deleteID = orderRoot?.records[indexPath.row].id
            
            recordsToDelete = deleteID
            deleteRecord(at: indexPath)
            calculateSum()
        }
    }
    
    
    
    func deleteRecord(at indexPath:IndexPath){
        var urlStr = "https://api.airtable.com/v0/appN21f5f7mgnzUIi/order"
        
        urlStr += "/\(recordsToDelete ?? "")"
        print(urlStr)
        
        if let url = URL(string: urlStr){
            var urlRequest = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData)
            urlRequest.httpMethod = "DELETE"
            urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
            urlRequest.setValue("Bearer patVvuJLhCGDlIA5N.bb43e3d5bf2d60015a897eff3ed89c044143a0c5fc967a59bcb9d20d8cc5043a", forHTTPHeaderField: "Authorization")
            
            
            
            
            // Send the DELETE request using URLSession
            let task = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
                // Check for errors
                if let error = error {
                    print("Error occurred: \(error.localizedDescription)")
                    return
                }
                
                // Check for a valid HTTP response
                guard let httpResponse = response as? HTTPURLResponse else {
                    print("Invalid response object received.")
                    return
                }
                
                
                
                
                // Handle the response based on the status code
                switch httpResponse.statusCode {
                case 200...299: // Success
                    print("Request was successful.")
                    if let data = data, let responseString = String(data: data, encoding: .utf8) {
                        print("Response data: \(responseString)")
                        
                        DispatchQueue.main.async {
                            fetchOrder { fetchedOrderRoot in
                                self.orderRoot = fetchedOrderRoot
                                self.inlineTableView.deleteRows(at: [indexPath], with: .automatic)
                                self.calculateSum()
                                //self.inlineTableView.reloadData()
                            }
                        }
                    }
                    
                default: // Failure
                    print("Request failed with status code: \(httpResponse.statusCode)")
                    if let data = data, let responseString = String(data: data, encoding: .utf8) {
                        print("Response data: \(responseString)")
                    }
                }
            }
            task.resume()
        }
    }
    
    
    
    
    
    
    
 
    // MARK: - Table corresponding function
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        orderRoot?.records.count ?? 20
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CartTableViewCell.reuseIdentifier, for: indexPath) as? CartTableViewCell else{fatalError("unable to find cell")}
        
        
        //Set client name
        cell.clientNameLabel.text = orderRoot?.records[indexPath.row].fields.clientName
    
        
        
        //Initialize cell appearance
        cell.backgroundColor = .clear
        
        let cups = orderRoot?.records[indexPath.row].fields.cups ?? 0
        let originPrice = (orderRoot?.records[indexPath.row].fields.originPrice ?? 0)
        
        cell.priceLable.text = "$ \(originPrice * cups)"
        
        let cupStr:String =  "  X  " + String(cups)
        cell.orderDrinkName.text = (orderRoot?.records[indexPath.row].fields.orderedDrinkName ?? "") + cupStr
        return cell
    }
    

}
