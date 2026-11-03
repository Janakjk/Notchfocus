import AppKit
import SwiftUI

final class NotchWindow: NSPanel {
    init(contentRect: NSRect) {
        super.init(
            contentRect: contentRect,
            styleMask: [.borderless, .nonactivatingPanel],
            backing: .buffered,
            defer: false
        )

        self.level = .statusBar
        self.collectionBehavior = [.canJoinAllSpaces, .fullScreenAuxiliary]
        self.isOpaque = false
        self.backgroundColor = .clear
        self.hasShadow = false
        self.isMovableByWindowBackground = false
        self.ignoresMouseEvents = false
    }

    override var canBecomeKey: Bool {
        return true
    }

    override var canBecomeMain: Bool {
        return false
    }
}

final class NotchWindowController: NSObject, ObservableObject {
    private var window: NotchWindow?
    private var isExpanded: Bool = false {
        didSet {
            updateWindowFrame(animated: true)
        }
    }

    let pomodoroVM = PomodoroViewModel()
    let notesVM = NotesViewModel()

    func setupWindow() {
        let initialWidth: CGFloat = 220
        let initialHeight: CGFloat = 34
        let initialRect = calculateFrame(width: initialWidth, height: initialHeight)

        let panel = NotchWindow(contentRect: initialRect)

        let contentView = ContentView(
            pomodoroVM: pomodoroVM,
            notesVM: notesVM,
            isExpanded: Binding(
                get: { self.isExpanded },
                set: { self.isExpanded = $0 }
            )
        )

        let hostingView = NSHostingView(rootView: contentView)
        hostingView.autoresizingMask = [.width, .height]
        hostingView.frame = NSRect(x: 0, y: 0, width: initialWidth, height: initialHeight)
        panel.contentView = hostingView
        self.window = panel

        updateWindowFrame(animated: false)
        panel.orderFrontRegardless()
    }

    func toggleVisibility() {
        guard let window = window else { return }
        if window.isVisible {
            window.orderOut(nil)
        } else {
            updateWindowFrame(animated: false)
            window.orderFrontRegardless()
        }
    }

    func toggleNotes() {
        if let window = window, !window.isVisible {
            window.orderFrontRegardless()
        }
        isExpanded.toggle()
    }

    var isVisible: Bool {
        window?.isVisible ?? false
    }

    private func calculateFrame(width: CGFloat, height: CGFloat) -> NSRect {
        let screen = NSScreen.screens.first ?? NSScreen.main
        guard let screen = screen else {
            return NSRect(x: 100, y: 100, width: width, height: height)
        }

        let screenFrame = screen.frame
        let x = round(screenFrame.midX - (width / 2.0))
        let y = screenFrame.maxY - height
        return NSRect(x: x, y: y, width: width, height: height)
    }

    private func updateWindowFrame(animated: Bool) {
        guard let window = window else { return }
        let width: CGFloat = isExpanded ? 330 : 220
        let height: CGFloat = isExpanded ? 280 : 34
        let targetFrame = calculateFrame(width: width, height: height)

        if animated {
            NSAnimationContext.runAnimationGroup { context in
                context.duration = 0.22
                context.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
                window.animator().setFrame(targetFrame, display: true)
            }
        } else {
            window.setFrame(targetFrame, display: true)
        }
    }
}
