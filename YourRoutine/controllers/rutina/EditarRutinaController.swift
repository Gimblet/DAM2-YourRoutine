

import UIKit

class EditarRutinaController: UIViewController,
                              UICollectionViewDataSource,
                              UICollectionViewDelegateFlowLayout {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    // Rutina que se va a editar
    var rutina: RutinaEntity!
    
    @IBOutlet weak var cvEtiquetas: UICollectionView!
    @IBOutlet weak var cvDias: UICollectionView!
    
    
    @IBOutlet weak var txtTitulo: UITextField!
    @IBOutlet weak var txtDescripcion: UITextField!
    
    @IBOutlet weak var tmInicio: UIDatePicker!
    @IBOutlet weak var tmFinal: UIDatePicker!
    
    var listaEtiquetas:[EtiquetaEntityModel] = []
    var listaDias:[String] = []
    


    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard rutina != nil else {
            print("editarRutina")
            dismiss(animated: true)
            return
        }
        
        iniciarViewCollection()
        listadoDias()
        listadoEtiquetas()
        
        cvDias.dataSource = self
        cvDias.delegate = self
        
        cvEtiquetas.dataSource = self
        cvEtiquetas.delegate = self
        
        cargarDatosRutina()
    }
    
    func cargarDatosRutina() {
        txtTitulo.text = rutina.nombre
        txtDescripcion.text = rutina.descripcion
        
        tmInicio.date = convertirHora(rutina.inicio ?? "00:00")
        tmFinal.date = convertirHora(rutina.fin ?? "00:00")
        
        // Dias seleccionados
        let dias = rutina.dia?.components(separatedBy: ",") ?? []
        RutinaDAO().setDiaTemporal(dias)
        
        // Etiquetas seleccionadas
        if let etiquetas = rutina.etiqueta?.allObjects as? [EtiquetaEntity] {
            let nombres = etiquetas.compactMap { $0.nombre }
            EtiquetaDAO().setEtiquetaTemporal(nombres)
            
        }
        
        cvDias.reloadData()
        cvEtiquetas.reloadData()
        
    }
    
    func convertirHora(_ hora:String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        return dateFormatter.date(from: hora)!
    }
    
    
    func iniciarRutina() -> RutinaEntity {
        let rutina = RutinaEntity(context: context)
        rutina.nombre = txtTitulo.text ?? ""
        rutina.descripcion = txtDescripcion.text ?? ""
        rutina.dia = parsearDiasSelecionados()
        rutina.inicio = parsearTiempo(date: tmInicio.date)
        rutina.fin = parsearTiempo(date: tmFinal.date)
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
            listaEtiquetas.append(EtiquetaEntityModel(nombre: e.nombre ?? ""))
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
        if collectionView == cvDias {
            return listaDias.count
        } else {
            return listaEtiquetas.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
      

        if collectionView == cvDias {
                let cell = cvDias.dequeueReusableCell(
                    withReuseIdentifier: "diasIdentifier",
                    for: indexPath
                ) as! DiaCell

                let dia = listaDias[indexPath.row]
                let seleccionado = RutinaDAO().getDiaTemporal().contains(dia)

                cell.configurar(nombre: dia, seleccionado: seleccionado)
                return cell
            } else {
                let cell = cvEtiquetas.dequeueReusableCell(
                    withReuseIdentifier: "etiquetasIdentifier",
                    for: indexPath
                ) as! EtiquetaCell

                cell.btnEtiqueta.setTitle(listaEtiquetas[indexPath.row].nombre, for: .normal)
                return cell
            }
    }
    
    

    
    @IBAction func btnEditar(_ sender: UIButton) {
        
        if !validarFormulario() {
            return
        }
        
        rutina.nombre = txtTitulo.text ?? ""
            rutina.descripcion = txtDescripcion.text ?? ""
            rutina.dia = RutinaDAO().getDiaTemporal().joined(separator: ",")
            rutina.inicio = parsearTiempo(date: tmInicio.date)
            rutina.fin = parsearTiempo(date: tmFinal.date)

            // Limpiar etiquetas anteriores
            if let etiquetasViejas = rutina.etiqueta as? Set<EtiquetaEntity> {
                for e in etiquetasViejas {
                    context.delete(e)
                }
            }

            // Nuevas etiquetas
            for nombre in EtiquetaDAO().getEtiquetaTemporal() {
                let etiqueta = EtiquetaEntity(context: context)
                etiqueta.nombre = nombre
                etiqueta.rutina = rutina
            }

            do {
                try context.save()
                ventana(msj: "Rutina actualizada con éxito")
                dismiss(animated: true)
            } catch {
                ventana(msj: "Error al actualizar la rutina")
            }
    }
    
    @IBAction func btnRegresar(_ sender: UIButton) {
        RutinaDAO().clearTemporal()
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
    
    @IBAction func btnEtiqueta(_ sender: UIButton) {
        performSegue(withIdentifier: "nuevaEtiquetaIdentifier", sender: nil)
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
        if tmInicio.date >= tmFinal.date {
            ventana(msj: "La hora de inicio debe ser menor que la hora de fin")
            return false
        }
        
        return true
    }

    
}
