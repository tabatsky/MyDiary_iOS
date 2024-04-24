//
//  ContentView.swift
//  MyDiary
//
//  Created by Evgeny Tabatsky on 03.08.2023.
//

import SwiftUI

struct ContentView: View {
    @State var entryId = 0
    @State var entries = Deps.getEntryRepository().getAll()
    @State var topEntries: [Entry?] = makeTopEntries(allEntries: Deps.getEntryRepository().getAll())
    
    @State var needShowDeleteConfirmationDialog = false
    @State var entryToDelete: Entry? = nil
    
    @State var needShowDeleteByTypeConfirmationDialog = false
    @State var typeToDelete = -1
    
    @State var typeOfFilter = -1
    
    var body: some View {
        GeometryReader { screenGeometry in
            let A = screenGeometry.size.width / 6
            
            VStack {
                let columns = [
                    GridItem(.flexible()),
                    GridItem(.flexible())
                ]
                LazyVGrid(columns: columns
                ) {
                    ForEach(1...6, id: \.self) { type in
                        let entry = topEntries[type - 1]
                        let text = entry != nil ? formatTimeTop(entry: entry!) : "Never"
                        Text(text)
                            .font(Font.headline.weight(self.typeOfFilter == type ? .bold : .regular))
                            .padding(20)
                            .frame(maxWidth: .infinity, maxHeight: A)
                            .background(ColorDict.getColorByType(type: type))
                            .simultaneousGesture(
                                LongPressGesture()
                                    .onEnded { _ in
                                        showDeleteByTypeConfirmationDialog(type: type)
                                    }
                            )
                            .highPriorityGesture(
                                TapGesture()
                                    .onEnded { _ in
                                        self.typeOfFilter = self.typeOfFilter == type ? -1 : type
                                        updateEntries()
                                    }
                            )
                    }
                }.frame(maxWidth: .infinity, maxHeight: 4 * A)
            
                
                GeometryReader { geometry in ScrollView(.vertical) {
                    let columns = [
                        GridItem(.flexible()),
                        GridItem(.flexible())
                    ]
                    LazyVGrid(columns: columns
                    ) {
                        ForEach(self.entries, id: \.id) { entry in
                            Text(formatTimeForList(entry: entry))
                                .padding(20)
                                .frame(maxWidth: .infinity, maxHeight: A)
                                .background(ColorDict.getColorByType(type: entry.type))
                                .simultaneousGesture(
                                    LongPressGesture()
                                        .onEnded { _ in
                                            showDeleteConfirmationDialog(entry: entry)
                                        }
                                )
                                .highPriorityGesture(
                                    TapGesture()
                                        .onEnded { _ in }
                                )
                        }.frame(maxWidth: .infinity, maxHeight: geometry.size.height)
                    }
                }}.frame(maxWidth: .infinity, maxHeight: screenGeometry.size.height - 5 * A)

                
                HStack {
                    ForEach(1...6, id: \.self) { type in
                        Button(action: {}) {
                            Text(String(type))
                                .frame(maxWidth: A, maxHeight: A)
                                .background(ColorDict.getColorByType(type: type))
                        }
                        .simultaneousGesture(
                            LongPressGesture()
                                .onEnded { _ in
                                    showDatePickerAlert(type: type)
                                }
                        )
                        .highPriorityGesture(
                            TapGesture()
                                .onEnded { _ in
                                    addEntry(type: type)
                                }
                        )
                    }
                }.frame(maxWidth: .infinity, maxHeight: A)
            }
            .background(Color.black)
            .confirmationDialog("Delete entry?",
                                 isPresented: $needShowDeleteConfirmationDialog,
                                 titleVisibility: .visible
            ) {
                Button("Delete", action: {
                    deleteEntry(entry: self.entryToDelete!)
                    hideDeleteConfirmationDialog()
                })
            }
            .confirmationDialog("Delete all entries of type \(self.typeToDelete)?",
                                 isPresented: $needShowDeleteByTypeConfirmationDialog,
                                 titleVisibility: .visible
            ) {
                Button("Delete", action: {
                    deleteAllEntriesOfType(type: self.typeToDelete)
                    hideDeleteByTypeConfirmationDialog()
                })
            }
        }
    }
    
    var currentKeyWindow: UIWindow? {
        UIApplication.shared.connectedScenes
          .filter { $0.activationState == .foregroundActive }
          .map { $0 as? UIWindowScene }
          .compactMap { $0 }
          .first?.windows
          .filter { $0.isKeyWindow }
          .first
      }
    
    func addEntry(type: Int) {
        let newEntry = makeEntry(type: type)
        Deps.getEntryRepository().add(entry: newEntry)
        updateEntries()
    }
    
    func addEntry(type: Int, date: Date) {
        let newEntry = makeEntry(type: type, date: date)
        Deps.getEntryRepository().add(entry: newEntry)
        updateEntries()
    }
    
    func deleteEntry(entry: Entry) {
        Deps.getEntryRepository().delete(entry: entry)
        updateEntries()
    }
    
    func deleteAllEntriesOfType(type: Int) {
        Deps.getEntryRepository().deleteAllOfType(type: type)
        updateEntries()
    }
    
    func updateEntries() {
        self.entries = Deps.getEntryRepository().getAll()
        if (self.typeOfFilter >= 0) {
            self.entries = self.entries.filter {
                $0.type == self.typeOfFilter
            }
        }
        self.topEntries = makeTopEntries(allEntries: self.entries)
    }
    
    func showDatePickerAlert(type: Int) {
        let alertVC = UIAlertController(title: "\n\n", message: nil, preferredStyle: .actionSheet)
        let datePicker: UIDatePicker = UIDatePicker()
        alertVC.view.addSubview(datePicker)
    
        let popController = alertVC.popoverPresentationController
        
        popController?.sourceView = datePicker
        popController?.sourceRect = .init(x: 0, y: 100, width: alertVC.view.bounds.size.width, height: alertVC.view.bounds.size.height)
    
        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
            addEntry(type: type, date: datePicker.date)
        }
        alertVC.addAction(okAction)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alertVC.addAction(cancelAction)

        if let viewController = currentKeyWindow?.rootViewController {
            viewController.present(alertVC, animated: true, completion: nil)
        }
    }
    
    func showDeleteConfirmationDialog(entry: Entry) {
        self.needShowDeleteConfirmationDialog = true
        self.entryToDelete = entry
    }
    
    func hideDeleteConfirmationDialog() {
        self.needShowDeleteConfirmationDialog = false
        self.entryToDelete = nil
    }
    
    func showDeleteByTypeConfirmationDialog(type: Int) {
        self.needShowDeleteByTypeConfirmationDialog = true
        self.typeToDelete = type
    }
    
    func hideDeleteByTypeConfirmationDialog() {
        self.needShowDeleteByTypeConfirmationDialog = false
        self.typeToDelete = -1
    }
}

func makeTopEntries(allEntries: [Entry]) -> [Entry?] {
    return (1...6)
        .map { type in
            allEntries.first(where: { entry in
                entry.type == type
            })
        }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
