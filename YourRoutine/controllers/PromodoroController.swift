
import UIKit
import FirebaseFirestore

class PromodoroController: UIViewController,
                            UITableViewDataSource,
                            UITableViewDelegate {
    
    @IBOutlet weak var TimerLabel: UILabel!
    @IBOutlet weak var startStopButton: UIButton!
    @IBOutlet weak var resetButton: UIButton!
    
    var pomodoros: [Pomodoro] = []
    
    let pomodoroSeconds = 60 // 1 minuto
    var remainingSeconds = 60
    
    var timerCounting = false
    var scheduledTimer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setTimeLabel(remainingSeconds)
        tableView.layer.cornerRadius = 20
        tableView.clipsToBounds = true
        
        tableView.dataSource = self
        tableView.delegate = self
        
        fetchPomodoros()
    }
    
    
    @IBAction func startStopAction(_ sender: Any) {
        if timerCounting {
            stopTimer()
        } else {
            startTimer()
        }
    }
    
    func calcRestartTime(start: Date, stop: Date) -> Date
    {
        let diff = stop.timeIntervalSince(start)
        return Date().addingTimeInterval(-diff)
    }
    
    func startTimer()
    {
        scheduledTimer?.invalidate()
        
        scheduledTimer = Timer.scheduledTimer(
            timeInterval: 1,
            target: self,
            selector: #selector(refreshValue),
            userInfo: nil,
            repeats: true
        )
        
        timerCounting = true
        startStopButton.setTitle("STOP", for: .normal)
        startStopButton.setTitleColor(.red, for: .normal)
    }
    
    @objc func refreshValue()
    {
        
        if remainingSeconds > 0 {
            remainingSeconds -= 1
            setTimeLabel(remainingSeconds)
        } else {
            stopTimer()
            print("Pomodoro terminado")
        }
    }
    
    func stopTimer()
    {
        scheduledTimer?.invalidate()
        timerCounting = false
        
        startStopButton.setTitle("START", for: .normal)
        startStopButton.setTitleColor(.systemGreen, for: .normal)
    }
    
    @IBAction func resetAction(_ sender: Any) {
        stopTimer()
        remainingSeconds = pomodoroSeconds
        setTimeLabel(remainingSeconds)
    }
    
    func setTimeLabel(_ val: Int) {
        let time = secondsToHoursMinutesSeconds(val)
        TimerLabel.text = makeTimeString(hour: time.0, min: time.1, sec: time.2)
    }
    
    func secondsToHoursMinutesSeconds(_ seconds: Int) -> (Int, Int, Int) {
        let min = seconds / 60
        let sec = seconds % 60
        return (0, min, sec)
    }
    
    func makeTimeString(hour: Int, min: Int, sec: Int) -> String {
        return String(format: "%02d:%02d:%02d", hour, min, sec)
    }
    
    @IBAction func saveTimeAction(_ sender: Any) {
        guard remainingSeconds == 0 else {
            print("⏳ El Pomodoro aún no ha terminado")
            return
        }
        
        Task { @MainActor in
            let database = Firestore.firestore()
            
            do {
                try await database.collection("pomodoro")
                    .addDocument(data: [
                        "date": Date(),
                        "time": 25
                    ])
                self.fetchPomodoros()
                
            } catch {
                print("Error al guardar:", error.localizedDescription)
            }
        }
    }
    
    func fetchPomodoros() {
        let database = Firestore.firestore()
        
        database.collectionGroup("pomodoro")
            .addSnapshotListener { (data, error) in
                guard let documentos = data?.documents else { return }
                for e in documentos {
                    let result = e.data()
                    let fbDate = result["date"] as? Timestamp
                    let fbTime = result["time"] as? Int64
                    let date = fbDate?.dateValue()
                    let time = Int(fbTime ?? 25)
                    let pomodoro = Pomodoro(date: date ?? Date(), time: time)
                    self.pomodoros.append(pomodoro)
                }
            }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pomodoros.count
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(
            withIdentifier: "pomodoroCell",
            for: indexPath
        ) as! PomodoroCell
        
        let pomodoro = pomodoros[indexPath.row]
        
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        
        cell.dia.text = formatter.string(from: pomodoro.date)
        cell.tiempo.text = "\(pomodoro.time) min"
        
        return cell
    }
    
    @IBOutlet weak var tableView: UITableView!
    
}
