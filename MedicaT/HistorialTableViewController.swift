//
//  HistorialTableViewController.swift
//  MedicaT
//
//  Created by alumno on 21/11/16.
//  Copyright © 2016 ITESM. All rights reserved.
//

import UIKit
import CoreData

class HistorialTableViewController: UITableViewController {
  
  var registros : [NSManagedObject]!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        
        tableView.refreshControl?.addTarget(self, action: #selector(refreshTable), for: .valueChanged)
        
      getTableData()
      tableView.tableFooterView = UIView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return registros.count
    }
  
  func getTableData() {
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let managedContext = appDelegate.persistentContainer.viewContext
    
    let fetchRequest : NSFetchRequest<Historial> = Historial.fetchRequest()
    fetchRequest.returnsObjectsAsFaults = false
    
    do {
      let results = try managedContext.fetch(fetchRequest)
      registros = results as [NSManagedObject]
    } catch let error as NSError {
      print("Could not fetch \(error), \(error.userInfo)")
    }
    
    tableView.reloadData()
  }

  
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
      
        let registro = registros[indexPath.row]
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy H:mm a"
      
        let medicamento = registro.value(forKey: "medicamento") as! String
        let tomado = registro.value(forKey: "tomada") as! Bool
        let fecha = registro.value(forKey: "fecha") as! Date
      
        cell.textLabel?.text = medicamento
        cell.detailTextLabel?.text = "Tomado: \(tomado ? "Si" : "No"), Fecha: \(dateFormatter.string(from: fecha))"
        let blueColor = UIColor(red: (110/255.0), green: (171/255.0), blue: (247/255.0), alpha: 1.0)
        let redColor = UIColor(red: (253/255) as CGFloat, green: (118/255) as CGFloat, blue: (120/255) as CGFloat, alpha: 1.0 as CGFloat)
      
      if tomado {
        cell.detailTextLabel?.textColor = blueColor
        cell.imageView?.image = UIImage(named: "tomado")
      } else {
        cell.detailTextLabel?.textColor = redColor
        cell.imageView?.image = UIImage(named: "noTomado")
      }

        return cell
    }
 

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */
  
  func deleteRegistro(registro: NSManagedObject) {
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let managedContext = appDelegate.persistentContainer.viewContext
    
    managedContext.delete(registro)
    
    do {
      try managedContext.save()
    } catch let error as NSError {
      print("Could not fetch \(error), \(error.userInfo)")
    }
    
    tableView.reloadData()
    
  }
    
    func refreshTable() {
        getTableData()
        refreshControl?.endRefreshing()
    }


  
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
          deleteRegistro(registro: registros[indexPath.row])
          registros.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
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
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
