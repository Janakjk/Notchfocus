import SwiftUI

struct NotchShape: Shape {
    var cornerRadius: CGFloat = 12

    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.minX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY - cornerRadius))
        path.addArc(
            center: CGPoint(x: rect.maxX - cornerRadius, y: rect.maxY - cornerRadius),
            radius: cornerRadius,
            startAngle: Angle(degrees: 0),
            endAngle: Angle(degrees: 90),
            clockwise: false
        )
        path.addLine(to: CGPoint(x: rect.minX + cornerRadius, y: rect.maxY))
        path.addArc(
            center: CGPoint(x: rect.minX + cornerRadius, y: rect.maxY - cornerRadius),
            radius: cornerRadius,
            startAngle: Angle(degrees: 90),
            endAngle: Angle(degrees: 180),
            clockwise: false
        )
        path.closeSubpath()
        return path
    }
}

struct ContentView: View {
    @ObservedObject var pomodoroVM: PomodoroViewModel
    @ObservedObject var notesVM: NotesViewModel
    @Binding var isExpanded: Bool

    var body: some View {
        VStack(spacing: 8) {
            // Top Notch Bar
            HStack(spacing: 8) {
                // Pomodoro Timer
                PomodoroView(viewModel: pomodoroVM, isExpanded: isExpanded)

                Divider()
                    .frame(height: 14)
                    .background(Color.white.opacity(0.25))

                // Notes button beside the timer
                Button(action: {
                    withAnimation(.easeInOut(duration: 0.22)) {
                        isExpanded.toggle()
                    }
                }) {
                    HStack(spacing: 4) {
                        Image(systemName: "note.text")
                            .font(.system(size: 11, weight: .semibold))
                        Text("Notes")
                            .font(.system(size: 11, weight: .semibold))
                        if !notesVM.notes.isEmpty {
                            Text("\(notesVM.notes.count)")
                                .font(.system(size: 9, weight: .bold))
                                .padding(.horizontal, 4)
                                .padding(.vertical, 1)
                                .background(Color.white.opacity(0.2))
                                .clipShape(Capsule())
                        }
                        Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                            .font(.system(size: 8, weight: .bold))
                            .foregroundColor(.gray)
                    }
                    .foregroundColor(isExpanded ? .yellow : .white)
                    .padding(.horizontal, 6)
                    .padding(.vertical, 3)
                    .background(isExpanded ? Color.white.opacity(0.18) : Color.white.opacity(0.08))
                    .cornerRadius(6)
                }
                .buttonStyle(.plain)
            }
            .frame(height: 24)

            // Sticky Notes dropdown panel
            if isExpanded {
                Divider()
                    .background(Color.white.opacity(0.15))
                NotesView(viewModel: notesVM)
                    .frame(maxHeight: .infinity)
            }
        }
        .padding(.horizontal, 10)
        .padding(.top, 5)
        .padding(.bottom, isExpanded ? 10 : 5)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .background(
            NotchShape(cornerRadius: 12)
                .fill(Color.black)
                .shadow(color: Color.black.opacity(0.4), radius: 6, x: 0, y: 3)
        )
    }
}
