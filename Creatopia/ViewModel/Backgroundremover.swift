//
//  Backgroundremover.swift
//  Creatopia
//
//  Created by shahad khaled on 24/08/1447 AH.
//

import Vision
import CoreImage
import UIKit

class BackgroundRemover {
    
    func removeBackground(from image: UIImage, completion: @escaping (UIImage?) -> Void) {
        guard let cgImage = image.cgImage else {
            completion(nil)
            return
        }
        
        // Create the Vision request
        let request = VNGenerateForegroundInstanceMaskRequest { request, error in
            if let error = error {
                print("Vision Error: \(error.localizedDescription)")
                completion(nil)
                return
            }
            
            guard let result = request.results?.first as? VNInstanceMaskObservation else {
                print("No mask generated")
                completion(nil)
                return
            }
            
            // Process the mask to remove background
            let maskedImage = self.applyMask(result, to: cgImage)
            completion(maskedImage)
        }
        
        // Execute the request
        let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        DispatchQueue.global(qos: .userInitiated).async {
            do {
                try handler.perform([request])
            } catch {
                print("Failed to perform request: \(error)")
                completion(nil)
            }
        }
    }
    
    private func applyMask(_ mask: VNInstanceMaskObservation, to image: CGImage) -> UIImage? {
        // Convert mask to CIImage
        guard let maskImage = try? mask.generateMaskedImage(
            ofInstances: mask.allInstances,
            from: VNImageRequestHandler(cgImage: image),
            croppedToInstancesExtent: false
        ) else {
            return nil
        }
        
        let ciImage = CIImage(cgImage: image)
        let ciMask = CIImage(cvPixelBuffer: maskImage)
        
        // Apply the mask using Core Image
        let filter = CIFilter(name: "CIBlendWithMask")
        filter?.setValue(ciImage, forKey: kCIInputImageKey)
        filter?.setValue(ciMask, forKey: kCIInputMaskImageKey)
        filter?.setValue(CIImage.empty(), forKey: kCIInputBackgroundImageKey)
        
        guard let output = filter?.outputImage else { return nil }
        
        let context = CIContext()
        guard let cgOutput = context.createCGImage(output, from: output.extent) else {
            return nil
        }
        
        return UIImage(cgImage: cgOutput)
    }
}
