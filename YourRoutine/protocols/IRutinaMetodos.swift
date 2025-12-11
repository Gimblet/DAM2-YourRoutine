//
//  IMetodos.swift
//  YourRoutine
//
//  Created by gimblet on 10/12/25.
//

import UIKit

protocol IRutinaMetodos {
    func save(bean:RutinaModel) -> Int
    func findAll() -> [RutinaEntity]
    func update(bean:RutinaEntity) -> Int
}
