//
//  ViewController.swift
//  YourRoutine
//
//  Created by gimblet on 30/11/25.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var lblTiempo: UILabel!
    @IBOutlet weak var pwTiempo: UIProgressView!
    
    @IBOutlet weak var viewCurrentRoutine: UIView!
    @IBOutlet weak var lblRutinaActual: UILabel!
    @IBOutlet weak var btnRutinaHasta: UIButton!
    @IBOutlet weak var lblRutinaTitulo: UILabel!
    @IBOutlet weak var lblProgreso: UILabel!
    @IBOutlet weak var pwProgreso: UIProgressView!
    
    var rutinaActual:RutinaEntity = RutinaEntity()
    
    @IBAction func btnNuevaRutina(_ sender: UIButton) {
        performSegue(withIdentifier: "nuevaRutina", sender: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(routineViewWasTapped))
        viewCurrentRoutine.addGestureRecognizer(tapGesture)
        
        actualizarCampos()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        actualizarCampos()
    }
    
    @objc func routineViewWasTapped() {
        if let currentRoutine = RutinaDAO().findCurrent() {
            performSegue(withIdentifier: "toRoutineDetails", sender: nil)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toRoutineDetails" {
            let vc = segue.destination as! DetallesRutinaController
            vc.bean = RutinaDAO().findCurrent()
        }
    }
    
    func actualizarCampos() {
        if let currentRoutine = RutinaDAO().findCurrent() {
            let until = "Hasta las \(currentRoutine.fin!)"
            let currentMin:String = String(getCurrentMin(rutina: currentRoutine))
            let totalMin:String = String(getTotalMin(rutina: currentRoutine))
            let roundedProgress:Int = Int(round(Double(currentRoutine.progreso)))
            
            pwTiempo.observedProgress = getCurrentTime(current: currentMin, total: totalMin)
            lblTiempo.text = "\(currentMin)/\(totalMin) min"
            lblRutinaActual.text = "Rutina Actual"
            btnRutinaHasta.setTitle(until, for: .normal)
            lblRutinaTitulo.text = currentRoutine.nombre.unsafelyUnwrapped
            lblProgreso.isHidden = false
            lblProgreso.text = "Progreso Registrado (\(roundedProgress) %)"
            pwProgreso.observedProgress = getCurrentProgress(current: currentRoutine.progreso, total: 100)
        } else {
            pwTiempo.progress = 0.01
            lblTiempo.text = "..."
            lblRutinaActual.text = "Sin Rutina"
            btnRutinaHasta.setTitle("Estas libre ;)", for: .normal)
            lblRutinaTitulo.text = "Descansa, te lo mereces..."
            lblProgreso.isHidden = true
            pwProgreso.progress = 1
        }
    }
    
    func getCurrentProgress(current:Float, total:Float) -> Progress {
        let progress = Progress()
        let totalInt = Int(total)
        let currentInt = Int(current)
        
        progress.totalUnitCount = Int64(exactly: totalInt).unsafelyUnwrapped
        progress.completedUnitCount = Int64(exactly: currentInt).unsafelyUnwrapped
        return progress
    }
    
    func getCurrentTime(current:String, total:String) -> Progress {
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

