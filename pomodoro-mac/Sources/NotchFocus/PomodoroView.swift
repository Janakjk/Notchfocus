import SwiftUI
import AppKit

enum PomodoroPhase: String {
    case focus = "Focus"
    case shortBreak = "Short Break"
    case longBreak = "Long Break"

    var duration: Int {
        switch self {
        case .focus: return 25 * 60
        case .shortBreak: return 5 * 60
        case .longBreak: return 15 * 60
        }
    }
}

final class PomodoroViewModel: ObservableObject {
    @Published var phase: PomodoroPhase = .focus
    @Published var timeRemaining: Int = 25 * 60
    @Published var isRunning: Bool = false
    @Published var completedSessions: Int = 0

    private var timer: Timer?

    var formattedTime: String {
        let minutes = timeRemaining / 60
        let seconds = timeRemaining % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }

    func toggle() {
        if isRunning {
            pause()
        } else {
            start()
        }
    }

    func start() {
        guard !isRunning else { return }
        isRunning = true
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.tick()
        }
    }

    func pause() {
        isRunning = false
        timer?.invalidate()
        timer = nil
    }

    func reset() {
        pause()
        timeRemaining = phase.duration
    }

    func skip() {
        pause()
        nextPhase()
    }

    private func tick() {
        if timeRemaining > 0 {
            timeRemaining -= 1
        } else {
            NSSound.beep()
            nextPhase()
        }
    }

    private func nextPhase() {
        if phase == .focus {
            completedSessions += 1
            if completedSessions % 4 == 0 {
                phase = .longBreak
            } else {
                phase = .shortBreak
            }
        } else {
            phase = .focus
        }
        timeRemaining = phase.duration
        start()
    }
}

struct PomodoroView: View {
    @ObservedObject var viewModel: PomodoroViewModel
    var isExpanded: Bool

    var body: some View {
        HStack(spacing: 6) {
            Circle()
                .fill(indicatorColor)
                .frame(width: 7, height: 7)

            Text(viewModel.formattedTime)
                .font(.system(size: 13, weight: .bold, design: .monospaced))
                .foregroundColor(.white)

            Button(action: { viewModel.toggle() }) {
                Image(systemName: viewModel.isRunning ? "pause.fill" : "play.fill")
                    .font(.system(size: 9))
                    .foregroundColor(.white)
                    .frame(width: 18, height: 18)
                    .background(Color.white.opacity(0.18))
                    .clipShape(Circle())
            }
            .buttonStyle(.plain)

            if isExpanded {
                Button(action: { viewModel.skip() }) {
                    Image(systemName: "forward.fill")
                        .font(.system(size: 9))
                        .foregroundColor(.gray)
                }
                .buttonStyle(.plain)

                Button(action: { viewModel.reset() }) {
                    Image(systemName: "arrow.counterclockwise")
                        .font(.system(size: 9))
                        .foregroundColor(.gray)
                }
                .buttonStyle(.plain)
            }
        }
    }

    private var indicatorColor: Color {
        switch viewModel.phase {
        case .focus: return .red
        case .shortBreak: return .green
        case .longBreak: return .blue
        }
    }
}
