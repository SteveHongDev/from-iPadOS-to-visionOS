//
//  ZoomedView.swift
//  WildGuard
//
//  Created by 홍성범 on 2/14/24.
//

import SwiftUI
import RealityKit

struct ZoomedView: View {
    
    @State private var spinX = 0.0
    @State private var spinY = 0.0
    
    var animal: Animal
    
    var body: some View {
        RealityView { content in
            guard let texture = try? await TextureResource(named: animal.englishName) else { return }
            
            let shape = MeshResource.generateSphere(radius: 0.25)
            var material = UnlitMaterial()
            material.color = .init(texture: .init(texture))
            let model = ModelEntity(mesh: shape, materials: [material])
            model.components.set(GroundingShadowComponent(castsShadow: true))
            model.components.set(InputTargetComponent())
//            model.generateCollisionShapes(recursive: false, static: true)
            
            model.collision = CollisionComponent(shapes: [.generateSphere(radius: 0.25)])
            
            content.add(model)
        }
        .onAppear {
            spinX = animal.mapRotationX
            spinY = animal.mapRotationY
        }
        .rotation3DEffect(.radians(spinX), axis: .x)
        .rotation3DEffect(.radians(spinY), axis: .y)
        .gesture(
            // Tapping
//            TapGesture()
//                .targetedToAnyEntity()
//                .onEnded { value in
//                    guard let modelEntity = value.entity as? ModelEntity else { return }
//                    let newMaterial = UnlitMaterial(color: .blue)
//                    
//                    modelEntity.model?.materials = [newMaterial]
//                }
            
            // Dragging
//            DragGesture(minimumDistance: 0)
//                .targetedToAnyEntity()
//                .onChanged { value in
//                    guard let parent = value.entity.parent else { return }
//                    let newPosition = value.convert(value.location3D, from: .local, to: parent)
//                    value.entity.position = [newPosition.x, newPosition.y, value.entity.position.z]
//                }
            
            // Rotating
            DragGesture(minimumDistance: 0)
                .targetedToAnyEntity()
                .onChanged { value in
                    let startLocation = value.convert(value.startLocation3D, from: .local, to: .scene)
                    let currentLocation = value.convert(value.location3D, from: .local, to: .scene)
                    let delta = currentLocation - startLocation
                    
                    spinY = Double(delta.x) * 5
                    spinX = Double(delta.y) * 5
                }
        )
    }
}
