//
//  InformacionPersonalTableViewController.swift
//  MedicaT
//
//  Created by Alan Valdez on 10/19/16.
//  Copyright © 2016 ITESM. All rights reserved.
//

import UIKit

class InformacionPersonalTableViewController: UITableViewController {

    @IBOutlet weak var profileImage: UIImageView!
    var rol : String!
    
    @IBOutlet weak var nombreField: UITextField!
    @IBOutlet weak var telefonoField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    
    let userPrefs = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        //
        
        navigationItem.title = rol
        navigationItem.titleView?.tintColor = UIColor.white
        
        switch rol {
        case "Paciente":
            
            let paciente = userPrefs.value(forKey: "paciente") as? [String:String]
            
            if paciente != nil {
                nombreField.text = paciente?["nombre"]
                telefonoField.text = paciente?["telefono"]
            }
            
            break
        case "Médico":
            let medico = userPrefs.value(forKey: "medico") as? [String:String]
            if medico != nil {
                nombreField.text = medico?["nombre"]
                telefonoField.text = medico?["telefono"]
                emailField.text = medico?["email"]
            }
            
            print(medico)
            break
        case "Responsable":
            let responsable = userPrefs.value(forKey: "responsable") as? [String:String]
            
            if responsable != nil {
                nombreField.text = responsable?["nombre"]
                telefonoField.text = responsable?["telefono"]
                emailField.text = responsable?["email"]
            }
            
            print(responsable)
            break
        default:
            break
        }
        
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
        if rol == "Paciente" {
            return 3
        } else {
            return 4
        }
    }

    @IBAction func saveInformation(_ sender: UIBarButtonItem) {
        
        let nombre = nombreField.text!
        let telefono = telefonoField.text!
        let email = emailField.text!
        
        if nombre != "" && telefono != "" && rol == "Paciente" {
            
            let paciente : Dictionary = ["nombre" : nombre, "telefono" : telefono]
            
            userPrefs.set(paciente, forKey: "paciente")
            
           _ = navigationController?.popViewController(animated: true)
            
        } else if nombre != "" && telefono != "" && email != "" {
            
            switch rol {
            case "Médico":
                let medico : Dictionary = ["nombre" : nombre, "telefono" : telefono, "email" : email]
                
                userPrefs.set(medico, forKey: "medico")
                break
            case "Responsable":
                let responsable : Dictionary = ["nombre" : nombre, "telefono" : telefono, "email" : email]
                
                userPrefs.set(responsable, forKey: "responsable")
                break
            default:
                break
            }
            
           _ = navigationController?.popViewController(animated: true)
            
        } else {
            
            let alert = UIAlertController(title: "Error", message: "Información no válida. Favor de ingresar la información necesaria.", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            
            present(alert, animated: true, completion: nil)
            
        }
    }
    
    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
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
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
