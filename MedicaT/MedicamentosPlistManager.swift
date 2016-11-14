//
//  MedicamentosPlistManager.swift
//  MedicaT
//
//  Created by Alan Valdez on 11/2/16.
//  Copyright © 2016 ITESM. All rights reserved.
//

import Foundation

class MedicamentosPlistManager {
    
    func getMedicamentosPlist() ->  String {
       let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        
        let documentsDirectory = paths[0]
        
        return documentsDirectory.appending("/medicamentos.plist")
    }
    
}
