//
//  ContentView.swift
//  AnimationTalk
//
//  Created by Ashlee Muscroft on 18/09/2024.
//

import SwiftUI

struct ValuesToAnimation {
    //Animation properties for the dot
    var dotOffset: CGSize = .zero
    var dotScale = CGFloat(1.5)
    var opacity = CGFloat(1.0)
    var zIndex: Double = 2
}

struct PhaseAnimatorView: View {
    @ScaledMetric private var imageViewWidth = CGFloat(100)
    @State private var badgeShow = false
    @Namespace private var envelope
    
    @State private var isAnimating: Bool = false
    @State private var buttonText = "Animate"
    @State private var textOpacity: Double = 1
    
    // track offset and reset orbit
    enum AnimationPhase: CaseIterable {
        case initial
        case move
        case complete
        
        var offset: CGSize {
            switch self {
            case .initial:
                CGSize(width: 30, height: 0)
            case .move:
                CGSize(width: 60, height: -37)
            case .complete:
                CGSize(width: 38, height: -25)
            }
        }
        
        var zIndex: Double {
            switch self {
            case .initial:
                2.0
            case .move, .complete:
                1
            }
        }
        
        var opacity: Double {
            switch self {
            case .complete:
                0.0
            case .initial:
                0.3
            case .move:
                1.0
            }
        }
        
        var scale: CGFloat {
            switch self {
            case .initial:
                0
            case .move, .complete:
                1.5
            }
        }
    }
    
    var body: some View {
        VStack(spacing: .zero) {
            VStack(alignment: .leading) {
                ZStack {
                    if !badgeShow {
                        // Dot with PhaseAnimatoor
                        PhaseAnimator(AnimationPhase.allCases, trigger: isAnimating) { phase in
                            Circle()
                                .fill(Color.red)
                                .frame(width: 20, height: 20)
                            
                                .offset(phase.offset)
                                .zIndex(phase.zIndex)
                                .scaleEffect(phase.scale, anchor: .top)
                                .opacity(phase.opacity)
                            
                            
                        }
                        animation: { phase in
                            switch phase {
                            case .initial:
                                return .easeOut(duration: 0.1)
                            case .move:
                                return .bouncy(duration: 0.18, extraBounce: 0.1)
                            case .complete:
                                return .easeIn(duration: 0.08)
                                
                            }
                        }
                    }
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
        .safeAreaInset(edge: .bottom, content: { Button(action: {
            withAnimation() {
                isAnimating.toggle()
            }
            if !badgeShow {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.349, execute: {
                    badgeShow = true
                    animateButton()
                })
            } else {
                badgeShow = false
                animateButton()
            }
            
        }, label: {
            withAnimation(.easeInOut(duration: 40)) {
                Text(buttonText )
                    .font(.largeTitle)
                    .foregroundStyle(.white,.green, .gray)
                    .opacity(textOpacity)
            }
        }
        )
        .padding()
        .background(
            Capsule()
                .fill(.blue)
        ).opacity(textOpacity)})
    }
    private func animateButton() {
        withAnimation(.easeInOut) {
            textOpacity = 0
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.9) {
            buttonText = isAnimating ? "Reset animation" : "Animate"
            withAnimation(.easeInOut(duration: 0.2)) {
                textOpacity = 1
            }
        }
    }
}

#Preview {
    PhaseAnimatorView()
}
