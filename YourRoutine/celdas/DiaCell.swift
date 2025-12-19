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
        /*if(sender.isSelected) {
            sender.isSelected = false
            sender.setTitleColor(UIColor.black, for: .normal)
            RutinaDAO().removeDiaTemporal(dia: sender.titleLabel?.text ?? "")
        } else {
            sender.isSelected = true
            sender.setTitleColor(UIColor.white, for: .selected)
            RutinaDAO().addDiaTemporal(etiqueta: sender.titleLabel?.text ?? "")
        }*/
        
        
        guard let dia = sender.titleLabel?.text else { return }

                // Cambiar estado visual
                sender.isSelected.toggle()

                sender.backgroundColor = sender.isSelected ? .systemBlue : .lightGray
                sender.setTitleColor(.white, for: .normal)

                // Lógica de negocio
                RutinaDAO().toggleDia(dia)
    }
    
    func configurar(nombre: String, seleccionado: Bool) {
            /*btnDia.setTitle(nombre, for: .normal)
            btnDia.backgroundColor = seleccionado ? .systemBlue : .lightGray
            btnDia.setTitleColor(.white, for: .normal)*/
        
            btnDia.setTitle(nombre, for: .normal)
            btnDia.isSelected = seleccionado
            btnDia.backgroundColor = seleccionado ? .systemBlue : .lightGray
            btnDia.setTitleColor(.white, for: .normal)
        }
}
