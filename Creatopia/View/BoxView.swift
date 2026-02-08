import SwiftUI

struct BoxView: View {

    @StateObject private var viewModel = BoxViewModel()

    var body: some View {
        ZStack {

            // Background
            viewModel.backgroundColor
                .ignoresSafeArea()

            // Light blue stripes
            ForEach(viewModel.stripeXPositions, id: \.self) { x in
                Rectangle()
                    .fill(viewModel.stripeColor)
                    .frame(
                        width: viewModel.stripeWidth,
                        height: viewModel.stripeHeight
                    )
                    .position(
                        x: x + viewModel.stripeWidth / 2,
                        y: viewModel.stripeHeight / 2
                    )
            }

            // Shelves grid
            VStack(spacing: viewModel.verticalSpacing) {
                ForEach(0..<viewModel.rows, id: \.self) { _ in
                    HStack(spacing: viewModel.horizontalSpacing) {
                        Shelf(viewModel: viewModel)
                        Shelf(viewModel: viewModel)
                    }
                }
            }
        }
    }
}
#Preview {
    BoxView()
}
