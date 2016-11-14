//
//  Alarmas+CoreDataProperties.swift
//  MedicaT
//
//  Created by alumno on 12/11/16.
//  Copyright © 2016 ITESM. All rights reserved.
//  This file was automatically generated and should not be edited.
//

import Foundation
import CoreData


extension Alarmas {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Alarmas> {
        return NSFetchRequest<Alarmas>(entityName: "Alarmas");
    }

    @NSManaged public var frecuencia: String?
    @NSManaged public var medicamentoAlarma: Medicamento?

}
