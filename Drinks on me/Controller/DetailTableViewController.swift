//
//  DetailTableViewController.swift
//  Drinks on me
//
//  Created by JimmyChao on 2023/8/17.
//

import UIKit

class DetailTableViewController: UITableViewController {

    
    var drinkInfo:SearchRecords.Drinks?
    
    //Define struct
    struct Section {
        var headerTitle: String?
        var rows: [String]
    }

    
    var sections: [Section] = [
        Section(headerTitle: nil, rows: ["Big Image with Label Title"]),
        Section(headerTitle: "甜度", rows: ["正常糖", "少糖","半糖", "微糖","無糖"]),
        
        Section(headerTitle: "冰塊", rows: ["正常冰", "少冰","微冰","去冰", "完全去冰","常溫","溫", "熱"])
        // Add more sections as needed
    ]

    

    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        //tableView.register(UITableViewCell.self, forCellReuseIdentifier: "CellIdentifier")

        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    

    
    
    
    
    
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        sections.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        sections[section].rows.count
    }

    
    // MARK: - SETDATA IN CELL
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: DetailTableViewCell.reuseIdentifier, for: indexPath) as? DetailTableViewCell else{
            fatalError("unable to find cell")
        }
        
    
        let data = sections[indexPath.section].rows[indexPath.row]
        if indexPath.section == 0 {
            // Configure for big image with label
            
            guard let drinkInfo else{
                print("drinkInfo found nil")
                return cell
            }
            
            fetchAndSet(info: drinkInfo) { imageData in
                cell.drinkImage.image = UIImage(data: imageData)
                cell.drinkImage.contentMode = .scaleAspectFill
            }
            
            cell.drinkName.text = drinkInfo.fields.name
            cell.minPrice.text = "$ \(drinkInfo.fields.medium) 起"
            cell.drinkDescription.text = drinkInfo.fields.description

            
        } else {
            // Configure for normal row
            var config = UIListContentConfiguration.cell()
            config.text = data
            config.image = UIImage(systemName: "circle.circle")?.withTintColor(.red)
            cell.contentConfiguration = config
        }
        
        return cell
    }
    

    
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section].headerTitle
    }
    
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 450
            // Height for the big image row
        }
        return 44 // Default row height
    }
    

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return CGFloat.leastNormalMagnitude // Essentially 'hides' the header
        }
        return 44 // Default header height
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
