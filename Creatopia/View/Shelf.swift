import SwiftUI

struct Shelf: View {

    let viewModel: BoxViewModel

    var body: some View {
        ZStack(alignment: .bottomTrailing) {

            // Shadow (tilted right)
            Rectangle()
                .fill(viewModel.shadowColor)
                .frame(
                    width: viewModel.shadowWidth,
                    height: viewModel.shadowHeight
                )
                .rotationEffect(.degrees(4))
                .offset(
                    x: viewModel.shadowOffsetX,
                    y: viewModel.shadowOffsetY
                )

            // Shelf
            Rectangle()
                .fill(viewModel.shelfColor)
                .frame(
                    width: viewModel.shelfWidth,
                    height: viewModel.shelfHeight
                )
        }
    }
}

#Preview {
    Shelf(viewModel: BoxViewModel())
}
