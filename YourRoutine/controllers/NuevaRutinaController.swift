//
//  NuevaRutinaController.swift
//  YourRoutine
//
//  Created by gimblet on 10/12/25.
//

import UIKit

class NuevaRutinaController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    @IBOutlet weak var cvEtiquetas: UICollectionView!
    var listaEtiquetas:[EtiquetaModel] = []
    
    @IBOutlet weak var txtTitulo: UITextField!
    @IBOutlet weak var txtvDescripcion: UITextView!
    
    //Solo de Prueba ELIMINAR
    @IBOutlet weak var txtInicio: UITextField!
    @IBOutlet weak var txtFin: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        iniciarViewCollection()
        listado()
        cvEtiquetas.dataSource = self
        cvEtiquetas.delegate = self
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
    
    func iniciarViewCollection() {
        cvEtiquetas.setContentHuggingPriority(.required, for: .horizontal)
        cvEtiquetas.setContentCompressionResistancePriority(.required, for: .horizontal)
    }
    
    func listado() {
        listaEtiquetas.append(EtiquetaModel(nombre: "Programacion"))
        listaEtiquetas.append(EtiquetaModel(nombre: "Estudiar"))
        listaEtiquetas.append(EtiquetaModel(nombre: "Trabajo"))
        listaEtiquetas.append(EtiquetaModel(nombre: "Relajo"))
        listaEtiquetas.append(EtiquetaModel(nombre: "Meditar"))
        listaEtiquetas.append(EtiquetaModel(nombre: "Ejercicio"))
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        listaEtiquetas.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //crear objeto de la clase LibroCell
        let fila = cvEtiquetas.dequeueReusableCell(withReuseIdentifier: "etiquetasIdentifier", for: indexPath) as! EtiquetaCell
        fila.btnEtiqueta.setTitle(listaEtiquetas[indexPath.row].nombre, for: .normal)
        return fila
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
