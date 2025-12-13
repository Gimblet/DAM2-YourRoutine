//
//  RutinaDAO.swift
//  YourRoutine
//
//  Created by gimblet on 10/12/25.
//

import UIKit

class RutinaDAO : IRutinaMetodos {
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    func save(bean: RutinaEntity, etiqueta: EtiquetaEntity) -> Int {
        var salida = -1

        do{
            try context.save()
            salida=1
        }
        catch let x as NSError{
            print(x.localizedDescription)
        }
        return salida
    }
    
    func findAll() -> [RutinaEntity] {
        var lista: [RutinaEntity] = []
        do{
            let rutinas=RutinaEntity.fetchRequest()
            lista=try context.fetch(rutinas)
        }
        catch let x as NSError{
            print(x.localizedDescription)
        }
        return lista
    }
    
    func update(bean: RutinaEntity) -> Int {
        return 0
    }
    
    // Data Temporal
    
    func addDiaTemporal(etiqueta:String) {
        let previousData = UserDefaults.standard.value(forKey: "dias") as? [String]
        
        if(previousData != nil) {
            var etiquetaArray:[String] = previousData!
            etiquetaArray.append(etiqueta)
            UserDefaults.standard.set(etiquetaArray, forKey: "dias")
        } else {
            var newEtiquetaArray:[String] = []
            newEtiquetaArray.append(etiqueta)
            UserDefaults.standard.set(newEtiquetaArray, forKey: "dias")
        }
    }
    
    func getDiaTemporal() -> [String] {
        let previousData = UserDefaults.standard.value(forKey: "dias") as? [String]
        if (previousData != nil) {
            return previousData.unsafelyUnwrapped
        }
        return []
    }
    
    func removeDiaTemporal(etiqueta:String) {
        var previousData = UserDefaults.standard.value(forKey: "dias") as! [String]
        var i:Int = 0
        while previousData.count < i {
            if(previousData[i] == etiqueta) {
                previousData.remove(at: i)
            }
            i = i + 1;
        }
    }
    
    func clearTemporal() {
        UserDefaults.standard.removeObject(forKey: "dias")
    }
    

}
