//
//  CameraView.swift
//  Creatopia
//
//  Created by shahad khaled on 23/08/1447 AH.
//
import SwiftUI
import UIKit

struct CameraView: UIViewControllerRepresentable {

    // SwiftUI dismiss function (to close camera)
    @Environment(\.dismiss) var dismiss

    // Callback to send the image back to SwiftUI
    var onImagePicked: (UIImage) -> Void

    // Create the camera controller
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = .camera
        picker.delegate = context.coordinator
        return picker
    }

    // Update camera (not needed here)
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}

    // Create coordinator (bridge for UIKit delegates)
    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }

    // Coordinator class to handle camera events
    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

        let parent: CameraView

        init(_ parent: CameraView) {
            self.parent = parent
        }

        // When photo is taken
        func imagePickerController(_ picker: UIImagePickerController,
                                   didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {

            if let image = info[.originalImage] as? UIImage {
                parent.onImagePicked(image)   // Send image back to SwiftUI
            }

            parent.dismiss() // Close camera
        }

        // When user cancels camera
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.dismiss()
        }
    }
}


