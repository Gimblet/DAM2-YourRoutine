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
        actualizarCampos()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        actualizarCampos()
    }
    
    func actualizarCampos() {
        if let currentRoutine = RutinaDAO().findCurrent() {
            let until = "Hasta las \(currentRoutine.fin!)"
            let currentMin:String = String(getCurrentMin(rutina: currentRoutine))
            let totalMin:String = String(getTotalMin(rutina: currentRoutine))
            
            pwProgreso.observedProgress = getCurrentProgress(current: currentMin, total: totalMin)
            lblProgresoMin.text = "\(currentMin)/\(totalMin) min"
            btnRutinaHasta.setTitle(until, for: .normal)
            lblRutinaTitulo.text = currentRoutine.nombre.unsafelyUnwrapped
        } else {
            pwProgreso.progress = 0.01
            lblProgresoMin.text = "..."
            lblRutinaActual.text = "Sin Rutina"
            btnRutinaHasta.setTitle("Estas libre ;)", for: .normal)
            lblRutinaTitulo.text = "Descansa, te lo mereces..."
        }
    }
    
    func getCurrentProgress(current:String, total:String) -> Progress {
        let progress = Progress()
        progress.totalUnitCount = Int64(total).unsafelyUnwrapped
        progress.completedUnitCount = Int64(current).unsafelyUnwrapped
        return progress
    }
    
    func getCurrentMin(rutina:RutinaEntity) -> Int {
        let today = Date()
        let hour = Int((Calendar.current.component(.hour, from: today)))
        let min = Int((Calendar.current.component(.minute, from: today)))
        
        let arrayTiempoInicio:[String] = rutina.inicio!.components(separatedBy: ":")
        var arrayNumeroInicio:[Int] = []
        
        for t in arrayTiempoInicio {
            arrayNumeroInicio.append(Int(t).unsafelyUnwrapped)
        }
        
        let totalTiempoInicio = ((arrayNumeroInicio[0] * 60) + arrayNumeroInicio[1])
        
        return (((hour * 60) + min) - totalTiempoInicio)
    }
    
    func getTotalMin(rutina:RutinaEntity) -> Int {
        let arrayTiempoInicio:[String] = rutina.inicio!.components(separatedBy: ":")
        let arrayTiempoFin:[String] = rutina.fin!.components(separatedBy: ":")
        
        var arrayNumeroInicio:[Int] = []
        var arrayNumeroFin:[Int] = []

        for t in arrayTiempoInicio {
            arrayNumeroInicio.append(Int(t).unsafelyUnwrapped)
        }
        
        for t in arrayTiempoFin {
            arrayNumeroFin.append(Int(t).unsafelyUnwrapped)
        }
        
        let totalTiempoInicio = ((arrayNumeroInicio[0] * 60) + arrayNumeroInicio[1])
        let totalTiempoFin = ((arrayNumeroFin[0] * 60) + arrayNumeroFin[1])
        
        return totalTiempoFin - totalTiempoInicio
    }

}

