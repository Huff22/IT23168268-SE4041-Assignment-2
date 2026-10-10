//
//  ContentView.swift
//  PantryPal
//
//  Created by Hafsa Faleel on 2026-10-10.
//
import SwiftUI
import SwiftData

struct ContentView: View {
    var body: some View {
        NavigationStack {
            VStack(spacing: 30) {
                Image(systemName: "basket.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                    .foregroundColor(.blue)
                
                Text("Welcome to PantryPal")
                    .font(.largeTitle)
                    .bold()
                
                NavigationLink(destination: ScannerView()) {
                    Text("Open AI Scanner")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(15)
                }
                .padding(.horizontal, 40)
            }
            .navigationTitle("Home")
        }
    }
}

#Preview {
    ContentView()
}
