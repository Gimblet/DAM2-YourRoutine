
import UIKit

class RutinaController: UIViewController,
                         UITableViewDataSource,
                        UITableViewDelegate {
    
    @IBOutlet weak var tablaRutinas: UITableView!

    var lista:[RutinaEntity] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lista=RutinaDAO().findAll()
        tablaRutinas.dataSource=self
        tablaRutinas.delegate=self
        tablaRutinas.rowHeight=150
    }
    
    override func viewWillAppear(_ animated: Bool) {
        lista=RutinaDAO().findAll()
        tablaRutinas.reloadData()
    }
    
    @IBAction func btnNuevaRutina(_ sender: UIButton) {
        performSegue(withIdentifier: "nuevaRutina", sender: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lista.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let fila = tablaRutinas.dequeueReusableCell(withIdentifier: "filaRutina") as! RutinaCell
        let frecuencia = lista[indexPath.row].dia?.components(separatedBy: ",").count
        
        // TODO: change to get actual tag instead of a placeholder
        // let etiqueta = lista[indexPath.row].self.etiqueta
                
        fila.lblTitRutina.text = lista[indexPath.row].nombre
        fila.lblEtiqueta.text = "Programacion"
        fila.lblFrecuencia.text = String("\(frecuencia ?? 0)" + "x por semana")
        fila.lblTiempo.text = lista[indexPath.row].inicio
        fila.lblDiasSem.text = lista[indexPath.row].dia

        return fila
    }
    
}
