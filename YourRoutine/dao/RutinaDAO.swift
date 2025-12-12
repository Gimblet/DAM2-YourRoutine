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
    

}
