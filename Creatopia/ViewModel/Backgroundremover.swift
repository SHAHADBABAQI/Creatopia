import Vision
import CoreImage
import UIKit

class BackgroundRemover {
    
    func removeBackground(from image: UIImage, completion: @escaping (UIImage?) -> Void) {
        guard let cgImage = image.cgImage else {
            completion(nil)
            return
        }
        
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
            
            let maskedImage = self.applyMask(result, to: cgImage, originalImage: image)
            completion(maskedImage)
        }
        
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
    
    private func applyMask(_ mask: VNInstanceMaskObservation, to cgImage: CGImage, originalImage: UIImage) -> UIImage? {
        let originalWidth = cgImage.width
        let originalHeight = cgImage.height
        
        // Generate the mask pixel buffer
        let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        guard let maskPixelBuffer = try? mask.generateMaskedImage(
            ofInstances: mask.allInstances,
            from: handler,
            croppedToInstancesExtent: false  // Keep full original size
        ) else {
            return nil
        }
        
        // Convert original image and mask to CIImage
        let ciOriginal = CIImage(cgImage: cgImage)
        var ciMask = CIImage(cvPixelBuffer: maskPixelBuffer)
        
        // Scale mask to match original image dimensions if needed
        let maskWidth = CGFloat(CVPixelBufferGetWidth(maskPixelBuffer))
        let maskHeight = CGFloat(CVPixelBufferGetHeight(maskPixelBuffer))
        let scaleX = CGFloat(originalWidth) / maskWidth
        let scaleY = CGFloat(originalHeight) / maskHeight
        
        if abs(scaleX - 1.0) > 0.01 || abs(scaleY - 1.0) > 0.01 {
            ciMask = ciMask.transformed(by: CGAffineTransform(scaleX: scaleX, y: scaleY))
        }
        
        // Blend: keeps foreground, removes background (transparent)
        guard let blendFilter = CIFilter(name: "CIBlendWithMask") else { return nil }
        blendFilter.setValue(ciOriginal, forKey: kCIInputImageKey)
        blendFilter.setValue(ciMask, forKey: kCIInputMaskImageKey)
        blendFilter.setValue(CIImage.empty(), forKey: kCIInputBackgroundImageKey)
        
        guard let outputCI = blendFilter.outputImage else { return nil }
        
        let context = CIContext(options: [.workingColorSpace: CGColorSpaceCreateDeviceRGB()])
        
        // Render at the original image's full extent/size
        let renderRect = CGRect(x: 0, y: 0, width: originalWidth, height: originalHeight)
        guard let cgOutput = context.createCGImage(outputCI, from: renderRect) else {
            return nil
        }
        
        // Draw onto a properly sized RGBA canvas to preserve alpha
        UIGraphicsBeginImageContextWithOptions(
            CGSize(width: originalWidth, height: originalHeight),
            false,  // false = transparent background
            originalImage.scale
        )
        defer { UIGraphicsEndImageContext() }
        
        guard let ctx = UIGraphicsGetCurrentContext() else { return nil }
        
        // Flip coordinate system (CoreGraphics vs UIKit differ)
        ctx.translateBy(x: 0, y: CGFloat(originalHeight))
        ctx.scaleBy(x: 1.0, y: -1.0)
        
        ctx.draw(cgOutput, in: renderRect)
        
        return UIGraphicsGetImageFromCurrentImageContext()
    }
}
