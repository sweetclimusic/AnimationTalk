//
//  ImplicitAnimation.swift
//  AnimationTalk
//
//  Created by Ashlee Muscroft on 23/09/2024.
//

import SwiftUI

struct ImplicitAnimation: View {
    @ScaledMetric private var imageViewWidth = CGFloat(100)
    @State private var badgeShow = false
    @Namespace private var envelope
    
    @State private var isAnimating: Bool = false
    @State private var buttonText = "Animate"
    @State private var textOpacity: Double = 1
    
    
    var body: some View {
        VStack(spacing: .zero) {
            VStack(alignment: .leading) {
                ZStack {
                    if badgeShow {
                        Image(systemName: "envelope.badge")
                            .resizable()
                            .scaledToFit()
                            .foregroundStyle(.red)
                            .frame(width: imageViewWidth, height: 80)
                            .animation(.easeInOut){ content in
                                content.scaleEffect(badgeShow ? 1.17 : 0, anchor: .bottomLeading)
                            }
                            .padding(.zero)
                            .matchedGeometryEffect(id: "letter", in: envelope)
                        
                    } else {
                        Image(systemName: "envelope.fill")
                            .resizable()
                            .scaledToFit()
                            .foregroundStyle(.tint)
                            .frame(width: imageViewWidth, height: 80)
                            .padding(.zero)
                            .matchedGeometryEffect(id: "letter", in: envelope)
                            .background(Color.white)
                    }
                    
                }.frame(width: imageViewWidth, height: 80)
            }
            Spacer()
        }
        .padding()
        .safeAreaInset(edge: .bottom,
                       content: {
            Button(
                action: {
                    badgeShow.toggle()
                },
                label: {
                    Text( badgeShow ? "Default" : "Notification" )
                        .font(.largeTitle)
                        .foregroundStyle(.white)
                }
            )
            .padding()
            .background(
                Capsule()
                    .fill(.blue)
            )
        })
    }
}

#Preview {
    ImplicitAnimation()
}
