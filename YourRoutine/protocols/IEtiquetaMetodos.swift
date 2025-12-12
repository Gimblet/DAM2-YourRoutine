//
//  IEtiquetaMetodos.swift
//  YourRoutine
//
//  Created by gimblet on 11/12/25.
//

import UIKit

protocol IEtiquetaMetodos {
    func save(bean:EtiquetaEntity) -> Int
    func findAll() -> [EtiquetaEntity]
}
