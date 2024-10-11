//
//  KeyFrameAnimatorView.swift
//  AnimationTalk
//
//  Created by Ashlee Muscroft on 19/09/2024.
//

import SwiftUI

struct DotAnimationValues {
    var offset: CGSize = .zero
    var scale: CGFloat = 0
    var opacity: CGFloat = 0.3
    var zIndex: Double = 2
}

struct KeyFrameAnimatorView: View {
    @ScaledMetric var imageViewWidth = CGFloat(100)
    @State var badgeShow = false
    @State var orbitShow = false
    @Namespace private var envelope
    
    @State var isAnimating: Bool = false
    @State private var buttonText = "Animate"
    @State private var textOpacity = 1.0
    
    var body: some View {
        VStack(spacing: .zero) {
            VStack(alignment: .leading) {
                ZStack {
                    // Dot with KeyframeAnimator
                    if !badgeShow {
                        KeyframeAnimator(initialValue: DotAnimationValues(), trigger: isAnimating) { values in
                            Circle()
                                .fill(Color.red)
                                .frame(width: 20, height: 20)
                                .offset(values.offset)
                                .zIndex(values.zIndex)
                                .scaleEffect(values.scale)
                                .opacity(values.opacity)
                        } keyframes: { _ in
                            KeyframeTrack(\.offset) {
                                CubicKeyframe(CGSize(width: 30, height: 0), duration: 0.1)
                                SpringKeyframe(CGSize(width: 60, height: -37), duration: 0.18, spring: .bouncy)
                                CubicKeyframe(CGSize(width: 38, height: -25), duration: 0.08)
                            }
                            
                            KeyframeTrack(\.scale) {
                                CubicKeyframe(0, duration: 0.1)
                                CubicKeyframe(1.5, duration: 0.18)
                            }
                            
                            KeyframeTrack(\.opacity) {
                                CubicKeyframe(0.3, duration: 0.1)
                                CubicKeyframe(1.0, duration: 0.18)
                                CubicKeyframe(0.0, duration: 0.08)
                            }
                            
                            KeyframeTrack(\.zIndex) {
                                CubicKeyframe(2.0, duration: 0.1)
                                CubicKeyframe(1.0, duration: 0.18)
                                CubicKeyframe(0.0, duration: 0.08)
                            }
                        }
                    }
                    
                    if badgeShow {
                        Image(systemName: "envelope.badge")
                            .resizable()
                            .scaledToFit()
                            .foregroundStyle(.red)
                            .frame(width: imageViewWidth, height: 80)
                            .animation(.easeInOut) { content in
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
        .safeAreaInset(edge: .bottom) {
            Button(action: {
                withAnimation {
                    orbitShow.toggle()
                    isAnimating.toggle()
                    if !badgeShow {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.36) {
                            badgeShow = true
                            animateButtonText()
                        }
                    } else {
                        badgeShow = false
                        animateButtonText()
                    }
                }
            }, label: {
                Text(buttonText)
                    .font(.largeTitle)
                    .foregroundStyle(.white, .green, .gray)
                    .opacity(textOpacity)
            })
            .padding()
            .background(
                Capsule()
                    .fill(.blue)
            )
        }
    }
    
    private func animateButtonText() {
        withAnimation(.easeInOut(duration: 0.2)) {
            textOpacity = 0
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            buttonText = badgeShow ? "Reset animation" : "Animate"
            withAnimation(.easeInOut(duration: 0.2)) {
                textOpacity = 1
            }
        }
    }
}

#Preview {
    KeyFrameAnimatorView()
}
