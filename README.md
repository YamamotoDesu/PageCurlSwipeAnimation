# PageCurlSwipeAnimation
https://www.youtube.com/watch?v=eV9ybRJpuB8&list=TLGGZ5MvezILnkcyOTAzMjAyMw

### [PeelEffect part1](https://github.com/YamamotoDesu/PageCurlSwipeAnimation/commit/11ca59512f4fb64e72c731c7b6d9e4c0e7ca3c4d)
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

<img width="300" alt="スクリーンショット 2023-03-29 15 35 23" src="https://user-images.githubusercontent.com/47273077/228452441-17377997-ec3c-4ce4-b2b4-5641a26b39a4.gif">

PeelEffect.swift
```swift
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
                        let progress = min(1, translationX / size.width)
                        dragProgress = progress
```

<img width="300" alt="スクリーンショット 2023-03-29 15 35 23" src="https://user-images.githubusercontent.com/47273077/228467643-532b0a36-f073-4a5f-af07-3dc9705b36a8.gif">

PeelEffect.swift
```swift
            content
                /// Fliping Horizontallyh for Update Image
                .scaleEffect(x: -1)
                /// Moving A;long Side While Dragging
                .offset(x: size.width - (size.width * dragProgress))
                .contentShape(Rectangle())
                .gesture(
                    DragGesture()
                        .onChanged({ value in
                            /// Right to Left Swipe: Negative Value
                            var translationX = value.translation.width
                            translationX = max(-translationX, 0)
                            /// Converting Translation Into Progress [0 - 1]
                            let progress = min(1, translationX / size.width)
                            dragProgress = progress
                        }).onEnded({ value in
```

<img width="300" alt="スクリーンショット 2023-03-29 15 35 23" src="https://user-images.githubusercontent.com/47273077/228471952-cbcd772a-94c0-4d71-874a-0281ea391c61.gif">

```swift

            content
                /// Fliping Horizontallyh for Update Image
                .scaleEffect(x: -1)
                /// Moving A;long Side While Dragging
                .offset(x: size.width - (size.width * dragProgress))
                /// Masking Overlayed Image for Removing Outbound Visibility
                .mask {
                    Rectangle()
                }
 ```
 
## Make it more quicker

<img width="300" alt="スクリーンショット 2023-03-29 15 35 23" src="https://user-images.githubusercontent.com/47273077/228485673-72ccc1b6-d7ad-480c-aa45-a867fcf5d0eb.gif">

```swift
            .overlay {
                GeometryReader {
                    let rect = $0.frame(in: .global)
                    let size = $0.size
                    
                    content
                        /// Fliping Horizontallyh for Update Image
                        .scaleEffect(x: -1)
                        /// Moving A;long Side While Dragging
                        .offset(x: size.width - (size.width * dragProgress))
                        .offset(x: size.width * -dragProgress) // added
                        /// Masking Overlayed Image for Removing Outbound Visibility
                        .mask {
                            Rectangle()
                        }
                        .contentShape(Rectangle())
                        .gesture(
 ```
 
## Covering up the region
 
<img width="300" alt="スクリーンショット 2023-03-29 15 35 23" src="https://user-images.githubusercontent.com/47273077/228487323-75073631-7f6d-419c-84c4-273d370df8af.gif">
 
```swift
            .overlay {
                GeometryReader {
                    let rect = $0.frame(in: .global)
                    let size = $0.size
                    
                    content
                        /// Fliping Horizontallyh for Update Image
                        .scaleEffect(x: -1)
                        /// Moving A;long Side While Dragging
                        .offset(x: size.width - (size.width * dragProgress))
                        .offset(x: size.width * -dragProgress)
                        /// Masking Overlayed Image for Removing Outbound Visibility
                        .mask {
                            Rectangle()
                                .offset(x: size.width * -dragProgress) //added
                        }
```

## Set up Deleting BK

<img width="300" alt="スクリーンショット 2023-03-29 15 35 23" src="https://user-images.githubusercontent.com/47273077/228499929-cba15057-5394-442f-a11d-4e38c5addb01.gif">

```swift
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
                        /// Fliping Horizontallyh for Update Image
                        .scaleEffect(x: -1)
                        /// Moving A;long Side While Dragging
                        .offset(x: size.width - (size.width * dragProgress))
                        .offset(x: size.width * -dragProgress)
                        /// Masking Overlayed Image for Removing Outbound Visibility
                        .mask {
                            Rectangle()
                                .offset(x: size.width * -dragProgress)
                        }
                        .contentShape(Rectangle())
                        .gesture(
                            DragGesture()
                                .onChanged({ value in
                                    /// Right to Left Swipe: Negative Value
                                    var translationX = value.translation.width
                                    translationX = max(-translationX, 0)
                                    /// Converting Translation Into Progress [0 - 1]
                                    let progress = min(1, translationX / size.width)
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
            .background { //added
                RoundedRectangle(cornerRadius: 15, style: .continuous)
                    .fill(.red.gradient)
                    .overlay(alignment: .trailing) {
                        Image(systemName: "trash")
                            .font(.title)
                            .fontWeight(.semibold)
                            .padding(.trailing, 20)
                            .foregroundColor(.white)
                    }
                    .padding(.vertical, 8)
 ```
 
 ## Set Overlay
 
<img width="300" alt="スクリーンショット 2023-03-29 15 35 23" src="https://user-images.githubusercontent.com/47273077/228527721-713fc16e-d940-4a49-8b22-7763c76b1d3b.gif">

 ```swift
                     content
                        /// Making it Look like it's Rolling
                        .shadow(color: .black.opacity(dragProgress != 0 ? 0.1 : 0), radius: 5, x: 15, y:0)
                        .overlay {
                            Rectangle()
                                .fill(.white.opacity(0.25))
                                .mask(content)
                        }
```

## Make Shadow

<img width="300" alt="スクリーンショット 2023-03-29 15 35 23" src="https://user-images.githubusercontent.com/47273077/228531912-e299f148-6b94-4046-8346-eedc96db08cb.gif">

```swift
        /// Background Shadow
        .background {
            GeometryReader {
                let rect = $0.frame(in: .global)

                Rectangle()
                    .fill(.black)
                    .shadow(color: .black.opacity(0.3), radius: 15, x: 30, y: 0)
                    /// Moving Along Side While Dragging
                    .padding(.trailing, rect.width * dragProgress)
            }
            .mask(content)
        }
 ```    
