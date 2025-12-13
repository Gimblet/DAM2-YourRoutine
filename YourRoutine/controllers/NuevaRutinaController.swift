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
    
    @IBOutlet weak var cvDias: UICollectionView!
    var listaDias:[String] = []
    
    @IBOutlet weak var txtTitulo: UITextField!
    @IBOutlet weak var txtDescripcion: UITextField!
    
    //Solo de Prueba ELIMINAR
    @IBOutlet weak var txtInicio: UITextField!
    @IBOutlet weak var txtFin: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        iniciarViewCollection()
        listadoDias()
        listadoEtiquetas()
        
        // Lista para los dias
        cvDias.dataSource = self
        cvDias.delegate = self
        
        // Lista para las Etiquetas
        cvEtiquetas.dataSource = self
        cvEtiquetas.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        listadoEtiquetas()
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
        rutina.descripcion = txtDescripcion.text ?? ""
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
        cvDias.setContentHuggingPriority(.required, for: .horizontal)
        cvDias.setContentCompressionResistancePriority(.required, for: .horizontal)
        
        cvEtiquetas.setContentHuggingPriority(.required, for: .horizontal)
        cvEtiquetas.setContentCompressionResistancePriority(.required, for: .horizontal)
    }
    
    func listadoEtiquetas() {
        listaEtiquetas.removeAll()
        
        let etiquetas = EtiquetaDAO().findAll()
        
        for e in etiquetas {
            listaEtiquetas.append(EtiquetaEntityModel(nombre: e.nombre))
        }
    }
    
    func listadoDias() {
        listaDias.removeAll()
        
        listaDias.append("Lunes")
        listaDias.append("Martes")
        listaDias.append("Miercoles")
        listaDias.append("Jueves")
        listaDias.append("Viernes")
        listaDias.append("Sabado")
        listaDias.append("Domingo")
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if (collectionView == self.cvDias) {
            return listaDias.count
        } else {
            return listaEtiquetas.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if(collectionView == self.cvDias) {
            let fila = cvDias.dequeueReusableCell(withReuseIdentifier: "diasIdentifier", for: indexPath) as! DiaCell
            fila.btnDia.setTitle(listaDias[indexPath.row], for: .normal)
            return fila
        }
        else  {
            let fila = cvEtiquetas.dequeueReusableCell(withReuseIdentifier: "etiquetasIdentifier", for: indexPath) as! EtiquetaCell
            fila.btnEtiqueta.setTitle(listaEtiquetas[indexPath.row].nombre, for: .normal)
            return fila
        }
    }
    
    @IBAction func btnRegresar(_ sender: UIButton) {
        EtiquetaDAO().clearTemporal()
        dismiss(animated: true)
    }
    
    @IBAction func btnNuevaEtiqueta(_ sender: UIButton) {
        performSegue(withIdentifier: "nuevaEtiquetaIdentifier", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "nuevaEtiquetaIdentifier" {
            if let obj = segue.destination as? EtiquetaController {
                obj.rutina = self
            }
        }
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
