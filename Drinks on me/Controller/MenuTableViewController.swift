//
//  MenuTableViewController.swift
//  Drinks on me
//
//  Created by JimmyChao on 2023/8/15.
//

import UIKit
import Foundation
import OSLog







class MenuTableViewController: UITableViewController {
    
    let logger = Logger()
    var resultRecords:SearchRecords?
    var tappedDrinks:SearchRecords.Drinks?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(MenuTableViewCell.reuseIdentifier)
        fetchData()
    }

    
    
    // MARK: - API intergration
    
    func fetchData(sortField:String = "tag", sortDirection:String = "asc"){
        
        let urlStr = "https://api.airtable.com/v0/appN21f5f7mgnzUIi/menu?sort%5B0%5D%5Bfield%5D=\(sortField)&sort%5B0%5D%5Bdirection%5D=\(sortDirection)"
        
        if let url = URL(string: urlStr){
            var urlRequest = URLRequest(url: url, cachePolicy: .returnCacheDataElseLoad)
            urlRequest.httpMethod = "GET"
            urlRequest.setValue("Bearer patVvuJLhCGDlIA5N.bb43e3d5bf2d60015a897eff3ed89c044143a0c5fc967a59bcb9d20d8cc5043a", forHTTPHeaderField: "Authorization")
            
            URLSession.shared.dataTask(with: urlRequest) { data, _, _ in
                if let data{
                    let decoder = JSONDecoder()
                    //decoder.dateDecodingStrategy = .iso8601
                    
                    do {
                        let searchRecords = try decoder.decode(SearchRecords.self, from: data)
                        
                        DispatchQueue.main.async {
                            self.resultRecords = searchRecords
                            self.tableView.reloadData()
                        }
                        
                    } catch  {
                        print(error)
                    }
                }
            }.resume()
        }
    }
    
    

    

    // MARK: - Table view datasource functions

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //resultRecords.records.count
        resultRecords?.records.count ?? 50
    }

    
    
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //Dequeue the cell and ensure it's of the correct type.
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MenuTableViewCell.reuseIdentifier, for: indexPath) as? MenuTableViewCell else {
            fatalError("Unable to dequeue a MenuTableViewCell.")
        }
        
        //Attempt to get the record for the current indexPath.
        guard let info = resultRecords?.records[indexPath.row] else {
            cell.nameOfDrink.text = "Data loading"
            return cell
        }
        
        //Set the name of the drink.
        cell.nameOfDrink.text = info.fields.name
        
        //Attempt to load the drink's image.
        if let urlStr = info.fields.image.first?.thumbnails.large.url,
           let imageURL = URL(string: urlStr) {
            
            //Fetch the image data asynchronously.
            URLSession.shared.dataTask(with: imageURL) { data, _, _ in
                // Ensure the data is not nil.
                guard let imageData = data else {
                    return
                }
                
                DispatchQueue.main.async {
                    //Convert the data to a UIImage and set it to the cell's image view.
                    cell.imageOfDrink.image = UIImage(data: imageData)
                }
            }.resume()
        }

        return cell
    }



    
    
    

    
    // MARK: - SEGUEFUNCTION
    

  

    @IBSegueAction func sendDrinkInfo(_ coder: NSCoder) -> DetailTableViewController? {
        let controller = DetailTableViewController(coder: coder)
        
        //Ensure the selected row is avalible
        guard let row = tableView.indexPathForSelectedRow?.row else{
            print("Selected row not found")
            return nil
        }
        
        controller?.drinkInfo = resultRecords?.records[row]

        return controller
    }
    
    
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
