//
//  RegistrarAlarmaTableViewController.swift
//  MedicaT
//
//  Created by alumno on 12/11/16.
//  Copyright © 2016 ITESM. All rights reserved.
//

import UIKit
import CoreData

class RegistrarAlarmaTableViewController: UITableViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    
    var alarma : NSManagedObject?
    var medicamentos : [NSManagedObject]!
    var accion : String!
    let pickerView = UIPickerView()
    let datePicker = UIDatePicker()
    let horas = [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24]
    var medicamentoSeleccionado : NSManagedObject!
    
    @IBOutlet weak var medicamentoField: UITextField!
    @IBOutlet weak var dosisField: UITextField!
    @IBOutlet weak var horasField: UITextField!
    @IBOutlet weak var horaInicioField: UITextField!
    @IBOutlet weak var duracionField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        getTableData()
        prepareDataSources()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

   @IBAction func guardarAlarmas( sender: UIBarButtonItem){
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let managedContext = appDelegate.persistentContainer.viewContext
            
        let entity = NSEntityDescription.entity(forEntityName: "Alarmas",in: managedContext)
        
        let alarmaNueva = NSManagedObject(entity: entity!,insertInto: managedContext)
    
        let fecha = datePicker.date
        let frecuencia = horasField.text!
        let nombre = medicamentoField.text!
        let presentacion = medicamentoSeleccionado.value(forKey: "presentacion")
    
        alarmaNueva.setValue(frecuencia, forKey: "frecuencia")
        alarmaNueva.setValue(fecha, forKey: "fecha")
        alarmaNueva.setValue(nombre, forKey: "nombre")
        alarmaNueva.setValue(presentacion, forKey: "presentacion")
    
        do {
            try managedContext.save()
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }
        
        performSegue(withIdentifier: "unwindAlarmas", sender: self)
    
    }
    
    // MARK: - Table view data source

//    override func numberOfSections(in tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 2
//    }
//
//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        // #warning Incomplete implementation, return the number of rows
//        return 3
//    }
    
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
    
    func prepareDataSources() {
        
        pickerView.delegate = self
        
        datePicker.datePickerMode = .time
        datePicker.addTarget(self, action: #selector(datePickerChanged), for: UIControlEvents.valueChanged)
        
        medicamentoField.inputView = pickerView
        horasField.inputView = pickerView
        
        horaInicioField.inputView = datePicker
        
        medicamentoField.delegate = self
        dosisField.delegate = self
        horasField.delegate = self
        horaInicioField.delegate = self
        duracionField.delegate = self
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if medicamentoField.isFirstResponder {
            return medicamentos.count
        } else if horasField.isFirstResponder {
            return horas.count
        } else {
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if medicamentoField.isFirstResponder {
            
            let medicamento = medicamentos[row]
            medicamentoSeleccionado = medicamento
            
            let nombreMedicamento = medicamento.value(forKey: "nombre")
            
            let presentacionMedicamento = medicamento.value(forKey: "presentacion")
            
            let medidaMedicamento = medicamento.value(forKey: "medida")

            medicamentoField.text = "\(nombreMedicamento!), \(presentacionMedicamento!), \(medidaMedicamento!)"
            
        } else if horasField.isFirstResponder {
            horasField.text = String(horas[row])
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if medicamentoField.isFirstResponder {
            let medicamento = medicamentos[row]
            
            let nombreMedicamento = medicamento.value(forKey: "nombre")
            
            let presentacionMedicamento = medicamento.value(forKey: "presentacion")

            let medidaMedicamento = medicamento.value(forKey: "medida")
            
            return "\(nombreMedicamento!), \(presentacionMedicamento!), \(medidaMedicamento!)"
            
        } else if horasField.isFirstResponder {
            return String(horas[row])
        } else {
            return "Nada"
        }
    }

    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func updatePickerContent() {
        pickerView.reloadAllComponents()
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == horasField {
            updatePickerContent()
        }
        
        if textField == medicamentoField {
            updatePickerContent()
        }
    }
    
    func datePickerChanged(sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "H:mm a"
        horaInicioField.text = dateFormatter.string(from: sender.date)
        
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
