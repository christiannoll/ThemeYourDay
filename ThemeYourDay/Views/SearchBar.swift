import SwiftUI

struct SearchBar: View {
    @Binding var searchText: String
    @Binding var searching: Bool
    
    var body: some View {
        HStack {
            Spacer()
            HStack {
                Image(systemName: "magnifyingglass")
                TextField("Search", text: $searchText)
                    .padding([.top, .bottom, .trailing], 8)
                .background(Color(.systemGray6))
                Spacer()
                Button(action: { withAnimation { searching = false }
                    searchText = ""
                } ) {
                    Text("Cancel")
                }.padding()
            }
            .foregroundColor(.gray)
            .padding(.leading, 13)
            .background(Color(.systemGray6))
            .frame(height: 40)
            .cornerRadius(13)
            .padding()
            Spacer()
        }
    }
}

struct SearchBar_Previews: PreviewProvider {
    static var previews: some View {
        SearchBar(searchText: .constant(""), searching: .constant(false))
    }
}
