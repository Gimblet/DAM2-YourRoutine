
import UIKit

class RutinaController: UIViewController,
                         UITableViewDataSource,
                        UITableViewDelegate {
    
    @IBOutlet weak var tablaRutinas: UITableView!

    var lista:[RutinaEntity] = []
    
    var rutinaSeleccionada: RutinaEntity?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        RutinaDAO().clearTemporal()
        EtiquetaDAO().clearTemporal()
        
        lista=RutinaDAO().findAll()
        tablaRutinas.dataSource=self
        tablaRutinas.delegate=self
        tablaRutinas.rowHeight=150
    }
    
    override func viewWillAppear(_ animated: Bool) {
        lista=RutinaDAO().findAll()
        tablaRutinas.reloadData()
    }
    
    @IBAction func btnDetallesRutina(_ sender: UIButton) {
        if tablaRutinas.indexPathForSelectedRow != nil {
            performSegue(withIdentifier: "detalleRutina", sender: nil)
        } else {
            print("Se debe seleccionar una rutina primero")
        }
    }
    
    @IBAction func btnNuevaRutina(_ sender: UIButton) {
        performSegue(withIdentifier: "nuevaRutina", sender: nil)
    }
    
    @IBAction func btnEditarRutina(_ sender: UIButton) {
        if let indexPath = tablaRutinas.indexPathForSelectedRow {
            rutinaSeleccionada = lista[indexPath.row]
            performSegue(withIdentifier: "editarRutina", sender: nil)
        } else {
            print("Se debe seleccionar una rutina primero")
        }
    }
    
    @IBAction func btnEliminarRutina(_ sender: UIButton) {
        let msj = "Esta segur@ que quiere eliminar esta rutina?. Esta accion es irreversible"
        if let indexPath = tablaRutinas.indexPathForSelectedRow {
            let entity = lista[indexPath.row]
            ventanaEliminar(msj: msj, entity: entity)
        } else {
            print("Se debe seleccionar una rutina primero")
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lista.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let fila = tablaRutinas.dequeueReusableCell(withIdentifier: "filaRutina") as! RutinaCell
        let frecuencia = lista[indexPath.row].dia?.components(separatedBy: ",").count
        let inicioMinuto = toMinuto(tiempo: lista[indexPath.row].inicio.unsafelyUnwrapped)
        let finMinuto = toMinuto(tiempo: lista[indexPath.row].fin.unsafelyUnwrapped)
                
        fila.lblTitRutina.text = lista[indexPath.row].nombre
        if let etiquetasSet = lista[indexPath.row].etiqueta as? Set<EtiquetaEntity> {
            let etiquetasArray = Array(etiquetasSet)
            
            if (etiquetasArray.isEmpty) {
                fila.lblEtiqueta.text = "Sin Etiquetas"
                fila.lblEtiquetaExtra.isHidden = true
            } else {
                if(etiquetasArray.count > 1) {
                    fila.lblEtiquetaExtra.isHidden = false
                    fila.lblEtiquetaExtra.text = "+\(etiquetasArray.count - 1)"
                }
                fila.lblEtiqueta.text = "\(etiquetasArray[0].nombre.unsafelyUnwrapped)"
            }
        }
        fila.lblFrecuencia.text = String("\(frecuencia ?? 0)" + "x por semana")
        fila.lblTiempo.text = String(finMinuto - inicioMinuto) + " min"
        fila.lblDiasSem.text = lista[indexPath.row].dia

        return fila
    }
    
    func toMinuto(tiempo:String) -> Int {
        let arrayTiempo:[String] = tiempo.components(separatedBy: ":")
        var arrayNumero:[Int] = []
        
        for t in arrayTiempo {
            arrayNumero.append(Int(t).unsafelyUnwrapped)
        }
        
        return ((arrayNumero[0] * 60) + arrayNumero[1])
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editarRutina" {
            if let destino = segue.destination as? EditarRutinaController {
                destino.rutina = rutinaSeleccionada
            }
        }
        else if segue.identifier == "detalleRutina" {
            let vc = segue.destination as! DetallesRutinaController
            let indexPath = tablaRutinas.indexPathForSelectedRow!
            vc.bean = lista[indexPath.row]
        }
    }
    
    func ventanaEliminar(msj:String, entity:RutinaEntity) {
        let alert=UIAlertController(title: "Sistema", message: msj, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Eliminar", style: .destructive, handler: { h in
            RutinaDAO().delete(bean: entity)
            self.dismiss(animated: true)
            self.lista = RutinaDAO().findAll()
            self.tablaRutinas.reloadData()
        }))
        alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel))
        present(alert, animated: true)
    }
    
}
