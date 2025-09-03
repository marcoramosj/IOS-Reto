//
//  DashboardAdminView.swift
//  App_RETO
//
//  Created by Marco Ramos Jalife on 27/08/25.
//
import SwiftUI

struct DashboardAdminView: View {
    var body: some View {
        ZStack {
            Color(.systemGray6).ignoresSafeArea()
            VStack(spacing: 16) {
                Encabezado(saludo: "Hola,\nAdmin Marquitos", icono: "person.crop.circle.fill")
                TarjetaProximaCita()
                VStack(spacing: 12) {
                    OpcionRapida(titulo: "Próximas citas", subtitulo: "2", icono: "leaf.fill", color: Color.green)
                    OpcionRapida(titulo: "Medicamentos totales", subtitulo: "8", icono: "pills.fill", color: Color.purple, mostrarFlecha: true)
                }
                Spacer()
            }
            .padding(.horizontal, 20)
            .padding(.top, 8)
            .padding(.bottom, 10)
        }
    }
}

struct Encabezado: View {
    var saludo: String
    var icono: String
    var body: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading, spacing: 8) {
                Text("Panel")
                    .font(.footnote)
                    .foregroundColor(.secondary)
                Text(saludo)
                    .font(.title2.weight(.bold))
                    .lineSpacing(2)
                HStack(spacing: 8) {
                    Etiqueta(texto: "Resumen")
                    Etiqueta(texto: "Sugerencias")
                }
            }
            Spacer()
            ZStack {
                Circle().fill(Color(.systemGray5)).frame(width: 36, height: 36)
                Image(systemName: icono)
                    .font(.system(size: 18))
                    .foregroundColor(.accentColor)
            }
        }
    }
}

struct Etiqueta: View {
    var texto: String
    var body: some View {
        Text(texto)
            .font(.caption2.weight(.semibold))
            .padding(.vertical, 6)
            .padding(.horizontal, 10)
            .background(Color(.systemGray5))
            .clipShape(Capsule())
    }
}

struct TarjetaProximaCita: View {
    var body: some View {
        ZStack(alignment: .topTrailing) {
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .fill(LinearGradient(colors: [Color(.systemGray6), Color(.systemGray5)], startPoint: .topLeading, endPoint: .bottomTrailing))
                .overlay(
                    RoundedRectangle(cornerRadius: 18).stroke(Color(.systemGray4), lineWidth: 1)
                )
                .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 4)
            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    HStack(spacing: 8) {
                        Circle().fill(Color.orange.opacity(0.2)).frame(width: 26, height: 26)
                            .overlay(Image(systemName: "bell.fill").font(.system(size: 12)).foregroundColor(.orange))
                        Text("Próxima cita")
                            .font(.subheadline.weight(.semibold))
                    }
                    Spacer()
                    Button { } label: {
                        Image(systemName: "xmark.circle.fill").foregroundColor(.secondary)
                    }
                }
                Text("Cita a las 12:00")
                    .font(.caption)
                    .foregroundColor(.secondary)
                HStack {
                    Spacer()
                    Button {
                    } label: {
                        Text("Cancelar turno")
                            .font(.footnote.weight(.semibold))
                            .padding(.vertical, 10)
                            .padding(.horizontal, 14)
                            .background(Color(.systemBlue))
                            .foregroundColor(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                    }
                }
            }
            .padding(16)
        }
        .frame(height: 110)
    }
}

struct OpcionRapida: View {
    var titulo: String
    var subtitulo: String
    var icono: String
    var color: Color
    var mostrarFlecha: Bool = false
    var body: some View {
        HStack(spacing: 14) {
            ZStack {
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .fill(color.opacity(0.2))
                    .frame(width: 46, height: 46)
                Image(systemName: icono)
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(color)
            }
            VStack(alignment: .leading, spacing: 2) {
                Text(titulo).font(.subheadline.weight(.semibold))
                if !subtitulo.isEmpty {
                    Text(subtitulo).font(.caption).foregroundColor(.secondary)
                }
            }
            Spacer()
            if mostrarFlecha {
                Image(systemName: "chevron.right").font(.footnote).foregroundColor(.secondary)
            }
        }
        .padding(14)
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .fill(Color.white)
                .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 4)
        )
    }
}

struct BarraInferior: View {
    var body: some View {
        TabView {
            NavigationStack { DashboardAdminView() }
                .tabItem {
                    Image(systemName: "square.grid.2x2.fill")
                    Text("Inicio")
                }

            NavigationStack { AgendarTurnoView() }
                .tabItem {
                    Image(systemName: "calendar.badge.plus")
                    Text("Agendar")
                }

            NavigationStack { VerTurnoView(usuario:.constant("") , loggedIn: .constant(false)) }
                .tabItem {
                    Image(systemName: "list.bullet.rectangle")
                    Text("Turnos")
                }

            NavigationStack { AdminView() }
                .tabItem {
                    Image(systemName: "gearshape")
                    Text("Admin")
                }
        }
    }
}

#Preview { BarraInferior() }
