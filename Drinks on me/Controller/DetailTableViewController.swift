//
//  DetailTableViewController.swift
//  Drinks on me
//
//  Created by JimmyChao on 2023/8/17.
//

import UIKit

class DetailTableViewController: UITableViewController {

    
    var drinkInfo:SearchRecords.Drinks?
    
    //Define sections
    struct Section {
        var headerTitle: String?
        var rows: [String]
        var isCollapsed: Bool = false
        var backgroundColor: UIColor
        var selectedRowIndex: Int? = nil
    }


    var sections: [Section] = [
        Section(headerTitle: nil, rows: ["Big Image with Label Title"], backgroundColor: .white),
        Section(headerTitle: "甜度", rows: ["正常糖", "少糖","半糖", "微糖","無糖"], backgroundColor: .init(red: 0.8, green: 0.75, blue: 0.4, alpha: 0.95)),
        
        Section(headerTitle: "冰塊", rows: ["正常冰", "少冰","微冰","去冰", "完全去冰","常溫","溫", "熱"], backgroundColor: .init(red: 0.8, green: 0.75, blue: 0.4, alpha: 0.95))
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
    

    
    
    
    
    

    
    // MARK: - Set data in cell
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: DetailTableViewCell.reuseIdentifier, for: indexPath) as? DetailTableViewCell else{
            fatalError("unable to find cell")
        }
        
    
        let data = sections[indexPath.section].rows[indexPath.row]
        cell.backgroundColor = sections[indexPath.section].backgroundColor
        
        if sections[indexPath.section].isCollapsed {
                cell.contentView.alpha = 0 // Hide content if collapsed
            } else {
                cell.contentView.alpha = 1 // Show content if expanded
            }

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
            
            if sections[indexPath.section].selectedRowIndex == indexPath.row {
            cell.backgroundColor = UIColor(red: 0.6, green: 0.6, blue: 0.2, alpha: 0.95)
            config.image = UIImage(systemName: "circle.circle.fill")
            } else {
            config.image = UIImage(systemName: "circle.circle")
            }
            config.imageProperties.tintColor = .brown
            cell.contentConfiguration = config
            
        }
        return cell
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
        return 50 // Default header height
    }
    
    
    
    
    
    // MARK: - Tapped action
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section > 0 {
            // Update the selected row index for the section
            sections[indexPath.section].selectedRowIndex = indexPath.row
            
            // Get all rows within the section to be reloaded
            let rowsInRange = 0..<sections[indexPath.section].rows.count
            let indexPathsToReload = rowsInRange.map { IndexPath(row: $0, section: indexPath.section) }
            
            // Reload the rows without affecting the header
            UIView.performWithoutAnimation {
                tableView.reloadRows(at: indexPathsToReload, with: .none)
            }
        }
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
