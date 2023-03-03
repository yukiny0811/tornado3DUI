# Tornado3DUI

## Usage

```.swift
import SwiftyCreatives
import CoreGraphics
import SwiftUI

struct ContentView: View {
    @ObservedObject var sketch = TornadoSketch{
        let image = UIImage(named: "image")!.cgImage!
        return (UUID().uuidString, image)
    }
    var body: some View {
        VStack {
            TornadoView(sketch)
                .onAppear {
                    sketch.resetAll()
                }
        }
        .background(.black)
        .confirmationDialog(
            "Some Title",
            isPresented: $sketch.someCardSelected,
            titleVisibility: .visible
        ) {
            VStack {
                Button(role: .destructive) {
                    print("id: " + (sketch.selectedId! as! String))
                } label: {
                    Text("do something")
                }
            }
        } message: {
            Text("this is message")
        }

    }
}
```
