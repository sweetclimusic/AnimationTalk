//
//  AnimationTalkApp.swift
//  AnimationTalk
//
//  Created by Ashlee Muscroft on 18/09/2024.
//

import SwiftUI

@main
struct AnimationTalkApp: App {
    @State private var path = NavigationPath()
    enum Scenes: Int, CaseIterable {
        case implicit = 1
        case phased = 2
        case keyframe = 3
        @ViewBuilder var childView: some View {
            switch self {
            case .implicit:
               ImplicitAnimation()
            case .phased:
              PhaseAnimatorView()
            case .keyframe:
              KeyFrameAnimatorView()
            }
        }
    }
    var body: some Scene {
        WindowGroup {
            NavigationStack(path: $path,
                            root: {
                VStack(spacing: 20) {
                    Button(action: {
                        path.append(Scenes.implicit)
                    },
                           label: {
                        Text("Implicit Animation")
                    })
                    Button(action: {
                        path.append(Scenes.phased)
                    },
                           label: {
                        Text("Phase Animation")
                    })
                    Button(action: {
                        path.append(Scenes.keyframe)
                    },
                           label: {
                        Text("KeyFrame Animation")
                    })
                }
                .navigationDestination(for: Scenes.self) { selection in
                    selection.childView
                }
            })
            .navigationTitle(Text(" A SwiftUI navigation talk"))
            .navigationBarBackButtonHidden(true)
            
        }
    }
}
