//
//  PomodoroCell.swift
//  YourRoutine
//
//  Created by DAMII on 23/12/25.
//

import UIKit

class PomodoroCell: UITableViewCell {
    @IBOutlet weak var lblFecha: UILabel!
    @IBOutlet weak var lblTiempo: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
