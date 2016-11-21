//
//  AppDelegate.swift
//  MedicaT
//
//  Created by Alan Valdez on 10/19/16.
//  Copyright © 2016 ITESM. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let userPrefs = UserDefaults.standard

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        
        let registrado = userPrefs.bool(forKey: "registrado")
        
        if registrado {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            
            let newView = storyboard.instantiateViewController(withIdentifier: "mainMenu")
            
            window?.rootViewController = newView
        }
        
        UINavigationBar.appearance().tintColor = UIColor.white
      
        
      //Actions para las notificaciones
      
      let okAction:UIMutableUserNotificationAction = UIMutableUserNotificationAction()
      okAction.identifier = "OK_ACTION"
      okAction.title = "OK"
      
      okAction.activationMode = UIUserNotificationActivationMode.background
      okAction.isDestructive = false
      okAction.isAuthenticationRequired = false
      
      let DespuesAction:UIMutableUserNotificationAction = UIMutableUserNotificationAction()
      DespuesAction.identifier = "DESPUES_ACTION"
      DespuesAction.title = "Recuerdame en 5 minutos"
      
      DespuesAction.activationMode = UIUserNotificationActivationMode.background
      DespuesAction.isDestructive = false
      DespuesAction.isAuthenticationRequired = false
      
      let ahoraNoAction:UIMutableUserNotificationAction = UIMutableUserNotificationAction()
      ahoraNoAction.identifier = "AHORA_NO_ACTION"
      ahoraNoAction.title = "Ahora no"
      
      ahoraNoAction.activationMode = UIUserNotificationActivationMode.foreground
      ahoraNoAction.isDestructive = false
      ahoraNoAction.isAuthenticationRequired = false
      
      //Category para las notificaciones
      
      let category:UIMutableUserNotificationCategory = UIMutableUserNotificationCategory()
      category.identifier = "CATEGORY"
      
      let defaultActions:NSArray = [okAction, ahoraNoAction, DespuesAction]
      let minimalActions:NSArray = [okAction, ahoraNoAction]
      
      category.setActions(defaultActions as! [UIUserNotificationAction], for: UIUserNotificationActionContext.default)
      category.setActions(minimalActions as! [UIUserNotificationAction], for: UIUserNotificationActionContext.minimal)
      
      let categories:NSSet = NSSet(object: category)
      
      //Notification Settings
      
      let mySettings = UIUserNotificationSettings(types: [.badge, .alert], categories: categories as! Set<UIUserNotificationCategory>)
      
      UIApplication.shared.registerUserNotificationSettings(mySettings)
      
      
      // Override point for customization after application launch.
      return true
  }
  
  // crea la notificacion
  func createLocalNotification(firedate: NSDate, notification: UILocalNotification)
  {
    
    notification.fireDate = firedate as Date
    UIApplication.shared.scheduleLocalNotification(notification)
    
  }
  
  
  //Acciones que toma despues de hacer click en la notificacion
  func application(_ application: UIApplication, handleActionWithIdentifier identifier: String?, for notification: UILocalNotification, completionHandler: @escaping () -> Void) {
    
    let id = notification.userInfo?["id"] as! String
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let managedContext = appDelegate.persistentContainer.viewContext

    let alarma : NSManagedObject!
    
    let fetchRequest : NSFetchRequest<Alarmas> = Alarmas.fetchRequest()
    fetchRequest.predicate = NSPredicate(format: "id == %@", id)
    
    do{
      let results = try managedContext.fetch(fetchRequest)
      alarma = results[0] as NSManagedObject

    }catch let error as NSError {
      fatalError("error, could not fetch alarma from notifications")
    }
    
    let alertaActual = alarma.value(forKey: "siguienteAlerta") as! Date
    let alertasTotales = alarma.value(forKey: "alertasTotales") as! Int
    var alertasMostradas = alarma.value(forKey: "alertasMostradas") as! Int
    let nombreMedicamento = alarma.value(forKey: "nombre") as! String
    let frecuenciaString = alarma.value(forKey: "frecuencia") as! String
    let frecuencia = Double(frecuenciaString)
    
    if identifier == "AHORA_NO_ACTION"{
      
      let entity = NSEntityDescription.entity(forEntityName: "Historial", in: managedContext)
      let record = NSManagedObject(entity: entity!, insertInto: managedContext)
      
      record.setValue(alertaActual, forKey: "fecha")
      record.setValue(false, forKey: "tomada")
      record.setValue(nombreMedicamento, forKey: "medicamento")
      
      let siguienteAlerta = alertaActual.addingTimeInterval(60 * 60 * frecuencia!)
      
      alertasMostradas = alertasMostradas + 1
      
      if (alertasMostradas < alertasTotales) {
        
        alarma.setValue(siguienteAlerta, forKey: "siguienteAlerta")
        alarma.setValue(alertasMostradas, forKey: "alertasMostradas")
        self.createLocalNotification(firedate: siguienteAlerta as NSDate, notification: notification)

      }
      
      do {
        try managedContext.save()
      }   catch let error as NSError  {
        print("Could not save \(error), \(error.userInfo)")
      }
    }
    
    if identifier == "OK_ACTION"{

      let entity = NSEntityDescription.entity(forEntityName: "Historial", in: managedContext)
      let record = NSManagedObject(entity: entity!, insertInto: managedContext)
      
      record.setValue(alertaActual, forKey: "fecha")
      record.setValue(true, forKey: "tomada")
      record.setValue(nombreMedicamento, forKey: "medicamento")
      
      let siguienteAlerta = alertaActual.addingTimeInterval(60 * 60 * frecuencia!)
      
      alertasMostradas = alertasMostradas + 1
      
      if (alertasMostradas < alertasTotales) {
        
        alarma.setValue(siguienteAlerta, forKey: "siguienteAlerta")
        alarma.setValue(alertasMostradas, forKey: "alertasMostradas")
        self.createLocalNotification(firedate: siguienteAlerta as NSDate, notification: notification)
        
      }
      
      do {
        try managedContext.save()
      }   catch let error as NSError  {
        print("Could not save \(error), \(error.userInfo)")
      }
    }
    
    if identifier == "DESPUES_ACTION"{
      self.createLocalNotification(firedate: NSDate(timeIntervalSinceNow: 300), notification: notification)
    }
  }


    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "MedicaT")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}

