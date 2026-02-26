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

            let maskedImage = self.applyMask(result, to: cgImage, scale: image.scale)
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

    private func applyMask(_ mask: VNInstanceMaskObservation,
                            to cgImage: CGImage,
                            scale: CGFloat) -> UIImage? {

        let width  = cgImage.width
        let height = cgImage.height

        // ── 1. Generate the mask at the SAME handler so Vision knows the source size ──
        let sourceHandler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        guard let maskBuffer = try? mask.generateMaskedImage(
            ofInstances: mask.allInstances,
            from: sourceHandler,
            croppedToInstancesExtent: false
        ) else {
            print("❌ Failed to generate mask buffer")
            return nil
        }

        let bufferWidth  = CVPixelBufferGetWidth(maskBuffer)
        let bufferHeight = CVPixelBufferGetHeight(maskBuffer)
        print("🖼 Original: \(width)×\(height) | Mask buffer: \(bufferWidth)×\(bufferHeight)")

        // ── 2. Convert mask buffer → CGImage, then scale it to original size ──
        let maskCI     = CIImage(cvPixelBuffer: maskBuffer)
        let ciContext  = CIContext()

        guard let maskCG = ciContext.createCGImage(maskCI, from: maskCI.extent) else {
            print("❌ Could not create CGImage from mask")
            return nil
        }

        // Draw the mask scaled to exact original pixel dimensions
        guard let scaledMaskCG = scaleCGImage(maskCG, to: CGSize(width: width, height: height)) else {
            print("❌ Could not scale mask")
            return nil
        }

        // ── 3. Manually composite: original image with mask as alpha ──
        guard let result = compositeWithMask(source: cgImage,
                                             mask: scaledMaskCG,
                                             size: CGSize(width: width, height: height),
                                             scale: scale) else {
            return nil
        }

        return result
    }

    // Scales any CGImage to a target size using a CGContext
    private func scaleCGImage(_ image: CGImage, to size: CGSize) -> CGImage? {
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        guard let ctx = CGContext(
            data: nil,
            width: Int(size.width),
            height: Int(size.height),
            bitsPerComponent: 8,
            bytesPerRow: 0,
            space: colorSpace,
            bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue
        ) else { return nil }

        ctx.interpolationQuality = .high
        ctx.draw(image, in: CGRect(origin: .zero, size: size))
        return ctx.makeImage()
    }

    // Draws source image using the mask as an alpha channel
    private func compositeWithMask(source: CGImage,
                                   mask: CGImage,
                                   size: CGSize,
                                   scale: CGFloat) -> UIImage? {
        let rect = CGRect(origin: .zero, size: size)

        // Render final image with transparency support
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        defer { UIGraphicsEndImageContext() }

        guard let ctx = UIGraphicsGetCurrentContext() else { return nil }

        // Clip drawing region to the mask shape
        ctx.translateBy(x: 0, y: size.height)
        ctx.scaleBy(x: 1, y: -1)                       // flip for UIKit→CG coords

        ctx.clip(to: rect, mask: mask)                  // ← apply mask as alpha clip
        ctx.draw(source, in: rect)                      // ← draw original inside clip

        return UIGraphicsGetImageFromCurrentImageContext()
    }
}
