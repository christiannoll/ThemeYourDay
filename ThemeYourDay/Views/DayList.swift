import SwiftUI

struct DayList: View {
    @EnvironmentObject var modelData: ModelData
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    @State var showDeleteAlert = false
    @State private var query = ""
    @State private var searching = false
    
    private var filteredDays: [Day] {
        let result = modelData.days.filter {
            $0.text.range(of: query, options: .caseInsensitive) != nil
        }
        return query.isEmpty ? modelData.days : result
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
                            modelData.selectDay(day)
                            self.mode.wrappedValue.dismiss()
                        }
                        .padding(.vertical, 8)
                        .id(day)
                        .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
                        .listRowSeparator(.hidden)
                }
                .scrollContentBackground(.hidden)
                .onAppear {
                    proxy.scrollTo(modelData.selectedDay, anchor: .center)
                }
                .onChange(of: query) {newQuery in
                    if newQuery.isEmpty {
                        proxy.scrollTo(modelData.selectedDay, anchor: .center)
                    }
                }
            }
            .navigationBarTitle("Days", displayMode: .inline)
            .navigationBarItems(trailing: Menu {
                Button(action: { showDeleteAlert.toggle()}) {
                    Label("Remove themes", systemImage: "trash")
                }
                Button(action: { shareSheet()}) {
                    Label("Share themes", systemImage: "square.and.arrow.up")
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
        modelData.removeAllDays()
    }
    
    private func shareSheet() {
        modelData.exportAsCsvFile()
        
        let file = FileManager.sharedContainerURL().appendingPathComponent("ExortedDays.csv")
        let url = NSURL.fileURL(withPath: file.path)
        let activityVC = UIActivityViewController(activityItems: [url], applicationActivities: nil)
        let keyWindow = UIApplication.shared.connectedScenes
                .filter({$0.activationState == .foregroundActive})
                .map({$0 as? UIWindowScene})
                .compactMap({$0})
                .first?.windows
                .filter({$0.isKeyWindow}).first
        keyWindow?.rootViewController?.present(activityVC, animated: true, completion: nil)
    }
}

struct DayList_Previews: PreviewProvider {
    static var previews: some View {
        DayList()
            .environmentObject(ModelData())
    }
}
