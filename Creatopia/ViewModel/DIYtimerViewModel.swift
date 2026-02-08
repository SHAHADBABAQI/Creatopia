//
//  DIYtimerViewModel.swift
//  Creatopia
//
//  Created by Sarah Khalid Almalki on 20/08/1447 AH.
//

import SwiftUI
import Combine

class DIYtimerViewModel: ObservableObject {
    @Published var timeRemaining: Int
    @Published var timerState: TimerState
    @Published var showConfetti: Bool = false

    private var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    private var cancellables = Set<AnyCancellable>()

    init(duration: Int = TimerConstants.defaultDuration) {
        self.timeRemaining = duration
        self.timerState = .running

        timer
            .sink { [weak self] _ in
                self?.tick()
            }
            .store(in: &cancellables)
    }

    private func tick() {
        guard timerState == .running else { return }

        if timeRemaining > 0 {
            timeRemaining -= 1
        } else {
            timerState = .finished
            showConfetti = true
        }
    }

    func restart() {
        timeRemaining = TimerConstants.defaultDuration
        timerState = .running
        showConfetti = false
    }

    func pause() {
        if timerState == .running {
            timerState = .paused
        } else if timerState == .paused {
            timerState = .running
        }
    }
}
