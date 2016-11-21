//
//  AlarmasTableViewController.swift
//  MedicaT
//
//  Created by alumno on 12/11/16.
//  Copyright © 2016 ITESM. All rights reserved.
//

import UIKit
import CoreData

class AlarmasTableViewController: UITableViewController {

     var alarmas : [NSManagedObject]!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
         getTableData()
        tableView.tableFooterView = UIView()
        
        tableView.tableFooterView?.backgroundColor = UIColor.red
        
        //deleteAlarma(alarma:  alarmas[2])
        
       
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
        return alarmas!.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "alarmaCell", for: indexPath)
        
         let alarma = alarmas![indexPath.row]
      
        let presentacion = alarma.value(forKey: "presentacion") as! String
        let fecha = alarma.value(forKey: "fecha") as! Date
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy H:mm a"
        
        cell.textLabel?.text = alarma.value(forKey: "nombre") as! String?
        cell.detailTextLabel?.text = "Inicio: \(dateFormatter.string(from: fecha))"
        
        if presentacion == "Cápsulas" || presentacion == "Pastillas" || presentacion == "Tabletas" {
            cell.imageView?.image = UIImage(named: "pildora")
        }
        
        if presentacion == "Inyección" {
            cell.imageView?.image = UIImage(named: "inyeccion")
        }
        
        if presentacion == "Gotas nasales" || presentacion == "Gotas ópticas" {
            cell.imageView?.image = UIImage(named: "gotas")
        }
        
        if presentacion == "Pomada" {
            cell.imageView?.image = UIImage(named: "crema")
        }
  
    
        // Configure the cell...

        return cell
    }
    
    func getTableData() {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest : NSFetchRequest<Alarmas> = Alarmas.fetchRequest()
        fetchRequest.returnsObjectsAsFaults = false
        
        do {
            let results = try managedContext.fetch(fetchRequest)
           alarmas = results as [NSManagedObject]
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        
        tableView.reloadData()
    }
    
    func deleteAlarma(alarma: NSManagedObject) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext
        
        managedContext.delete(alarma)
        
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        
        tableView.reloadData()
        
    }


    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

   
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            deleteAlarma(alarma: (alarmas?[indexPath.row])!)
            alarmas?.remove(at: indexPath.row)
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

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "crearAlarma" {
            let newView = segue.destination as! RegistrarAlarmaTableViewController
            
            newView.accion = "crear"
        }
        
        if segue.identifier == "editarAlarma" {
            let newView = segue.destination as! RegistrarAlarmaTableViewController
            
            let indexPath = tableView.indexPathForSelectedRow
            newView.accion = "editar"
          newView.alarma  = alarmas?[(indexPath?.row)!]
        }
    }
    
     @IBAction func unwindAlarmas(segue: UIStoryboardSegue) {
        getTableData()
    }

}
