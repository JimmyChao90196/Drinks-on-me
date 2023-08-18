//
//  CartViewController.swift
//  Drinks on me
//
//  Created by JimmyChao on 2023/8/18.
//

import UIKit

class CartViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    var recordsToDelete:String?
    var orderRoot:ResponseRoot?
    var updateTimer: Timer?

    @IBOutlet var inlineTableView: UITableView!
    
    



    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Start the timer to fetch orders every 15 seconds
            updateTimer = Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(updateOrders), userInfo: nil, repeats: true)
        
        
        fetchOrder { fetchedOrderRoot in
            self.orderRoot = fetchedOrderRoot
            print("\(String(describing: self.orderRoot))")
            self.inlineTableView.reloadData()
        }

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

    
    
    
    
    
    
    // MARK: - Delete corresponding function
    @IBAction func deleteOrder(_ sender: UIButton) {
        let point = sender.convert(CGPoint.zero, to: inlineTableView)
        if let indexPath = inlineTableView.indexPathForRow(at: point){
            let deleteID = orderRoot?.records[indexPath.row].id
            
            recordsToDelete = deleteID
            deleteRecord(at: indexPath)
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
        
        cell.orderDrinkName.text = orderRoot?.records[indexPath.row].fields.orderedDrinkName
        
        
        return cell
    }
    

}
