//
//  NuevaRutinaController.swift
//  YourRoutine
//
//  Created by gimblet on 10/12/25.
//

import UIKit

class NuevaRutinaController: UIViewController,
                             UICollectionViewDataSource,
                             UICollectionViewDelegateFlowLayout {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    @IBOutlet weak var cvEtiquetas: UICollectionView!
    var listaEtiquetas:[EtiquetaEntityModel] = []
    
    @IBOutlet weak var txtTitulo: UITextField!
    @IBOutlet weak var txtvDescripcion: UITextView!
    
    //Solo de Prueba ELIMINAR
    @IBOutlet weak var txtInicio: UITextField!
    @IBOutlet weak var txtFin: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        iniciarViewCollection()
        listadoEtiquetas()
        cvEtiquetas.dataSource = self
        cvEtiquetas.delegate = self
    }
    
    @IBAction func btnConfirmar(_ sender: UIButton) {
        let rutina = iniciarRutina()
        let etiqueta = iniciarEtiquetas(rutina: rutina)
        
        let estado = RutinaDAO().save(bean: rutina, etiqueta: etiqueta)
        
        EtiquetaDAO().clearTemporal()
        
        // validar estado
        if (estado == 1) {
            ventana(msj: "Rutina registrada con Exito")
        }
        else {
            ventana(msj: "Error al intentar registrar Rutina")
        }
    }
    
    func iniciarRutina() -> RutinaEntity {
        let rutina = RutinaEntity(context: context)
        rutina.nombre = txtTitulo.text ?? ""
        rutina.descripcion = txtvDescripcion.text ?? ""
        rutina.dia = "lunes, martes"
        rutina.inicio = txtInicio.text ?? ""
        rutina.fin = txtFin.text ?? ""
        return rutina
    }
    
    func iniciarEtiquetas(rutina: RutinaEntity) -> EtiquetaEntity {
        let etiqueta = EtiquetaEntity(context: context)
        
        for e in EtiquetaDAO().getEtiquetaTemporal() {
            etiqueta.nombre = e
            etiqueta.rutina = rutina
        }
        
        return etiqueta
    }
    
    func iniciarViewCollection() {
        cvEtiquetas.setContentHuggingPriority(.required, for: .horizontal)
        cvEtiquetas.setContentCompressionResistancePriority(.required, for: .horizontal)
    }
    
    func listadoEtiquetas() {
        let temp = EtiquetaDAO().findAll()
        
        for e in temp {
            listaEtiquetas.append(EtiquetaEntityModel(nombre: e.nombre))
        }
        
//        listaEtiquetas.append(EtiquetaEntityModel(nombre: "Programacion"))
//        listaEtiquetas.append(EtiquetaEntityModel(nombre: "Estudiar"))
//        listaEtiquetas.append(EtiquetaEntityModel(nombre: "Trabajo"))
//        listaEtiquetas.append(EtiquetaEntityModel(nombre: "Relajo"))
//        listaEtiquetas.append(EtiquetaEntityModel(nombre: "Meditar"))
//        listaEtiquetas.append(EtiquetaEntityModel(nombre: "Ejercicio"))
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        listaEtiquetas.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let fila = cvEtiquetas.dequeueReusableCell(withReuseIdentifier: "etiquetasIdentifier", for: indexPath) as! EtiquetaCell
        fila.btnEtiqueta.setTitle(listaEtiquetas[indexPath.row].nombre, for: .normal)
        return fila
    }
    
    @IBAction func btnRegresar(_ sender: UIButton) {
        EtiquetaDAO().clearTemporal()
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
