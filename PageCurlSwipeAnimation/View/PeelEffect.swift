//
//  PeelEffect.swift
//  PageCurlSwipeAnimation
//
//  Created by 山本響 on 2023/03/29.
//

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
