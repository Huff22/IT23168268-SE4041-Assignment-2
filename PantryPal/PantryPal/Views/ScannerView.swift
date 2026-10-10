//
//  SwiftUIView.swift
//  PantryPal
//
//  Created by Hafsa Faleel on 2026-10-10.
//
import SwiftUI
import PhotosUI

struct ScannerView: View {
    @StateObject private var cameraService = CameraService()
    
    // State for the photo picker
    @State private var selectedItem: PhotosPickerItem? = nil
    
    var body: some View {
        ZStack {
            // Fullscreen Camera Feed (Will be black in Simulator)
            CameraPreview(session: cameraService.captureSession)
                .ignoresSafeArea()
            
            VStack {
                // Photo Picker Button for Simulator Testing
                HStack {
                    Spacer()
                    PhotosPicker(selection: $selectedItem, matching: .images, photoLibrary: .shared()) {
                        Image(systemName: "photo.fill.on.rectangle.fill")
                            .font(.title)
                            .padding()
                            .background(.ultraThinMaterial)
                            .clipShape(Circle())
                    }
                    .padding()
                    // Trigger the ML model when an image is selected
                    .onChange(of: selectedItem) { oldValue, newValue in
                        // Safely unwrap the new value first
                        guard let item = newValue else { return }
                        
                        Task {
                            // Now use 'item' directly without the question mark
                            if let data = try? await item.loadTransferable(type: Data.self),
                               let uiImage = UIImage(data: data) {
                                cameraService.processStaticImage(uiImage)
                            }
                        }
                    }
                }
                
                Spacer()
                
                // Bottom Sheet Container
                VStack(spacing: 16) {
                    Text("AI Pantry Scanner")
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    if cameraService.detectedIngredients.isEmpty {
                        ProgressView("Scanning for ingredients...")
                            .padding()
                    } else {
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack {
                                ForEach(cameraService.detectedIngredients, id: \.self) { ingredient in
                                    Text(ingredient.capitalized)
                                        .font(.subheadline.bold())
                                        .padding(.horizontal, 16)
                                        .padding(.vertical, 8)
                                        .background(.ultraThinMaterial)
                                        .cornerRadius(20)
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                    
                    Button(action: {
                        print("Search for recipes with: \(cameraService.detectedIngredients)")
                    }) {
                        Text("Find Recipes")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(cameraService.detectedIngredients.isEmpty ? Color.gray : Color.blue)
                            .cornerRadius(15)
                    }
                    .disabled(cameraService.detectedIngredients.isEmpty)
                }
                .padding()
                .background(Color(UIColor.systemBackground).shadow(radius: 10))
                .cornerRadius(25)
                .padding()
            }
        }
        .onAppear {
            cameraService.start()
        }
        .onDisappear {
            cameraService.stop()
        }
    }
}
