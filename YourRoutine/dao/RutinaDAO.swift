//
//  RutinaDAO.swift
//  YourRoutine
//
//  Created by gimblet on 10/12/25.
//

import UIKit

class RutinaDAO : IRutinaMetodos {
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    func save(bean: RutinaEntity, etiquetas: [EtiquetaEntity]) -> Int {
        var salida = -1

        do {
            
            for e in etiquetas {
                bean.addToEtiqueta(e)
            }
            
            try context.save()
            salida = 1
        }
        catch let x as NSError{
            print(x.localizedDescription)
        }
        return salida
    }
    
    func findAll() -> [RutinaEntity] {
        var lista: [RutinaEntity] = []
        do{
            let rutinas = RutinaEntity.fetchRequest()
            lista = try context.fetch(rutinas)
        }
        catch let x as NSError{
            print(x.localizedDescription)
        }
        return lista
    }
    
    func findCurrent() -> RutinaEntity? {
            func timeToInt(_ timeString: String?) -> Int? {
                guard let time = timeString else { return nil }
                let components = time.split(separator: ":")
                guard components.count == 2,
                      let hours = Int(components[0]),
                      let minutes = Int(components[1]) else { return nil }
                return hours * 100 + minutes
            }
            
            let calendar = Calendar.current
            let now = Date()
            let currentHour = calendar.component(.hour, from: now)
            let currentMinute = calendar.component(.minute, from: now)
            let currentTime = currentHour * 100 + currentMinute
            
            let fetchRequest = RutinaEntity.fetchRequest()
            
            do {
                let rutinas = try context.fetch(fetchRequest)
                
                return rutinas.first { routine in
                    guard let initTime = timeToInt(routine.inicio),
                          let endTime = timeToInt(routine.fin) else { return false }
                    return currentTime >= initTime && currentTime <= endTime
                }
            } catch {
                print("Error fetching routines: \(error)")
                return nil
            }
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
    
    func removeDiaTemporal(dia:String) {
        var previousData = UserDefaults.standard.value(forKey: "dias") as! [String]
        var i:Int = 0
        while previousData.count < i {
            if(previousData[i] == dia) {
                previousData.remove(at: i)
            }
            i = i + 1;
        }
    }
    
    func clearTemporal() {
        UserDefaults.standard.removeObject(forKey: "dias")
    }
    

}
