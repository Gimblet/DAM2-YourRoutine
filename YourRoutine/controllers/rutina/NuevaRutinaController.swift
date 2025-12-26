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
    
    @IBOutlet weak var tmInicio: UIDatePicker!
    @IBOutlet weak var tmFin: UIDatePicker!
    
    @IBOutlet weak var slProgreso: UISlider!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        RutinaDAO().clearTemporal()
        EtiquetaDAO().clearTemporal()

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
        listadoDias()
        listadoEtiquetas()
    }
    
    @IBAction func btnConfirmar(_ sender: UIButton) {
        // validar formulario
        if !validarFormulario() {
            return
        }
        
        let rutina = iniciarRutina()
        let etiquetas = iniciarEtiquetas()
        
        RutinaDAO().clearTemporal()
        EtiquetaDAO().clearTemporal()
        
        let estado = RutinaDAO().save(bean: rutina, etiquetas: etiquetas)
        
        // validar estado
        if (estado == 1) {
            ventanaConAccion(msj: "Rutina registrada con Exito")
        }
        else {
            ventana(msj: "Error al intentar registrar Rutina")
        }
    }
    
    func iniciarRutina() -> RutinaEntity {
        let rutina = RutinaEntity(context: context)
        rutina.nombre = txtTitulo.text ?? ""
        rutina.descripcion = txtDescripcion.text ?? ""
        rutina.dia = parsearDiasSelecionados()
        rutina.inicio = parsearTiempo(date: tmInicio.date)
        rutina.fin = parsearTiempo(date: tmFin.date)
        rutina.progreso = slProgreso.value
        return rutina
    }
    
    func parsearDiasSelecionados() -> String {
        return RutinaDAO().getDiaTemporal().joined(separator: ",")
    }
    
    func parsearTiempo(date: Date) -> String {
        let format = DateFormatter()
        format.dateFormat = "HH:mm"
        return format.string(from: date)
    }
    
    func iniciarEtiquetas() -> [EtiquetaEntity] {
        var etiquetas:[EtiquetaEntity] = []
        
        for e in EtiquetaDAO().getEtiquetaTemporal() {
            let etiqueta = EtiquetaEntity(context: context)
            etiqueta.nombre = e
            etiquetas.append(etiqueta)
        }
        
        return etiquetas
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
            let etiquetas = EtiquetaDAO().findAll()
            fila.longPressActionVar = { [weak self] in
                let text = "Esta segur@ que quiere eliminar esta etiqueta?. Esta accion es irreversible..."
                self?.ventanaEliminar(msj: text, entity: etiquetas[indexPath.row])
            }
            return fila
        }
    }
    
    func ventanaEliminar(msj:String, entity:EtiquetaEntity) {
        let alert=UIAlertController(title: "Sistema", message: msj, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Eliminar", style: .destructive, handler: { h in
            EtiquetaDAO().removeByEtiqueta(bean: entity)
            self.listadoEtiquetas()
            self.cvEtiquetas.reloadData()
        }))
        alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel))
        present(alert, animated: true)
    }
    
    @IBAction func btnRegresar(_ sender: UIButton) {
        EtiquetaDAO().clearTemporal()
        RutinaDAO().clearTemporal()
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
    
    func ventanaConAccion(msj:String) {
        // crear ventana de alerta
        let alert=UIAlertController(title: "Sistema", message: msj, preferredStyle: .alert)
        //adicionar boton al objeto alert
        alert.addAction(UIAlertAction(title: "Aceptar", style: .default, handler: { h in
            self.dismiss(animated: true)
        }))
        //mostrar el objeto "alert"
        present(alert, animated: true)
    }
    
    func validarFormulario() -> Bool {
        
        // Validar título
        if txtTitulo.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ?? true {
            ventana(msj: "Debe ingresar un título para la rutina")
            return false
        }
        
        // Validar descripción
        if txtDescripcion.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ?? true {
            ventana(msj: "Debe ingresar una descripción")
            return false
        }
        
        // Validar días seleccionados
        if RutinaDAO().getDiaTemporal().isEmpty {
            ventana(msj: "Debe seleccionar al menos un día")
            return false
        }
        
        // Validar etiquetas seleccionadas
        if EtiquetaDAO().getEtiquetaTemporal().isEmpty {
            ventana(msj: "Debe seleccionar al menos una etiqueta")
            return false
        }
        
        // Validar horas
        if tmInicio.date >= tmFin.date {
            ventana(msj: "La hora de inicio debe ser menor que la hora de fin")
            return false
        }
        
        return true
    }
    
}
