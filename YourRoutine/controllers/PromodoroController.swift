
import UIKit
import FirebaseFirestore

class PromodoroController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func btbIniciar(_ sender: UIButton) {
    }
    
    @IBAction func btnPausar(_ sender: UIButton) {
    }
    
    @IBAction func btnReiniciar(_ sender: UIButton) {
    }
    
    @IBAction func btnGuardar(_ sender: UIButton) {
        Task { @MainActor in
            let database = Firestore.firestore()
            
            do {
                let ref = try await database.collection("pomodoro")
                    .addDocument(data: [
                        "date": Date(),
                        "time": 25
                    ])
                print("Document Added with ID: " + ref.documentID)
            }
        }
    }
    
}
