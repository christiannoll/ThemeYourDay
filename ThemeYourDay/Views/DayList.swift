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
            ScrollView {
                ScrollViewReader { proxy in
                    VStack {
                        ForEach(filteredDays, id: \.self) { day in
                            DayListCell(day: day)
                                .onTapGesture {
                                    modelData.selectDay(day)
                                    self.mode.wrappedValue.dismiss()
                                }
                                .padding(.vertical, 8)
                                .padding(.horizontal)
                        }
                    }.onAppear {
                        proxy.scrollTo(modelData.selectedDay, anchor: .top)
                    }
                    .onChange(of: query) {newQuery in
                        if newQuery.isEmpty {
                            proxy.scrollTo(modelData.selectedDay, anchor: .top)
                        }
                    }
                }
            }
            .navigationBarTitle("Days", displayMode: .inline)
            .navigationBarItems(trailing: Button(action: { showDeleteAlert.toggle() }) {
                Image(systemName: "trash")
            }.padding())
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
}

struct DayList_Previews: PreviewProvider {
    static var previews: some View {
        DayList()
            .environmentObject(ModelData())
    }
}
