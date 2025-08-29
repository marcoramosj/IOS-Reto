//
//  InterfazVent.swift
//  App_RETO
//
//  Created by Mauricio on 28/08/25.
//

import SwiftUI

struct InterfazVent: View {
   @State var basedeDatos=[
        ["RecetaID8798", "Paracetamol 500mg \n Ibuprofeno 400mg", "Juan Pérez", "No entregado"],
            ["RecetaID8799", "Amoxicilina 500mg \n Ácido Clavulánico 125mg", "María López", "No entregado"],
            ["RecetaID8800", "Omeprazol 20mg \n Metoclopramida 10mg", "Carlos Ramírez", "No entregado"],
            ["RecetaID8801", "Loratadina 10mg \n Salbutamol Inhalador", "Ana Torres", "No entregado"],
            ["RecetaID8802", "Metformina 850mg \n Glibenclamida 5mg", "José Hernández", "No entregado"],
            ["RecetaID8803", "Losartán 50mg \n Hidroclorotiazida 12.5mg", "Laura Martínez", "No entregado"],
            ["RecetaID8804", "Vitamina D 2000UI \n Calcio Carbonato 600mg", "Miguel Sánchez", "No entregado"],
            ["RecetaID8805", "Diclofenaco 50mg \n Naproxeno 500mg", "Paola Castillo", "No entregado"],
            ["RecetaID8806", "Azitromicina 500mg \n Ibuprofeno 400mg", "Andrés García", "No entregado"],
            ["RecetaID8807", "Paracetamol 500mg \n Suero Oral 1L", "Sofía Gómez", "No entregado"]
    ]
    
    @State var tags=0
    @State var mostrarinter = true
    @Environment(\.dismiss) var dismiss
    var body: some View {
        VStack(alignment:.leading){
            Spacer()
            Text("Receta ID:")
                .fontWeight(.bold)
                .foregroundStyle(.white)
                .font(.title)
            + Text(" \(basedeDatos[tags][0])")
                .fontWeight(.bold)
                .foregroundStyle(.orange)
                .font(.title)
            Text("\n Medicamentos: \n")
                .fontWeight(.bold)
                .foregroundStyle(.white)
                .font(.title)
            + Text("\n \(basedeDatos[tags][1]) \n")
                .fontWeight(.bold)
                .foregroundStyle(.orange)
                .font(.title2)
            Text("Receta ID:")
                .fontWeight(.bold)
                .foregroundStyle(.white)
                .font(.title) +
            Text( " \(basedeDatos[tags][2]) \n")
                .fontWeight(.bold)
                .foregroundStyle(.orange)
                .font(.title)
            Button("Saltar",action:{
                print("\(basedeDatos[tags][0]) esta \(basedeDatos[tags][3]) ")
                tags+=1
            }).buttonStyle(.borderedProminent)
            .frame(maxWidth: .infinity, alignment: .center)
            .tint (Color(red: 1/255, green:104/255, blue: 138/255))
            .scaleEffect(1.5)
            Spacer()
            HStack{
                Button("Salir", action:{
                    dismiss()
                }).buttonStyle(.borderedProminent)
                    .tint (Color(red: 1/255, green:104/255, blue: 138/255))
                    .padding(20)
                    .scaleEffect(1.5)
                Spacer()
                Button("Siguiente",action:{
                    basedeDatos[tags][3] = "Entregado"
                    print("\(basedeDatos[tags][0]) esta \(basedeDatos[tags][3]) ")
                    tags+=1
                    
                })
                .buttonStyle(.borderedProminent)
                    .tint (Color(red: 1/255, green:104/255, blue: 138/255))
                    .scaleEffect(1.5)
               
            }
    
        }.padding(30)
        .background(Color.gray)
        .navigationBarBackButtonHidden(true)
    }
}


#Preview {
    InterfazVent()
}
