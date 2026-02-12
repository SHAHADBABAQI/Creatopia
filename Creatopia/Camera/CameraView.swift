



import SwiftUI
import UIKit

struct CameraView: UIViewControllerRepresentable {

    @Environment(\.dismiss) var dismiss
    var onImagePicked: (UIImage) -> Void
    var onProcessedImage: (UIImage) -> Void  // ✅ Callback for processed image

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = .camera
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }

    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

        let parent: CameraView
        let backgroundRemover = BackgroundRemover()

        init(_ parent: CameraView) {
            self.parent = parent
        }

        func imagePickerController(_ picker: UIImagePickerController,
                                   didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {

            if let image = info[.originalImage] as? UIImage {
                parent.onImagePicked(image)  // Send original for preview if needed
                
                // ✅ Remove background
                backgroundRemover.removeBackground(from: image) { processedImage in
                    DispatchQueue.main.async {
                        if let processedImage = processedImage {
                            self.parent.onProcessedImage(processedImage)
                        } else {
                            // Fallback to original if processing fails
                            self.parent.onProcessedImage(image)
                        }
                    }
                }
            }

            parent.dismiss()
        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.dismiss()
        }
    }
}
