//
//  ProfileImage.swift
//  Proyecto_Avance
//
//  Created by ediaz205  on 8/27/25.
//

import SwiftUI

struct ProfileImage: View {
    var body: some View {
        Image(systemName: "person.circle.fill")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .foregroundColor(Color(UIColor(red: 33/255, green: 33/255, blue: 33/255, alpha: 1)))
            .background(.orange)
            .clipShape(Circle())
            .overlay(Circle().stroke(.orange, lineWidth: 5))
    }
}

#Preview { ProfileImage() }

