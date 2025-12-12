//
//  IMetodos.swift
//  YourRoutine
//
//  Created by gimblet on 10/12/25.
//

import UIKit

protocol IRutinaMetodos {
    func save(bean:RutinaEntity,etiqueta:EtiquetaEntity) -> Int
    func findAll() -> [RutinaEntity]
    func update(bean:RutinaEntity) -> Int
}
