//
//  DiaCell.swift
//  YourRoutine
//
//  Created by gimblet on 13/12/25.
//

import UIKit

class DiaCell: UICollectionViewCell {
    @IBOutlet weak var btnDia: UIButton!
    
    @IBAction func btnDia(_ sender: UIButton) {
        if(sender.isSelected) {
            sender.isSelected = false
            sender.setTitleColor(UIColor.black, for: .normal)
            RutinaDAO().removeDiaTemporal(dia: sender.titleLabel?.text ?? "")
        } else {
            sender.isSelected = true
            sender.setTitleColor(UIColor.white, for: .selected)
            RutinaDAO().addDiaTemporal(etiqueta: sender.titleLabel?.text ?? "")
        }
    }
}
