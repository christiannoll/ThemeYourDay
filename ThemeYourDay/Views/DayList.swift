import SwiftUI
import SwiftData

struct DayList: View {
    @EnvironmentObject var modelData: ModelData
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    @State var showDeleteAlert = false
    @State private var query = ""
    @State private var searching = false
    
    @Query(sort: [SortDescriptor(\Day.id)]) private var days: [Day]
    @Query() var settings: [Settings]
    
    private var filteredDays: [Day] {
        let result = days.filter {
            $0.text.range(of: query, options: .caseInsensitive) != nil
        }
        return query.isEmpty ? days : result
    }
    
    var body: some View {
        VStack {
            if searching {
                SearchBar(searchText: $query, searching: $searching)
            }
            ScrollViewReader { proxy in
                List(filteredDays) {
                    let day = $0
                    DayListCell(day: day, isToday: modelData.isToday(day: day))
                        .onTapGesture {
                            modelData.selectDay(day, days: days)
                            self.mode.wrappedValue.dismiss()
                        }
                        .padding(.vertical, 8)
                        .id(day)
                        .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
                        .listRowSeparator(.hidden)
                }
                .scrollContentBackground(.hidden)
                .onAppear {
                    proxy.scrollTo(modelData.getToday(days), anchor: .center)
                }
                .onChange(of: query) {
                    if query.isEmpty {
                        if let selectedDay = modelData.selectedDay {
                            proxy.scrollTo(selectedDay, anchor: .center)
                        }
                    }
                }
            }
            .navigationBarTitle(.days, displayMode: .inline)
            .navigationBarItems(trailing: Menu {
                Button(action: { showDeleteAlert.toggle()}) {
                    Label(.removeThemes, systemImage: "trash")
                }
                Button(action: { shareCsvFile()}) {
                    Label(.exportThemes, systemImage: "square.and.arrow.up")
                }
            } label: { Image(systemName: "ellipsis.circle") })
            .navigationBarItems(trailing: Button(action: { withAnimation {searching.toggle() }} ) {
                Image(systemName: "magnifyingglass")
            })
            .alert(isPresented: $showDeleteAlert) {
                Alert(title: Text("Remove All Themes?"), message: Text("This will remove all themes and can't be undone."), primaryButton: .destructive(Text("Remove"), action: { removeAllDays() }), secondaryButton: .cancel(Text("Cancel")))
            }
        }
    }
    
    private func removeAllDays() {
        if let mySettings = settings.first {
            modelData.removeAllDays(days, settings: mySettings)
        }
    }
    
    private func shareCsvFile() {
        if let mySettings = settings.first {
            modelData.exportAsCsvFile(days, settings: mySettings)
            Tools.showShareSheet(fileName: "ExortedDays.csv")
        }
    }
}

struct DayList_Previews: PreviewProvider {
    static var previews: some View {
        DayList()
            .environmentObject(ModelData())
    }
}
