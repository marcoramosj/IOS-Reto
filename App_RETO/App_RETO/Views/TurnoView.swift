//
//  TurnoView.swift
//  Proyecto_Avance
//
//  Created by ediaz205  on 8/27/25.
//

import SwiftUI

struct TurnoView: View {
    
    // Variables
    @State public var title: String = ""
    @State public var subtitle: String = ""
    
    var body: some View {
        VStack{
            ZStack {
                Text(title)
                    .font(.title2)
                    .fontWeight(.semibold)

                HStack {
                    Spacer()
                    ProfileImage()
                        .frame(width: 65)
                        .padding(.trailing)
                }
            }
            .frame(maxWidth: .infinity, alignment: .trailing)
            .ignoresSafeArea(edges: .top)
            .padding(.top, 5)
           
            ZStack {
                RoundedRectangle(cornerRadius: 20)
                    .fill(.ultraThickMaterial)   // blur effect
                    .frame(height: 730)
                    .ignoresSafeArea()
                
                VStack {
                    ProfileImage()
                        .frame(width: 120.0)
                        .padding(.bottom, 10)
                    Text(subtitle)
                        .font(.title3)
                        .fontWeight(.semibold)
                        .multilineTextAlignment(.center)
                }
                    .padding(.bottom, 500)
                    
                                    
            }
        }
        .ignoresSafeArea(edges: .bottom)
    }
}

#Preview {
    TurnoView()
}

