//
//  RegistrarAlarmaTableViewController.swift
//  MedicaT
//
//  Created by alumno on 12/11/16.
//  Copyright © 2016 ITESM. All rights reserved.
//

import UIKit
import CoreData
import UserNotifications

class RegistrarAlarmaTableViewController: UITableViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    
    var alarma : NSManagedObject?
    var medicamentos : [NSManagedObject]!
    var accion : String!
    let pickerView = UIPickerView()
    let datePicker = UIDatePicker()
    let horas = [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24]
    var medicamentoSeleccionado : NSManagedObject!
    // variable que guarda la presentacion de la alarma a editar
    var presentacionAnt : String!
    // si la presentacion de una alarma editada fue cambiada ==
    var newPresentacion = false
    
    
    
    
    @IBOutlet weak var medicamentoField: UITextField!
    @IBOutlet weak var dosisField: UITextField!
    @IBOutlet weak var horasField: UITextField!
    @IBOutlet weak var horaInicioField: UITextField!
    @IBOutlet weak var duracionField: UITextField!
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        getTableData()
        
        navigationItem.titleView?.tintColor = UIColor.white
        
        prepareDataSources()
        prepareAccesoryViews()
        
        if accion == "editar" {
            let duracionAux = alarma!.value(forKey: "duracion")
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "H:mm a"
            
            let frecuenciaString = alarma?.value(forKey: "frecuencia") as! String
            let frecuencia = Double(frecuenciaString)
            
            let horainicio =  alarma!.value(forKey: "fecha") as! Date
            horaInicioField.text = dateFormatter.string(from: horainicio)
            medicamentoField.text = (alarma?.value(forKey: "nombre") as! String)
            dosisField.text = "\(alarma?.value(forKey: "dosis") as! Float)"
            duracionField.text = String(describing: duracionAux!)
            horasField.text = (alarma?.value(forKey: "frecuencia") as! String)
            presentacionAnt = alarma?.value(forKey: "presentacion") as! String
            
            let horaNueva = horainicio.addingTimeInterval(60.0*60.0*frecuencia!)
            print("hora nueva: \(horaNueva)")
            
            print(dateFormatter.string(from: horaNueva))
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

   @IBAction func guardarAlarmas( sender: UIBarButtonItem){
    if medicamentoField.text != "" && dosisField.text != "" && horasField.text != "" && horaInicioField.text != "" && duracionField.text != "" {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext
    
        let fecha = datePicker.date
        _ = fecha.addingTimeInterval(60*60 * -6)
      
        let frecuencia = horasField.text!
        let nombre = medicamentoField.text!
        //debugPrint(medicamentoSeleccionado.value(forKey: "presentacion"))
        var  presentacion = ""
        if(newPresentacion == true){
         presentacion = (medicamentoSeleccionado.value(forKey: "presentacion") as! String)
        }
    
        let duracion = Int(duracionField.text!)
        let dosis = Float(dosisField.text!)
        
        let id = "\(nombre),\(fecha),\(frecuencia),\(duracion!),\(dosis!)"
        let alertasTotales = (24/Int(frecuencia)!) * duracion!
        let siguienteFecha = fecha.addingTimeInterval(60*60*Double(frecuencia)!)
        
    if accion == "crear" {
        let entity = NSEntityDescription.entity(forEntityName: "Alarmas",in: managedContext)
        let alarmaNueva = NSManagedObject(entity: entity!,insertInto: managedContext)
        
        alarmaNueva.setValue(frecuencia, forKey: "frecuencia")
        alarmaNueva.setValue(fecha, forKey: "fecha")
        alarmaNueva.setValue(nombre, forKey: "nombre")
        alarmaNueva.setValue(presentacion, forKey: "presentacion")
        alarmaNueva.setValue(duracion, forKey: "duracion")
        alarmaNueva.setValue(dosis, forKey: "dosis")
        
        alarmaNueva.setValue(id, forKey: "id")
        alarmaNueva.setValue(alertasTotales, forKey: "alertasTotales")
        alarmaNueva.setValue(0, forKey: "alertasMostradas")
        alarmaNueva.setValue(siguienteFecha, forKey: "siguienteAlerta")
        
        do {
            try managedContext.save()
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }
      
        self.createLocalNotification(firedate: siguienteFecha as NSDate, medicamento: nombre, id: id)
      
        performSegue(withIdentifier: "unwindAlarmas", sender: self)
    }
    else {
        if( presentacion != "")
        {alarma?.setValue(presentacion, forKey: "presentacion")}
        else{
          
          let antiguoId = alarma?.value(forKey: "id")
          
          cancelNotification(id: antiguoId as! String)
          
        alarma?.setValue(presentacionAnt, forKey: "presentacion")
        }
        alarma?.setValue(frecuencia, forKey: "frecuencia")
        alarma?.setValue(fecha, forKey: "fecha")
        alarma?.setValue(nombre, forKey: "nombre")
        
        alarma?.setValue(duracion, forKey: "duracion")
        alarma?.setValue(dosis, forKey: "dosis")
        alarma?.setValue(id, forKey: "id")
        alarma?.setValue(alertasTotales, forKey: "alertasTotales")
        alarma?.setValue(0, forKey: "alertasMostradas")
        alarma?.setValue(siguienteFecha, forKey: "siguienteAlerta")
        
        do {
            try managedContext.save()
            }   catch let error as NSError  {
                print("Could not save \(error), \(error.userInfo)")
                }
      
        self.createLocalNotification(firedate: siguienteFecha as NSDate, medicamento: nombre, id: id)
      
        performSegue(withIdentifier: "unwindAlarmas", sender: self)
    
        }
    } else {
        let alert = UIAlertController(title: "Error", message: "La información que se proporcionó no es válida o está incompleta.", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        
        present(alert, animated: true, completion: nil)
    }
   
    }
  
  func createLocalNotification(firedate: NSDate, medicamento: String, id: String)
  {
    let localNotification = UNMutableNotificationContent()
    
    localNotification.categoryIdentifier = "CATEGORY"
    localNotification.title = "Recordatorio"
    
    localNotification.userInfo = [
      "message" : "tienes una notificacion",
      "id" : id,
      "medicamento" : medicamento
    ]
    
    localNotification.sound = UNNotificationSound.default()
    localNotification.body = "Es hora de tomar tu medicamento: \(medicamento)"
    
    let timeInterval = firedate.timeIntervalSince(Date())
    
    let trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeInterval, repeats: false)
    
    print(timeInterval)
    
    let request = UNNotificationRequest(identifier: id, content: localNotification, trigger: trigger)
    
    UNUserNotificationCenter.current().add(request) {(error) in
      if let error = error {
        print("Uh oh! We had an error: \(error)")
      }
    }
    
  }
  
  func cancelNotification(id: String){
    
    let app:UIApplication = UIApplication.shared
    
    for oneEvent in app.scheduledLocalNotifications! {
      let notification = oneEvent as UILocalNotification
      if notification.userInfo?["id"] as! String == id {
        //Cancelling local notification
        app.cancelLocalNotification(notification)
        break;
      }
    }
    
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
        
        if medicamentos.count == 0 {
            let alert = UIAlertController(title: "No hay medicamentos", message: "Para crear una alarma se tiene que tener registrado al menos un medicamento.", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (UIAlertAction) in
                _ = self.navigationController?.popToRootViewController(animated: true)
            }))
            
            present(alert, animated: true, completion: nil)
            
        } else {
        
            tableView.reloadData()
        }
    }
    
    func prepareDataSources() {
        
        pickerView.delegate = self
        
        datePicker.datePickerMode = .dateAndTime
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
            newPresentacion = true
            let medidaMedicamento = medicamento.value(forKey: "medida")
            let tipoMedida = medicamento.value(forKey: "tipoMedida")

            medicamentoField.text = "\(nombreMedicamento!), \(presentacionMedicamento!), \(medidaMedicamento!) \(tipoMedida!)"
            
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
            let tipoMedida = medicamento.value(forKey: "tipoMedida")
            
            return "\(nombreMedicamento!), \(presentacionMedicamento!), \(medidaMedicamento!) \(tipoMedida!)"
            
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
  
  func prepareAccesoryViews() {
    
    let accessoryView = UIToolbar()
    
    let accessoryButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(dismissKeyboard))
    let accessorySpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
    
    let items = [accessorySpace, accessoryButton]
    
    accessoryButton.tintColor = UIColor.white
    
    accessoryView.barStyle = .default
    accessoryView.backgroundColor = UIColor(red: (110/255.0) as CGFloat, green: (171/255) as CGFloat, blue: (247/255) as CGFloat, alpha: 1.0 as CGFloat)
    accessoryView.items = items
    accessoryView.isTranslucent = false
    accessoryView.barTintColor = UIColor(red: (110/255.0) as CGFloat, green: (171/255) as CGFloat, blue: (247/255) as CGFloat, alpha: 1.0 as CGFloat)
    accessoryView.isUserInteractionEnabled = true
    accessoryView.sizeToFit()
    
    medicamentoField.inputAccessoryView = accessoryView
    dosisField.inputAccessoryView = accessoryView
    horasField.inputAccessoryView = accessoryView
    horaInicioField.inputAccessoryView = accessoryView
    duracionField.inputAccessoryView = accessoryView
    
    
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
