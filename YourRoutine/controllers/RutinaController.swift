
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
        //acceder a los label's
        fila.lblTitRutina.text=lista[indexPath.row].nombre
//        fila.lblEtiqueta.text=lista[indexPath.row].etiqueta?.description
//        fila.lblFrecuencia.text = lista[indexPath.row].dia
        fila.lblTiempo.text = lista[indexPath.row].inicio
        fila.lblDiasSem.text = lista[indexPath.row].dia
        
        // Placeholders
        fila.lblEtiqueta.text = "Programacion"
        fila.lblFrecuencia.text = "Lunes,Martes,Miercoles..."
        return fila
    }
    
}
