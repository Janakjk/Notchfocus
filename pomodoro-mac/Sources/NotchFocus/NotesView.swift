import SwiftUI

struct StickyNote: Identifiable, Codable, Equatable {
    var id: UUID = UUID()
    var text: String
    var colorIndex: Int = 0
}

final class NotesViewModel: ObservableObject {
    @Published var notes: [StickyNote] = [] {
        didSet {
            saveNotes()
        }
    }

    private let fileURL: URL

    init() {
        let fileManager = FileManager.default
        let appSupport = fileManager.urls(for: .applicationSupportDirectory, in: .userDomainMask).first!
        let folderURL = appSupport.appendingPathComponent("NotchFocus", isDirectory: true)

        if !fileManager.fileExists(atPath: folderURL.path) {
            try? fileManager.createDirectory(at: folderURL, withIntermediateDirectories: true)
        }

        self.fileURL = folderURL.appendingPathComponent("notes.json")
        loadNotes()
    }

    func addNote() {
        let colorsCount = NoteCardView.cardColors.count
        let nextColor = notes.count % colorsCount
        let newNote = StickyNote(text: "New note", colorIndex: nextColor)
        notes.insert(newNote, at: 0)
    }

    func deleteNote(id: UUID) {
        notes.removeAll { $0.id == id }
    }

    private func loadNotes() {
        guard let data = try? Data(contentsOf: fileURL),
              let decoded = try? JSONDecoder().decode([StickyNote].self, from: data) else {
            notes = [StickyNote(text: "Welcome to NotchFocus!", colorIndex: 0)]
            return
        }
        self.notes = decoded
    }

    private func saveNotes() {
        guard let data = try? JSONEncoder().encode(notes) else { return }
        try? data.write(to: fileURL, options: [.atomic])
    }
}

struct NoteCardView: View {
    @Binding var note: StickyNote
    var onDelete: () -> Void

    static let cardColors: [Color] = [
        Color(red: 1.0, green: 0.95, blue: 0.6),  // pastel yellow
        Color(red: 0.8, green: 0.95, blue: 0.8),  // pastel green
        Color(red: 0.8, green: 0.9, blue: 1.0),   // pastel blue
        Color(red: 1.0, green: 0.8, blue: 0.85)   // pastel pink
    ]

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Spacer()
                Button(action: onDelete) {
                    Image(systemName: "xmark.circle.fill")
                        .font(.system(size: 11))
                        .foregroundColor(.black.opacity(0.4))
                }
                .buttonStyle(.plain)
            }
            TextField("Note", text: $note.text, axis: .vertical)
                .textFieldStyle(.plain)
                .font(.system(size: 12))
                .foregroundColor(.black)
                .lineLimit(1...4)
        }
        .padding(8)
        .background(NoteCardView.cardColors[note.colorIndex % NoteCardView.cardColors.count])
        .cornerRadius(8)
    }
}

struct NotesView: View {
    @ObservedObject var viewModel: NotesViewModel

    var body: some View {
        VStack(spacing: 8) {
            HStack {
                Text("Notes")
                    .font(.system(size: 11, weight: .bold))
                    .foregroundColor(.gray)
                Spacer()
                Button(action: { viewModel.addNote() }) {
                    Image(systemName: "plus")
                        .font(.system(size: 10, weight: .bold))
                        .foregroundColor(.white)
                        .padding(4)
                        .background(Color.white.opacity(0.2))
                        .clipShape(Circle())
                }
                .buttonStyle(.plain)
            }

            ScrollView(.vertical, showsIndicators: false) {
                LazyVStack(spacing: 6) {
                    ForEach($viewModel.notes) { $note in
                        NoteCardView(note: $note) {
                            viewModel.deleteNote(id: note.id)
                        }
                    }
                }
            }
        }
    }
}

