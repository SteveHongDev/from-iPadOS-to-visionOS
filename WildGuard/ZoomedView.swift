//
//  ZoomedView.swift
//  WildGuard
//
//  Created by 홍성범 on 2/14/24.
//

import SwiftUI
import RealityKit

struct ZoomedView: View {
    var imageName: String
    
    var body: some View {
        RealityView { content in
            guard let texture = try? await TextureResource(named: "Earth") else { return }
            
            let shape = MeshResource.generateSphere(radius: 0.25)
            var material = UnlitMaterial()
            material.color = .init(texture: .init(texture))
            let model = ModelEntity(mesh: shape, materials: [material])
            model.components.set(GroundingShadowComponent(castsShadow: true))
            
            content.add(model)
        }
    }
}

#Preview {
    ZoomedView(imageName: "Blue Whale")
}
