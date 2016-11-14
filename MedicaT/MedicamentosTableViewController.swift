//
//  MedicamentosTableViewController.swift
//  MedicaT
//
//  Created by Alan Valdez on 11/2/16.
//  Copyright © 2016 ITESM. All rights reserved.
//

import UIKit
import CoreData

class MedicamentosTableViewController: UITableViewController {

    var medicamentos : [NSManagedObject]?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        getTableData()
        
        tableView.tableFooterView = UIView()
        
        tableView.tableFooterView?.backgroundColor = UIColor.red
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
        return medicamentos!.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "medicamentoCell", for: indexPath)

        let medicamento = medicamentos![indexPath.row]
        let nombre = (medicamento.value(forKey: "nombre") as! String)
        let presentacion = (medicamento.value(forKey: "presentacion") as! String)
        
        cell.textLabel?.text = nombre
        cell.detailTextLabel?.text = presentacion
        
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
        return cell
    }
    
    func getTableData() {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest : NSFetchRequest<Medicamento> = Medicamento.fetchRequest()
        
        do {
            let results = try managedContext.fetch(fetchRequest)
            medicamentos = results as [NSManagedObject]
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        
        tableView.reloadData()
    }
    
    func deleteMedicamento(medicamento: NSManagedObject) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext
        
        managedContext.delete(medicamento)
        
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
            deleteMedicamento(medicamento: (medicamentos?[indexPath.row])!)
            medicamentos?.remove(at: indexPath.row)
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
        
        if segue.identifier == "crearMedicamento" {
            let newView = segue.destination as! RegistrarMedicamentoTableViewController
            
            newView.accion = "crear"
        }
        
        if segue.identifier == "editarMedicamento" {
            let newView = segue.destination as! RegistrarMedicamentoTableViewController
            
            let indexPath = tableView.indexPathForSelectedRow
            
            newView.accion = "editar"
            newView.medicamento = medicamentos?[(indexPath?.row)!]
        }
        
    }
 
    @IBAction func unwindMedicamentos(segue: UIStoryboardSegue) {
        getTableData()
    }
}