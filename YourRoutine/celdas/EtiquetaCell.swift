//
//  EtiquetaCell.swift
//  YourRoutine
//
//  Created by gimblet on 11/12/25.
//

import UIKit

class EtiquetaCell: UICollectionViewCell {
    @IBOutlet weak var btnEtiqueta: UIButton!
    
    var longPressActionVar: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(longPressEtiqueta))
        longPress.minimumPressDuration = 0.6
        btnEtiqueta.addGestureRecognizer(longPress)
    }
    
    @objc func longPressEtiqueta(_ gesture: UILongPressGestureRecognizer) {
        if gesture.state == .began {
            longPressActionVar?()
        }
    }
        
    @IBAction func btnEtiquetaAction(_ sender: UIButton) {
        if(sender.isSelected) {
            sender.isSelected = false
            sender.setTitleColor(UIColor.black, for: .normal)
            EtiquetaDAO().removeEtiquetaTemporal(etiqueta: sender.titleLabel?.text ?? "")
        } else {
            sender.isSelected = true
            sender.setTitleColor(UIColor.white, for: .selected)
            EtiquetaDAO().addEtiquetaTemporal(etiqueta: sender.titleLabel?.text ?? "")
        }
        
    }
}
