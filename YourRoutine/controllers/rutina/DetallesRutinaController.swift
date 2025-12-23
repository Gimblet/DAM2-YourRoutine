import UIKit

class DetallesRutinaController: UIViewController {

    @IBOutlet weak var lblTitulo: UILabel!
    @IBOutlet weak var lblDescripcion: UILabel!
    @IBOutlet weak var lblEtiquetas: UILabel!
    @IBOutlet weak var lblDias: UILabel!
    @IBOutlet weak var lblHoraInicio: UILabel!
    @IBOutlet weak var lblHoraFin: UILabel!
    @IBOutlet weak var lblProgreso: UILabel!
    var bean:RutinaEntity!
    
    override func viewDidLoad() {
        let roundedProgress:Int = Int(round(Double(bean.progreso)))
        
        super.viewDidLoad()
        lblTitulo.text = bean.nombre
        lblDescripcion.text = bean.descripcion
        lblDias.text = bean.dia
        lblHoraInicio.text = bean.inicio
        lblHoraFin.text = bean.fin
        if let etiquetasSet = bean.etiqueta as? Set<EtiquetaEntity>, !etiquetasSet.isEmpty {
            let nombres = etiquetasSet.compactMap { $0.nombre }
            lblEtiquetas.text = nombres.joined(separator: ", ")
        } else {
            lblEtiquetas.text = "Sin etiquetas"
        }
        lblProgreso.text = String(roundedProgress) + " %"
    }
    
    @IBAction func btnRegresar(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
}
