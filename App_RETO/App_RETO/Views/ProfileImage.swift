//
//  ProfileImage.swift
//  Proyecto_Avance
//
//  Created by ediaz205  on 8/27/25.
//

import SwiftUI

struct ProfileImage: View {
    var size: CGFloat = 120

    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "person.crop.circle.fill")
                .resizable()
                .scaledToFit()
                .frame(width: size, height: size)
            Text("Usuario")
                .font(.title2)
                .bold()
        }
        .padding()
    }
}


