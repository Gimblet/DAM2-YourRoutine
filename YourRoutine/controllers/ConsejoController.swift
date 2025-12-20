
import UIKit



class ConsejoController: UIViewController {

    @IBOutlet weak var lblFrase: UILabel!
    @IBOutlet weak var lblAutor: UILabel!
    @IBOutlet weak var btnSiguiente: UIButton! // ← ¡Importante: outlet del botón!

    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        // Estilo opcional (mejora visual)
        lblFrase.numberOfLines = 0
        lblFrase.textAlignment = .center
        lblAutor.textAlignment = .center
        lblAutor.font = UIFont.italicSystemFont(ofSize: 16)

        cargarConsejo()
    }

    // MARK: - Actions

    @IBAction func btnSiguiente(_ sender: UIButton) {
        sender.isEnabled = false
        cargarConsejo()
    }

    // MARK: - Network Logic

    private func cargarConsejo() {
        let urlString = "https://type.fit/api/quotes" // ← Sin espacios al final

        guard let url = URL(string: urlString) else {
            mostrarError("URL inválida")
            return
        }

        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let self = self else { return }

            // Manejo de error de red
            if let error = error {
                DispatchQueue.main.async {
                    self.mostrarError("Error de red: \(error.localizedDescription)")
                    self.btnSiguiente.isEnabled = true
                }
                return
            }

            // Verificar datos
            guard let data = data else {
                DispatchQueue.main.async {
                    self.mostrarError("No se recibieron datos")
                    self.btnSiguiente.isEnabled = true
                }
                return
            }

            // Decodificar y validar datos
            do {
                let advices = try JSONDecoder().decode([Advice].self, from: data)


                // ✅ Verificación crítica: asegurar que el consejo tenga texto
                guard let advice = advices.randomElement(),
                      let adviceText = advice.text else {
                    DispatchQueue.main.async {
                        self.mostrarError("No hay consejos disponibles")
                        self.btnSiguiente.isEnabled = true
                    }
                    return
                }

                let authorText = advice.author ?? "Anónimo"


                // ✅ Actualizar UI en el hilo principal
                DispatchQueue.main.async {
                    self.lblFrase.text = "\"\(adviceText)\""
                    self.lblAutor.text = "- \(authorText)"
                    self.btnSiguiente.isEnabled = true
                }

            } catch {
                DispatchQueue.main.async {
                    self.mostrarError("Error al procesar JSON: \(error.localizedDescription)")
                    self.btnSiguiente.isEnabled = true
                }
            }

        }.resume() // ← ¡No olvidar!
    }

    // MARK: - Helper

    private func mostrarError(_ mensaje: String) {
        let alert = UIAlertController(title: "⚠️ Error", message: mensaje, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

// MARK: - Modelos JSON

struct AdviceResponse: Codable {
    let slip: Advice
}

struct Advice: Codable {
    //let id: Int?
    let text: String?   // ← Opcional, por seguridad
    let author: String?   // ← Opcional, por seguridad
}
