import SwiftUI
import PageView

struct newsView: View {
    @State private var pageIndex = 0
    
    
    
    var body: some View {
        
        HPageView(selectedPage: $pageIndex) {
            Image(uiImage: UIImage(named: "newsDeneme")!)
                .resizable()
                .aspectRatio(contentMode: .fit)
            Image(uiImage: UIImage(named: "newsDeneme2")!)
                .resizable()
                .aspectRatio(contentMode: .fit)
            
            Image(uiImage: UIImage(named: "newsDeneme3")!)
                .resizable()
                .aspectRatio(contentMode: .fit)
        }
       
    }
}
