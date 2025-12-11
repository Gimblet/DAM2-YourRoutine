//
//  RutinaDAO.swift
//  YourRoutine
//
//  Created by gimblet on 10/12/25.
//

import UIKit

class RutinaDAO : IRutinaMetodos {
    func save(bean: RutinaModel) -> Int {
        var salida = -1
        //PASO 1: crear objeto de la clase AppDelegate
        let delegate=UIApplication.shared.delegate as! AppDelegate
        //PASO 2: acceder a la conexion con la base de datos "YourRoutine"
        let bd=delegate.persistentContainer.viewContext
        //PASO 3: crear objeto de la entidad "RutinaEntity"
        let tabla=RutinaEntity(context: bd)
        //PASO 4: asignar valor a los atributos del objeto tabla con los
        //valores de bean
        tabla.descripcion = bean.descripcion
        tabla.dia = bean.dia
        tabla.fin = bean.fin
        tabla.inicio = bean.inicio
        tabla.nombre = bean.nombre
        //PASO 5: controlar exception
        do{
            //PASO 6: GRABAR
            try bd.save()
            salida=1
        }
        catch let x as NSError{
            print(x.localizedDescription)
        }
        return salida
    }
    
    func findAll() -> [RutinaEntity] {
        var lista: [RutinaEntity] = []
        //PASO 1: crear objeto de la clase AppDelegate
        let delegate=UIApplication.shared.delegate as! AppDelegate
        //PASO 2: acceder a la conexion con la base de datos "YourRoutine"
        let bd=delegate.persistentContainer.viewContext
        //PASO 3: controlar exception
        do{
            //PASO 4: obtener contenido de la entidad "RutinaEntity"
            let rutinas=RutinaEntity.fetchRequest()
            //PASO 5: bucle para realizar recorrido sobre "datos" y
            //adiconar cada fila en lista
            lista=try bd.fetch(rutinas)
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
