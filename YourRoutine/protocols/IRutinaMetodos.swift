//
//  IMetodos.swift
//  YourRoutine
//
//  Created by gimblet on 10/12/25.
//

import UIKit

protocol IRutinaMetodos {
    func save(bean:RutinaEntity,etiquetas:[EtiquetaEntity]) -> Int
    func findCurrent() -> RutinaEntity?
    func findAll() -> [RutinaEntity]
    func update(bean:RutinaEntity) -> Int
    func delete(bean:RutinaEntity) -> Int
    func deleteAllEtiquetasByRoutine(bean: RutinaEntity)
}
