//
//  IEtiquetaMetodos.swift
//  YourRoutine
//
//  Created by gimblet on 11/12/25.
//

import UIKit

protocol IEtiquetaMetodos {
    func save(bean:EtiquetaEntityModel) -> Int
    func findAll() -> [EtiquetaEntity]
}
