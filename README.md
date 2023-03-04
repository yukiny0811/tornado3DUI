# Tornado3DUI

Still Work in Progress!!

## Demo

![Simulator - iPhone 14 Pro 2023年-03月-03日 21 07 00](https://user-images.githubusercontent.com/28947703/222716392-a1ab4f2c-0c8e-43b5-a85e-bc7e749b38af.gif)

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

### Fully Configurable
<img width="537" alt="image" src="https://user-images.githubusercontent.com/28947703/222716655-093158ee-9773-42f7-9afc-b15784c603b9.png">

