import SwiftUI

struct DayWidgetView: View {
    
    let day: Day
    
    var body: some View {
        VStack {
            Spacer()
            Text(Date().formatted())
                .background(Color.gray)
                .foregroundColor(.white)
            Spacer()
                
            Text(day.text)
                .font(day.fontname == "" ? .largeTitle : .custom(day.fontname, size: 34))
                .background(day.bgColor.color)
                .foregroundColor(day.fgColor.color)
                .frame(height: 100)
                .multilineTextAlignment(.center)
                .disableAutocorrection(true)
                .lineSpacing(20)
        }
        .background(.gray)
        .cornerRadius(25.0)
        .padding()
    }
}

struct DayWidgetView_Previews: PreviewProvider {
    static var previews: some View {
        DayWidgetView(day: Day(id: Date(), text: "Today", fgColor: DayColor()))
    }
}
