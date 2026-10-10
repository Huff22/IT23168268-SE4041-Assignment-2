//
//  CameraService.swift
//  PantryPal
//
//  Created by Hafsa Faleel on 2026-10-10.
//

import Foundation
import AVFoundation
import Vision
import CoreImage
import Combine

class CameraService: NSObject, ObservableObject, AVCaptureVideoDataOutputSampleBufferDelegate {
    @Published var detectedIngredients: [String] = []
    let captureSession = AVCaptureSession()
    
    override init() {
        super.init()
        setupCamera()
    }
    
    private func setupCamera() {
        // 1. Get the back camera
        guard let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back),
              let input = try? AVCaptureDeviceInput(device: device) else {
            print("Camera not accessible")
            return
        }
        
        // 2. Add input to session
        if captureSession.canAddInput(input) {
            captureSession.addInput(input)
        }
        
        // 3. Setup output to read frames
        let output = AVCaptureVideoDataOutput()
        output.setSampleBufferDelegate(self, queue: DispatchQueue(label: "videoQueue"))
        if captureSession.canAddOutput(output) {
            captureSession.addOutput(output)
        }
    }
    
    func start() {
        DispatchQueue.global(qos: .background).async {
            self.captureSession.startRunning()
        }
    }
    
    func stop() {
        self.captureSession.stopRunning()
    }
    
    // 4. Process each frame using the Vision framework
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }
        
        // Temporary placeholder: Apple's built-in classifier.
        // We will swap this to VNCoreMLRequest (YOLO) once the UI is built.
        let request = VNClassifyImageRequest { [weak self] request, error in
            guard let results = request.results as? [VNClassificationObservation] else { return }
            
            // Filter for high-confidence predictions
            let topResults = results.filter { $0.confidence > 0.8 }.map { $0.identifier }
            
            DispatchQueue.main.async {
                if !topResults.isEmpty {
                    self?.detectedIngredients = Array(topResults.prefix(3))
                }
            }
        }
        
        let handler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer, orientation: .up, options: [:])
        try? handler.perform([request])
    }
}
