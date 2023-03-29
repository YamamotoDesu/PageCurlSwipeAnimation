# PageCurlSwipeAnimation
https://www.youtube.com/watch?v=eV9ybRJpuB8&list=TLGGZ5MvezILnkcyOTAzMjAyMw

### [PeelEffect part1]()
<img width="300" alt="スクリーンショット 2023-03-29 15 35 23" src="https://user-images.githubusercontent.com/47273077/228446717-853cf404-308c-4b03-a42f-b2c548eabddc.gif">

Home.swift
```swift
import SwiftUI

struct Home: View {
    /// Sample Model for Displaying Images
    @State private var images: [ImageModel] = [
    ]
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 20) {
                ForEach(images) { image in
                    PeelEffect {
                        CardView(image)
                    } onDelete: {
                        
                    }
                }
            }
            .padding(15)
        }
        .onAppear {
            for index in 1...4 {
                images.append(.init(assetName: "Pic \(index)"))
            }
        }
    }
    
    @ViewBuilder
    func CardView(_ imageModel: ImageModel) -> some View {
        GeometryReader {
            let size = $0.size
            
            ZStack {
                Image(imageModel.assetName)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: size.width, height: size.height)
                    .clipShape(RoundedRectangle(cornerRadius: 15, style: .continuous))
            }
        }
        .frame(height: 130)
        .contentShape(Rectangle())
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct ImageModel: Identifiable {
    var id: UUID = .init()
    var assetName: String
}

```

PeelEffect.swift
```swift
import SwiftUI

/// Custom View Builder
struct PeelEffect<Content: View>: View {
    var content: Content
    /// Delete Callback for MainView, When Delete is Clicked
    var onDelete: () -> ()
    
    init(@ViewBuilder content: @escaping () -> Content, onDelete: @escaping () -> () ) {
        self.content = content()
        self.onDelete = onDelete
    }
    /// View Properties
    @State private var dragProgress: CGFloat = 0
    var body: some View {
        content
        /// Masking Original Content
            .mask {
                GeometryReader {
                    let rect = $0.frame(in: .global)
                    
                    Rectangle()
                    /// Swipe: Right to Left
                    /// Thus Masking from Right to Left ( Trailing)
                        .padding(.trailing, dragProgress * rect.width)
                }
            }
            .overlay {
                GeometryReader {
                    let rect = $0.frame(in: .global)
                    let size = $0.size
                    
                    content
                        .offset(x: size.width)
                        .contentShape(Rectangle())
                        .gesture(
                            DragGesture()
                                .onChanged({ value in
                                    /// Right to Left Swipe: Negative Value
                                    var translationX = value.translation.width
                                    translationX = max(-translationX, 0)
                                    /// Converting Translation Into Progress [0 - 1]
                                    let progress = max(1, translationX / size.width)
                                    dragProgress = progress
                                }).onEnded({ value in
                                    /// Smooth Ending Animation
                                    withAnimation(.spring(response: 0.6, dampingFraction: 0.7, blendDuration: 0.7)) {
                                        dragProgress = .zero
                                    }
                                })
                        )
                }
            }
    }
}

struct PeelEffect_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
```
