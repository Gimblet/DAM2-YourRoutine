//
//  EtiquetaDAO.swift
//  YourRoutine
//
//  Created by gimblet on 11/12/25.
//

import UIKit

class EtiquetaDAO: IEtiquetaMetodos {
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    func save(bean: EtiquetaEntity) -> Int {
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
    
    func findAll() -> [EtiquetaEntity] {
        var lista: [EtiquetaEntity] = []
        //PASO 1: crear objeto de la clase AppDelegate
        let delegate = UIApplication.shared.delegate as! AppDelegate
        //PASO 2: acceder a la conexion con la base de datos "YourRoutine"
        let bd = delegate.persistentContainer.viewContext
        //PASO 3: controlar exception
        do{
            //PASO 4: obtener contenido de la entidad "RutinaEntity"
            let etiquetas = EtiquetaEntity.fetchRequest()
            //PASO 5: bucle para realizar recorrido sobre "datos" y
            lista=try bd.fetch(etiquetas)
        }
        catch let x as NSError{
            print(x.localizedDescription)
        }
        return lista
    }
    
    // Data Temporal
    
    func addEtiquetaTemporal(etiqueta:String) {
        let previousData = UserDefaults.standard.value(forKey: "etiquetas") as? [String]
        
        if(previousData != nil) {
            var etiquetaArray:[String] = previousData!
            etiquetaArray.append(etiqueta)
            UserDefaults.standard.set(etiquetaArray, forKey: "etiquetas")
        } else {
            var newEtiquetaArray:[String] = []
            newEtiquetaArray.append(etiqueta)
            UserDefaults.standard.set(newEtiquetaArray, forKey: "etiquetas")
        }
    }
    
    func getEtiquetaTemporal() -> [String] {
        return UserDefaults.standard.value(forKey: "etiquetas") as! [String]
    }
    
    func removeEtiquetaTemporal(etiqueta:String) {
        var previousData = UserDefaults.standard.value(forKey: "etiquetas") as! [String]
        var i:Int = 0
        while previousData.count < i {
            if(previousData[i] == etiqueta) {
                previousData.remove(at: i)
            }
            i = i + 1;
        }
    }
    
    func clearTemporal() {
        UserDefaults.standard.removeObject(forKey: "etiquetas")
    }
}
