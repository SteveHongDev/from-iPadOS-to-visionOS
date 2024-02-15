//
//  ZoomedView.swift
//  WildGuard
//
//  Created by 홍성범 on 2/14/24.
//

import SwiftUI
import RealityKit
import AVKit

struct ZoomedView: View {
    
    @State private var spinX = 0.0
    @State private var spinY = 0.0
    
    var animal: Animal
    
    var body: some View {
        RealityView { content, attachments in
            guard let texture = try? await TextureResource(named: "Earth") else { return }
            
            let shape = MeshResource.generateSphere(radius: 0.25)
            var material = UnlitMaterial()
            material.color = .init(texture: .init(texture))
            let model = ModelEntity(mesh: shape, materials: [material])
            model.components.set(GroundingShadowComponent(castsShadow: true))
            model.components.set(InputTargetComponent())
            model.collision = CollisionComponent(shapes: [.generateSphere(radius: 0.25)])
            content.add(model)
            
            let pitch = Transform(pitch: Float(animal.mapRotationX * -1)).matrix
            let yaw = Transform(yaw: Float(animal.mapRotationY)).matrix
            model.transform.matrix = pitch * yaw
            
            if let attachment = attachments.entity(for: "name") {
                attachment.position = [0, -0.3, 0]
                content.add(attachment)
            }
            
        } update: { content, attachments in
            guard let entity = content.entities.first else { return }
            
            let pitch = Transform(pitch: Float((animal.mapRotationX + spinX) * -1)).matrix
            let yaw = Transform(yaw: Float(animal.mapRotationY + spinY)).matrix
            
            entity.transform.matrix = pitch * yaw
        } attachments: {
            Attachment(id: "name") {
                Text("Location of \(animal.englishName)")
                    .font(.extraLargeTitle)
            }
        }
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
            
            // Animation
//            TapGesture()
//                .targetedToAnyEntity()
//                .onEnded { value in
//                    // Read the tapped entity's current transform
//                    var transform = value.entity.transform
//                    
//                    // Change the transform somehow
//                    transform.translation += [0.1, 0, 0]
//                    
//                    // animate over 3 seconds
//                    value.entity.move(to: transform, relativeTo: value.entity, duration: 3, timingFunction: .easeInOut)
//                    
//                }
            
        )
    }
    
    // Play video
    func createVideoEntity() -> Entity {
        // Create a new entity to host our video
        let entity = Entity()

        // Find where our video is in the app bundle
        guard let url = Bundle.main.url(forResource: "romy", withExtension: "mp4") else {
            fatalError("Couldn't locate video in app bundle.")
        }

        // AVKit code to locate and load our movie
        let asset = AVURLAsset(url: url)
        let playerItem = AVPlayerItem(asset: asset)
        let player = AVPlayer(playerItem: playerItem)

        // Create a RealityKit component from our video player
        let component = VideoPlayerComponent(avPlayer: player)

        // Attach the video player to the entity we made
        entity.components[VideoPlayerComponent.self] = component

        // Trigger video playback now
        player.play()

        return entity
    }
}
