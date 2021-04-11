import SwiftUI

struct DayList: View {
    var body: some View {
        VStack {
        List {
            Text("Item 1")
            Text("Item 2")
        }
        }
    }
}

struct DayList_Previews: PreviewProvider {
    static var previews: some View {
        DayList()
    }
}
