//
//  Pomodoro.swift
//  YourRoutine
//
//  Created by DAMII on 23/12/25.
//

import UIKit
import FirebaseFirestore

struct Pomodoro : Codable {
    @DocumentID var id: String?
    let date: Date
    let time: Int
}
