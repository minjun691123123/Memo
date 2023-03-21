//
//  memoWidget.swift
//  memoWidget
//
//  Created by 송민준 on 2023/03/17.
//

import WidgetKit
import SwiftUI
import Intents






extension UserDefaults{
    static var shared : UserDefaults{
        
        let appGroupId = "group.dynozer.memo"
       
        
        return UserDefaults(suiteName: appGroupId)!
    }
}






struct Provider: IntentTimelineProvider {
    var text : String = ""
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry( date: Date(), configuration: ConfigurationIntent())
    }

    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry( date: Date(), configuration: configuration)
        completion(entry)
    }

    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []
  
       
        
   

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
     
        
        
        for hourOffset in 0 ..< 30 {
            let entryDate = Calendar.current.date(byAdding: .second, value: hourOffset, to: currentDate)!
            
            let entry = SimpleEntry( date: entryDate, configuration: configuration)
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}




struct SimpleEntry: TimelineEntry {
   
    let date: Date
    let configuration: ConfigurationIntent
}




struct memoWidgetEntryView : View {
    var entry: Provider.Entry

    
    
   
    let textWidget : String = UserDefaults.shared.value(forKey: "textWidgetData") as! String
    
    var body: some View {
        
        GeometryReader() { geometry in
            
           
                VStack(spacing: 0){
                    
                    Text(entry.date, style: .time)
                        .frame(maxWidth: geometry.size.width,maxHeight: geometry.size.height / 6)
                        .background(Color.blue)
                        .foregroundColor(Color.white)
                        .fontWeight(.bold)
                       
                        
                    
                    Text(textWidget)
                        .frame(maxWidth: geometry.size.width,maxHeight: geometry.size.height)
                        .background(Color.gray)
                        .foregroundColor(Color.white)
                        .fontWeight(.bold)
                       
                    
                    
   
                
               
            }
            
        }}
    
}




struct memoWidget: Widget {
    let kind: String = "memoWidget"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            memoWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
    }
}

struct memoWidget_Previews: PreviewProvider {
    static var previews: some View {
        memoWidgetEntryView(entry: SimpleEntry( date: Date(), configuration: ConfigurationIntent()))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
