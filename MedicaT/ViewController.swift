//
//  ViewController.swift
//  MedicaT
//
//  Created by Alan Valdez on 10/19/16.
//  Copyright © 2016 ITESM. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    let userPrefs = UserDefaults.standard
    
    let roles = ["Paciente", "Médico", "Responsable"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return roles.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reusableCell")!
        
        cell.textLabel?.text = roles[indexPath.row]
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "enterInfo" {
            let newView = segue.destination as! InformacionPersonalTableViewController
            
            let indexPath = tableView.indexPathForSelectedRow
            
            newView.rol = roles[(indexPath?.row)!]
        }
        
    }
    
    @IBAction func saveUserInformation(_ sender: UIBarButtonItem) {
        let paciente = userPrefs.value(forKey: "paciente") as? [String:String]
        
        if paciente != nil {
            
            userPrefs.set(true, forKey: "registrado")
            performSegue(withIdentifier: "mainMenu", sender: self)
            
        } else {
            let alert = UIAlertController(title: "Error", message: "Favor de registrar la información del paciente.", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            
            present(alert, animated: true, completion: nil)
        }
    }
}

