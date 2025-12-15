//
//  ViewController.swift
//  YourRoutine
//
//  Created by gimblet on 30/11/25.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var lblProgresoMin: UILabel!
    @IBOutlet weak var pwProgreso: UIProgressView!
    
    @IBOutlet weak var lblRutinaActual: UILabel!
    @IBOutlet weak var btnRutinaHasta: UIButton!
    @IBOutlet weak var lblRutinaTitulo: UILabel!
    
    var rutinaActual:RutinaEntity = RutinaEntity()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        actualizarCampos()
    }
    
    func actualizarCampos() {
        if let currentRoutine = RutinaDAO().findCurrent() {
            let hasta = "Hasta las \(currentRoutine.fin!)"
            btnRutinaHasta.configuration?.title = "\(hasta)"
            lblRutinaTitulo.text = currentRoutine.nombre.unsafelyUnwrapped
        } else {
            lblRutinaActual.text = "Sin Rutina Actual"
            btnRutinaHasta.setTitle("Estas libre ;)", for: .normal)
            lblRutinaTitulo.text = "Descansa, te lo mereces..."
        }
    }
    
    func obtenerProgresoMin() {
        
    }

}

