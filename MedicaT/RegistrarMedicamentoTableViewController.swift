//
//  RegistrarMedicamentoTableViewController.swift
//  MedicaT
//
//  Created by Alan Valdez on 11/2/16.
//  Copyright © 2016 ITESM. All rights reserved.
//

import UIKit
import CoreData

class RegistrarMedicamentoTableViewController: UITableViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    
    @IBOutlet weak var nombreField: UITextField!
    @IBOutlet weak var medidaField: UITextField!
    @IBOutlet weak var presentacionField: UITextField!
    @IBOutlet weak var notasTextView: UITextView!
    @IBOutlet weak var tipoMedidaField: UITextField!
    
    let pickerView = UIPickerView()
    var medicamento : NSManagedObject?
    var accion : String!
    
    let presentaciones = ["Aerosol", "Cápsulas", "Emulsión", "Gotas nasales", "Gotas ópticas", "Inyección", "Jarabe", "Tabletas", "Pomada", "Pastillas"]
    
    let medidas = ["ml", "l", "mg", "g", "kg"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        tipoMedidaField.text = "ml"
        
        preparePickerViews()
        prepareAccesoryViews()
        
        if accion == "editar" {
            nombreField.text = (medicamento?.value(forKey: "nombre") as! String)
            
            medidaField.text = "\(medicamento?.value(forKey: "medida") as! Float)"
            
            presentacionField.text = (medicamento?.value(forKey: "presentacion") as! String)
            
            notasTextView.text = medicamento?.value(forKey: "notas") as! String
            
            tipoMedidaField.text = medicamento?.value(forKey: "tipoMedida") as! String
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
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if presentacionField.isFirstResponder {
            return presentaciones.count
        } else if tipoMedidaField.isFirstResponder {
            return medidas.count
        } else {
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if presentacionField.isFirstResponder {
            return presentaciones[row]
        } else if tipoMedidaField.isFirstResponder {
            return medidas[row]
        } else {
            return "Nada"
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if presentacionField.isFirstResponder {
            presentacionField.text = presentaciones[row]
        } else if tipoMedidaField.isFirstResponder {
            tipoMedidaField.text = medidas[row]
        }
    }
    
    @IBAction func guardarMedicamento(_ sender: UIBarButtonItem) {
        
        if nombreField.text != "" && medidaField.text != "" && presentacionField.text != "" {
            
            let nombre = nombreField.text!
            let medida = Float(medidaField.text!)
            let presentacion = presentacionField.text!
            var notas = ""
            let tipoMedida = tipoMedidaField.text!
            
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            
            let managedContext = appDelegate.persistentContainer.viewContext

            if accion == "crear" {
                
                if notasTextView.text != "" {
                    notas = notasTextView.text!
                }
                
                let entity = NSEntityDescription.entity(forEntityName: "Medicamento",in: managedContext)
                
                let medicamentoNuevo = NSManagedObject(entity: entity!,insertInto: managedContext)
                
                //3
                medicamentoNuevo.setValue(nombre, forKey: "nombre")
                medicamentoNuevo.setValue(medida, forKey: "medida")
                medicamentoNuevo.setValue(presentacion, forKey: "presentacion")
                medicamentoNuevo.setValue(notas, forKey: "notas")
                medicamentoNuevo.setValue(tipoMedida, forKey: "tipoMedida")
                
                //4
                do {
                    try managedContext.save()
                } catch let error as NSError  {
                    print("Could not save \(error), \(error.userInfo)")
                }
                
                performSegue(withIdentifier: "unwindMedicamentos", sender: self)
                
            } else {
                medicamento?.setValue(nombre, forKey: "nombre")
                medicamento?.setValue(medida, forKey: "medida")
                medicamento?.setValue(presentacion, forKey: "presentacion")
                medicamento?.setValue(notas, forKey: "notas")
                medicamento?.setValue(tipoMedida, forKey: "tipoMedida")
                
                //4
                do {
                    try managedContext.save()
                } catch let error as NSError  {
                    print("Could not save \(error), \(error.userInfo)")
                }
                
                performSegue(withIdentifier: "unwindMedicamentos", sender: self)
            }
        } else {
            let alert = UIAlertController(title: "Error", message: "La información que se proporcionó no es válida o está incompleta.", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            
            present(alert, animated: true, completion: nil)
        }
    }
    
    func preparePickerViews() {
        
        pickerView.delegate = self
        
        presentacionField.inputView = pickerView
        tipoMedidaField.inputView = pickerView
    }
    
    func prepareAccesoryViews() {
        
        let accessoryView = UIToolbar()
        
        let accessoryButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(dismissKeyboard))
        let accessorySpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        
        let items = [accessorySpace, accessoryButton]
        
        accessoryButton.tintColor = UIColor.white
        
        accessoryView.barStyle = .default
        accessoryView.backgroundColor = UIColor.darkGray
        accessoryView.items = items
        accessoryView.isTranslucent = false
        accessoryView.barTintColor = UIColor.darkGray
        accessoryView.isUserInteractionEnabled = true
        accessoryView.sizeToFit()
        
        nombreField.inputAccessoryView = accessoryView
        medidaField.inputAccessoryView = accessoryView
        presentacionField.inputAccessoryView = accessoryView
        notasTextView.inputAccessoryView = accessoryView
        tipoMedidaField.inputAccessoryView = accessoryView
        
        nombreField.delegate = self
        medidaField.delegate = self
        presentacionField.delegate = self
        tipoMedidaField.delegate = self
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func updatePickerContent() {
        pickerView.reloadAllComponents()
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == presentacionField {
            updatePickerContent()
        }
        
        if textField == tipoMedidaField {
            updatePickerContent()
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
