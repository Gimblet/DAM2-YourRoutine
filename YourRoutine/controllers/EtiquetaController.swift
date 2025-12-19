//
//  EtiquetaController.swift
//  YourRoutine
//
//  Created by gimblet on 12/12/25.
//

import UIKit

class EtiquetaController: UIViewController {
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var rutina:NuevaRutinaController!
    
    var rutinaEdit:EditarRutinaController!
    

    @IBOutlet weak var txtEtiqueta: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func btnAgregar(_ sender: UIButton) {
        let etiqueta = EtiquetaEntity(context: context)
        etiqueta.nombre = txtEtiqueta.text
        
        let resultado = EtiquetaDAO().save(bean: etiqueta)
        
        if(resultado == -1) {
            print("Ocurrio un error al agregar etiqueta")
        }
        
        /*rutina.listadoEtiquetas()
        rutina.cvEtiquetas.reloadData()
        
        rutinaEdit.listadoEtiquetas()
        rutinaEdit.cvEtiquetas.reloadData()*/
        
        // Si viene de NuevaRutina
            rutina?.listadoEtiquetas()
            rutina?.cvEtiquetas.reloadData()

            // Si viene de EditarRutina
            rutinaEdit?.listadoEtiquetas()
            rutinaEdit?.cvEtiquetas.reloadData()
        
        dismiss(animated: true)
    }
    
    @IBAction func btnCancelar(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
}
