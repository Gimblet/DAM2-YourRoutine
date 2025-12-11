//
//  NuevaRutinaController.swift
//  YourRoutine
//
//  Created by gimblet on 10/12/25.
//

import UIKit

class NuevaRutinaController: UIViewController {
    @IBOutlet weak var txtTitulo: UITextField!
    @IBOutlet weak var txtvDescripcion: UITextView!
    
    //Solo de Prueba ELIMINAR
    @IBOutlet weak var txtInicio: UITextField!
    @IBOutlet weak var txtFin: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func btnConfirmar(_ sender: UIButton) {
        let titulo = txtTitulo.text ?? ""
        let descripcion = txtvDescripcion.text ?? ""
        let horaInicio = txtInicio.text ?? ""
        let horaFin = txtFin.text ?? ""
        // variable de la estructura inversores
        let obj = RutinaModel(descripcion: descripcion, dia: "Lunes, Martes, Miercoles", fin: horaFin, inicio: horaInicio, nombre: titulo)
        // invocar a la funcion save que se encuentra en la clase InversoresDAO
        let estado = RutinaDAO().save(bean: obj)
        // validar estado
        if estado > 0 {
            ventana(msj: "Rutina registrada con Exito")
        }
        else {
            ventana(msj: "Error al intentar registrar Rutina")
        }
    }
    
    @IBAction func btnRegresar(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
    func ventana(msj:String) {
        // crear ventana de alerta
        let alert=UIAlertController(title: "Sistema", message: msj, preferredStyle: .alert)
        //adicionar boton al objeto alert
        alert.addAction(UIAlertAction(title: "Aceptar", style: .default))
        //mostrar el objeto "alert"
        present(alert, animated: true)
    }
    
}
