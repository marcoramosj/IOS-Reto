//
//  TurnoView.swift
//  Proyecto_Avance
//
//  Created by ediaz205  on 8/27/25.
//

import SwiftUI

struct VerTurnoView: View {
    
    // Variables
    
    var body: some View {
        NavigationStack {
            ZStack (alignment: .leading){
                TurnoView()
                NavigationLink("Volver"){
                    // Append here
                }
                .padding(.leading)
                .padding(.bottom, 705)
                
                // Create elements
            }
            
        }
        
    }
}

#Preview {
    VerTurnoView()
}

