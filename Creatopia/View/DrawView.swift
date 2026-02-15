////    //
////    //  DrawView.swift
////    //  Creatopia
////    //
////    //  Created by shahad khaled on 22/08/1447 AH.
////    //
////    //
////    //  drawView.swift
////    //  Creatopia
////    //
////    //  Created by shahad khaled on 20/08/1447 AH.
////    //
////
////    //
////    //  ContentView.swift
////    //  Creatopia
////    //
////    //  Created by shahad khaled on 16/08/1447 AH.
////    //
////
////    import SwiftUI
////    import Combine
////
////    struct drawView: View {
////        @State private var animate: Bool = false
////        @State private var showCamera = false
////        @State private var capturedImage: UIImage?
////
////        static let duration = 900
////        
////        @State private var timeRemaining = DIYtimer.duration
////        @State private var showConfetti = false
////        @State private var timerFinished = false
////        @State private var isRunning = true
////        @State private var timeConsumed: Int = 0 // in seconds
////
////        let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
////
////        private var finishedMessage: String {
////            if timeConsumed < 60 {
////                // Show seconds if less than a minute
////                let seconds = max(0, timeConsumed)
////                return "you finished crafting in \(seconds) second\(seconds == 1 ? "" : "s"), yay!"
////            } else {
////                // Show whole minutes (floor)
////                let minutes = max(1, timeConsumed / 60)
////                return "you finished crafting in \(minutes) minute\(minutes == 1 ? "" : "s"), yay!"
////            }
////        }
////
////        var body: some View {
////            NavigationStack{
////            ZStack {
////                Image("background2")
////                    .resizable()
////                    .frame(width: 1370, height: 1037)
////                ZStack {
////                    
////                    VStack(spacing: 60) {
////                        // Title switches when the timer finishes
////                        Text(timerFinished ? "WELL DONE!" : "GO GO GO!")
////                            .font(.system(size: 90, weight: .bold))
////                            .foregroundColor(.white)
////                            .scaleEffect(animate ? 1.3 : 1.0)
////                            .onAppear {
////                                withAnimation(.easeInOut(duration: 1.0).repeatForever(autoreverses: true)) {
////                                    animate.toggle()
////                                }
////                            }
////                        
////                        // Subtitle while running vs finished
////                        if !timerFinished {
////                            Text("Let’s make something amazing in the next \(DIYtimer.duration / 60) minutes")
////                                .font(.system(size: 36, weight: .medium))
////                                .foregroundColor(.white.opacity(0.95))
////                                .transition(.opacity)
////                        } else {
////                            Text(finishedMessage)
////                                .font(.system(size: 36, weight: .medium))
////                                .foregroundColor(.white.opacity(0.95))
////                                .transition(.opacity)
////                        }
////                        
////                        // Show countdown only while not finished
////                        if !timerFinished {
////                            Text(timeString(from: timeRemaining))
////                                .font(.system(size: 60, weight: .semibold))
////                                .foregroundColor(.white)
////                        }
////                        
////                        // Controls visible during countdown
////                        if !timerFinished {
////                            VStack(spacing: 90) {
////                                // Top row: Restart + Pause/Play
////                                HStack(spacing: 250) {
////                                    // Pause/Play Button
////                                    if timeRemaining > 0 {
////                                        Button(action: {
////                                            isRunning.toggle()
////                                        }) {
////                                            ZStack {
////                                                Circle()
////                                                    .fill(Color.ButtonYellow)
////                                                    .frame(width: 100, height: 100)
////                                                Image(systemName: isRunning ? "pause.fill" : "play.fill")
////                                                    .resizable()
////                                                    .bold()
////                                                    .scaledToFit()
////                                                    .frame(width: 50, height: 50)
////                                                    .foregroundColor(.black)
////                                            }
////                                            .opacity(0.8)
////                                        }
////                                    }
////                                    // "I finished" Button
////                                    Button(action: {
////                                        // Immediately transition to finished state
////                                        isRunning = false
////                                        timeConsumed = DIYtimer.duration - timeRemaining
////                                        timerFinished = true
////                                        showConfetti = true
////                                    }) {
////                                        ZStack {
////                                            Circle()
////                                                .fill(Color.ButtonYellow)
////                                                .frame(width: 100, height: 100)
////                                            Image(systemName: "checkmark")
////                                                .resizable()
////                                                .bold()
////                                                .scaledToFit()
////                                                .frame(width: 50, height: 50)
////                                                .foregroundColor(.black)
////                                        }
////                                    }
////                                    
////                                    Button(action: {
////                                        timeRemaining = DIYtimer.duration
////                                        timerFinished = false
////                                        showConfetti = false
////                                        isRunning = true
////                                        timeConsumed = 0
////                                    }) {
////                                        ZStack {
////                                            Circle()
////                                                .fill(Color.ButtonYellow)
////                                                .frame(width: 100, height: 100)
////                                            Image(systemName: "arrow.clockwise")
////                                                .resizable()
////                                                .bold()
////                                                .scaledToFit()
////                                                .frame(width: 50, height: 50)
////                                                .foregroundColor(.black)
////                                        }
////                                        .opacity(0.8)
////                                        
////                                    }
////                                }
////                                
////                            }
////                            .padding(.top, 20)
////                            .padding(.bottom, -40)
////                        }
////                    }
////                    .onReceive(timer) { _ in
////                        guard isRunning else { return }
////                        if timeRemaining > 0 {
////                            timeRemaining -= 1
////                            if timeRemaining == 0 {
////                                timerFinished = true
////                                showConfetti = true
////                                timeConsumed = DIYtimer.duration // consumed entire duration
////                            }
////                        }
////                    }
////                    
////                    if timerFinished {
////                        ZStack {
////                            // Your main content here
////                            
////                            if timerFinished {
////                                VStack {
////                                    Spacer()
////                                    
////                                    HStack {
////                                        // LEFT BUTTON
////                                        NavigationLink(destination: HomeView()) {
////                                            ZStack {
////                                                Circle()
////                                                    .fill(Color.ButtonYellow)
////                                                    .frame(width: 100, height: 100)
////                                                Image(systemName: "house.fill")
////                                                    .resizable()
////                                                    .frame(width: 80, height: 70)
////                                                    .foregroundColor(.black)
////                                            }
////                                        }
////                                        
////                                        Spacer()
////                                        
////                                        // RIGHT BUTTON
////                                        Button(action: {showCamera = true}) {
////                                            
////                                            ZStack {
////                                                Circle()
////                                                    .fill(Color.ButtonYellow)
////                                                    .frame(width: 100, height: 100)
////                                                Image(systemName: "camera.fill")
////                                                    .resizable()
////                                                    .frame(width: 60, height: 60)
////                                                    .foregroundColor(.black)
////                                            }
////                                        }
////                                        .sheet(isPresented: $showCamera) {
////                                            CameraView(
////                                                onImagePicked: { _ in
////                                                    // You can store/show original image if needed
////                                                },
////                                                onProcessedImage: { image in
////                                                    capturedImage = image   // store processed image here
////                                                    // Later: save to SwiftData if desired
////                                                }
////                                            )
////                                        }
////                                    }
////                                    .padding(.horizontal, 24)
////                                    .padding(.bottom, 20) // 👈 CONTROL THIS VALUE
////                                }
////                            }
////                        }
////                        .frame(width: 760, height: 510)
////                        
////                    }
////                    
////                    
////                    
////                    
////                    if showConfetti {
////                        ConfettiView()
////                    }
////                }
////            }
////            }
////            .navigationBarBackButtonHidden(true)
////
////        }
////
////        // Formats seconds as HH:MM:SS
////        private func timeString(from totalSeconds: Int) -> String {
////            let hour = totalSeconds / 3600
////            let minutes = (totalSeconds % 3600) / 60
////            let seconds = totalSeconds % 60
////            return String(format: "%02d:%02d:%02d", hour, minutes, seconds)
////        }
////
////        struct ConfettiView: View {
////            let colors: [Color] = [.red, .purple, .yellow, .green, .orange, .pink, .white, .mint]
////
////            var body: some View {
////                GeometryReader { geo in
////                    ForEach(0..<500, id: \.self) { _ in
////                        ConfettiPiece(
////                            color: colors.randomElement()!,
////                            x: CGFloat.random(in: 0...geo.size.width),
////                            delay: Double.random(in: 0...3),
////                            availableHeight: geo.size.height
////                        )
////                    }
////                }
////                .ignoresSafeArea()
////            }
////        }
////
////        struct ConfettiPiece: View {
////            let color: Color
////            let x: CGFloat
////            let delay: Double
////            let availableHeight: CGFloat
////
////            @State private var y: CGFloat = -20
////            @State private var rotation: Double = 0
////
////            var body: some View {
////                Rectangle()
////                    .fill(color)
////                    .frame(width: 8, height: 14)
////                    .rotationEffect(.degrees(rotation))
////                    .position(x: x, y: y)
////                    .onAppear {
////                        withAnimation(
////                            .easeIn(duration: 2.5)
////                                .delay(delay)
////                        ) {
////                            y = availableHeight + 20
////                            rotation = Double.random(in: 0...360)
////                        }
////                    }
////            }
////        }
////    }
////
////    #Preview {
////        drawView()
////    }
//
//
//import SwiftUI
//import SwiftData
//import Combine
//
//struct drawView: View {
//    @Environment(\.modelContext) private var modelContext  // ✅ Add SwiftData context
//    
//    @State private var animate: Bool = false
//    @State private var showCamera = false
//    @State private var capturedImage: UIImage?
//    @State private var isProcessing = false  // ✅ Add processing state
//
//    static let duration = 900
//    
//    @State private var timeRemaining = DIYtimer.duration
//    @State private var showConfetti = false
//    @State private var timerFinished = false
//    @State private var isRunning = true
//    @State private var timeConsumed: Int = 0
//
//    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
//
//    private var finishedMessage: String {
//        if timeConsumed < 60 {
//            let seconds = max(0, timeConsumed)
//            return "you finished crafting in \(seconds) second\(seconds == 1 ? "" : "s"), yay!"
//        } else {
//            let minutes = max(1, timeConsumed / 60)
//            return "you finished crafting in \(minutes) minute\(minutes == 1 ? "" : "s"), yay!"
//        }
//    }
//
//    var body: some View {
//        NavigationStack {
//            ZStack {
//                Image("background2")
//                    .resizable()
//                    .frame(width: 1370, height: 1037)
//                
//                ZStack {
//                    VStack(spacing: 60) {
//                        Text(timerFinished ? "WELL DONE!" : "GO GO GO!")
//                            .font(.system(size: 90, weight: .bold))
//                            .foregroundColor(.white)
//                            .scaleEffect(animate ? 1.3 : 1.0)
//                            .onAppear {
//                                withAnimation(.easeInOut(duration: 1.0).repeatForever(autoreverses: true)) {
//                                    animate.toggle()
//                                }
//                            }
//                        
//                        if !timerFinished {
//                            Text("Let's make something amazing in the next \(DIYtimer.duration / 60) minutes")
//                                .font(.system(size: 36, weight: .medium))
//                                .foregroundColor(.white.opacity(0.95))
//                                .transition(.opacity)
//                        } else {
//                            Text(finishedMessage)
//                                .font(.system(size: 36, weight: .medium))
//                                .foregroundColor(.white.opacity(0.95))
//                                .transition(.opacity)
//                        }
//                        
//                        if !timerFinished {
//                            Text(timeString(from: timeRemaining))
//                                .font(.system(size: 60, weight: .semibold))
//                                .foregroundColor(.white)
//                        }
//                        
//                        if !timerFinished {
//                            VStack(spacing: 90) {
//                                HStack(spacing: 250) {
//                                    if timeRemaining > 0 {
//                                        Button(action: {
//                                            isRunning.toggle()
//                                        }) {
//                                            ZStack {
//                                                Circle()
//                                                    .fill(Color.ButtonYellow)
//                                                    .frame(width: 100, height: 100)
//                                                Image(systemName: isRunning ? "pause.fill" : "play.fill")
//                                                    .resizable()
//                                                    .bold()
//                                                    .scaledToFit()
//                                                    .frame(width: 50, height: 50)
//                                                    .foregroundColor(.black)
//                                            }
//                                            .opacity(0.8)
//                                        }
//                                    }
//                                    
//                                    Button(action: {
//                                        isRunning = false
//                                        timeConsumed = DIYtimer.duration - timeRemaining
//                                        timerFinished = true
//                                        showConfetti = true
//                                    }) {
//                                        ZStack {
//                                            Circle()
//                                                .fill(Color.ButtonYellow)
//                                                .frame(width: 100, height: 100)
//                                            Image(systemName: "checkmark")
//                                                .resizable()
//                                                .bold()
//                                                .scaledToFit()
//                                                .frame(width: 50, height: 50)
//                                                .foregroundColor(.black)
//                                        }
//                                    }
//                                    
//                                    Button(action: {
//                                        timeRemaining = DIYtimer.duration
//                                        timerFinished = false
//                                        showConfetti = false
//                                        isRunning = true
//                                        timeConsumed = 0
//                                    }) {
//                                        ZStack {
//                                            Circle()
//                                                .fill(Color.ButtonYellow)
//                                                .frame(width: 100, height: 100)
//                                            Image(systemName: "arrow.clockwise")
//                                                .resizable()
//                                                .bold()
//                                                .scaledToFit()
//                                                .frame(width: 50, height: 50)
//                                                .foregroundColor(.black)
//                                        }
//                                        .opacity(0.8)
//                                    }
//                                }
//                            }
//                            .padding(.top, 20)
//                            .padding(.bottom, -40)
//                        }
//                    }
//                    .onReceive(timer) { _ in
//                        guard isRunning else { return }
//                        if timeRemaining > 0 {
//                            timeRemaining -= 1
//                            if timeRemaining == 0 {
//                                timerFinished = true
//                                showConfetti = true
//                                timeConsumed = DIYtimer.duration
//                            }
//                        }
//                    }
//                    
//                    if timerFinished {
//                        ZStack {
//                            VStack {
//                                Spacer()
//                                
//                                HStack {
//                                    // LEFT BUTTON - Home
//                                    NavigationLink(destination: HomeView()) {
//                                        ZStack {
//                                            Circle()
//                                                .fill(Color.ButtonYellow)
//                                                .frame(width: 100, height: 100)
//                                            Image(systemName: "house.fill")
//                                                .resizable()
//                                                .frame(width: 80, height: 70)
//                                                .foregroundColor(.black)
//                                        }
//                                    }
//                                    
//                                    Spacer()
//                                    
//                                    // RIGHT BUTTON - Camera with Background Removal
//                                    Button(action: { showCamera = true }) {
//                                        ZStack {
//                                            Circle()
//                                                .fill(Color.ButtonYellow)
//                                                .frame(width: 100, height: 100)
//                                            Image(systemName: "camera.fill")
//                                                .resizable()
//                                                .frame(width: 60, height: 60)
//                                                .foregroundColor(.black)
//                                        }
//                                    }
//                                    .sheet(isPresented: $showCamera) {
//                                        CameraView(
//                                            onImagePicked: { _ in
//                                                isProcessing = true
//                                            },
//                                            onProcessedImage: { processedImage in
//                                                // ✅ Save to SwiftData with background removed
//                                                if let data = processedImage.pngData() {
//                                                    let newPhoto = MasterPiece(imageData: data)
//                                                    modelContext.insert(newPhoto)
//                                                    try? modelContext.save()
//                                                    print("Photo saved to database!")
//                                                }
//                                                capturedImage = processedImage
//                                                isProcessing = false
//                                            }
//                                        )
//                                    }
//                                }
//                                .padding(.horizontal, 24)
//                                .padding(.bottom, 20)
//                            }
//                        }
//                        .frame(width: 760, height: 510)
//                    }
//                    
//                    if showConfetti {
//                        ConfettiView()
//                    }
//                    
//                    // ✅ Processing overlay
//                    if isProcessing {
//                        ZStack {
//                            Color.black.opacity(0.4)
//                                .ignoresSafeArea()
//                            
//                            VStack(spacing: 20) {
//                                ProgressView()
//                                    .scaleEffect(2)
//                                    .tint(.white)
//                                Text("Processing photo...")
//                                    .font(.headline)
//                                    .foregroundColor(.white)
//                            }
//                            .padding(40)
//                            .background(Color(red: 0.984, green: 0.863, blue: 0.494))
//                            .cornerRadius(20)
//                        }
//                    }
//                }
//            }
//        }
//        .navigationBarBackButtonHidden(true)
//    }
//
//    private func timeString(from totalSeconds: Int) -> String {
//        let hour = totalSeconds / 3600
//        let minutes = (totalSeconds % 3600) / 60
//        let seconds = totalSeconds % 60
//        return String(format: "%02d:%02d:%02d", hour, minutes, seconds)
//    }
//
//    struct ConfettiView: View {
//        let colors: [Color] = [.red, .purple, .yellow, .green, .orange, .pink, .white, .mint]
//
//        var body: some View {
//            GeometryReader { geo in
//                ForEach(0..<500, id: \.self) { _ in
//                    ConfettiPiece(
//                        color: colors.randomElement()!,
//                        x: CGFloat.random(in: 0...geo.size.width),
//                        delay: Double.random(in: 0...3),
//                        availableHeight: geo.size.height
//                    )
//                }
//            }
//            .ignoresSafeArea()
//        }
//    }
//
//    struct ConfettiPiece: View {
//        let color: Color
//        let x: CGFloat
//        let delay: Double
//        let availableHeight: CGFloat
//
//        @State private var y: CGFloat = -20
//        @State private var rotation: Double = 0
//
//        var body: some View {
//            Rectangle()
//                .fill(color)
//                .frame(width: 8, height: 14)
//                .rotationEffect(.degrees(rotation))
//                .position(x: x, y: y)
//                .onAppear {
//                    withAnimation(
//                        .easeIn(duration: 2.5)
//                            .delay(delay)
//                    ) {
//                        y = availableHeight + 20
//                        rotation = Double.random(in: 0...360)
//                    }
//                }
//        }
//    }
//}
//
//#Preview {
//    do {
//        let config = ModelConfiguration(isStoredInMemoryOnly: true)
//        let container = try ModelContainer(for: MasterPiece.self, configurations: config)
//        
//        return drawView()
//            .modelContainer(container)
//    } catch {
//        return drawView()
//    }
//}
import SwiftUI
import SwiftData
import Combine

struct drawView: View {
    @Environment(\.modelContext) private var modelContext
    
    @State private var animate: Bool = false
    @State private var showCamera = false
    @State private var capturedImage: UIImage?
    @State private var isProcessing = false
    @State private var navigateToShelfBox = false  // ✅ Add navigation trigger

    static let duration = 900
    
    @State private var timeRemaining = DIYtimer.duration
    @State private var showConfetti = false
    @State private var timerFinished = false
    @State private var isRunning = true
    @State private var timeConsumed: Int = 0

    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    private var finishedMessage: String {
        if timeConsumed < 60 {
            let seconds = max(0, timeConsumed)
            return "you finished crafting in \(seconds) second\(seconds == 1 ? "" : "s"), yay!"
        } else {
            let minutes = max(1, timeConsumed / 60)
            return "you finished crafting in \(minutes) minute\(minutes == 1 ? "" : "s"), yay!"
        }
    }

    var body: some View {
        NavigationStack {
            ZStack {
                Image("background2")
                    .resizable()
                    .frame(width: 1370, height: 1037)
                
                ZStack {
                    VStack(spacing: 60) {
                        Text(timerFinished ? "WELL DONE!" : "GO GO GO!")
                            .font(.system(size: 90, weight: .bold))
                            .foregroundColor(.white)
                            .scaleEffect(animate ? 1.3 : 1.0)
                            .onAppear {
                                withAnimation(.easeInOut(duration: 1.0).repeatForever(autoreverses: true)) {
                                    animate.toggle()
                                }
                            }
                        
                        if !timerFinished {
                            Text("Let's make something amazing in the next \(DIYtimer.duration / 60) minutes")
                                .font(.system(size: 36, weight: .medium))
                                .foregroundColor(.white.opacity(0.95))
                                .transition(.opacity)
                        } else {
                            Text(finishedMessage)
                                .font(.system(size: 36, weight: .medium))
                                .foregroundColor(.white.opacity(0.95))
                                .transition(.opacity)
                        }
                        
                        if !timerFinished {
                            Text(timeString(from: timeRemaining))
                                .font(.system(size: 60, weight: .semibold))
                                .foregroundColor(.white)
                        }
                        
                        if !timerFinished {
                            VStack(spacing: 90) {
                                HStack(spacing: 250) {
                                    if timeRemaining > 0 {
                                        Button(action: {
                                            isRunning.toggle()
                                        }) {
                                            ZStack {
                                                Circle()
                                                    .fill(Color.ButtonYellow)
                                                    .frame(width: 100, height: 100)
                                                Image(systemName: isRunning ? "pause.fill" : "play.fill")
                                                    .resizable()
                                                    .bold()
                                                    .scaledToFit()
                                                    .frame(width: 50, height: 50)
                                                    .foregroundColor(.black)
                                            }
                                            .opacity(0.8)
                                        }
                                    }
                                    
                                    Button(action: {
                                        isRunning = false
                                        timeConsumed = DIYtimer.duration - timeRemaining
                                        timerFinished = true
                                        showConfetti = true
                                    }) {
                                        ZStack {
                                            Circle()
                                                .fill(Color.ButtonYellow)
                                                .frame(width: 100, height: 100)
                                            Image(systemName: "checkmark")
                                                .resizable()
                                                .bold()
                                                .scaledToFit()
                                                .frame(width: 50, height: 50)
                                                .foregroundColor(.black)
                                        }
                                    }
                                    
                                    Button(action: {
                                        timeRemaining = DIYtimer.duration
                                        timerFinished = false
                                        showConfetti = false
                                        isRunning = true
                                        timeConsumed = 0
                                    }) {
                                        ZStack {
                                            Circle()
                                                .fill(Color.ButtonYellow)
                                                .frame(width: 100, height: 100)
                                            Image(systemName: "arrow.clockwise")
                                                .resizable()
                                                .bold()
                                                .scaledToFit()
                                                .frame(width: 50, height: 50)
                                                .foregroundColor(.black)
                                        }
                                        .opacity(0.8)
                                    }
                                }
                            }
                            .padding(.top, 20)
                            .padding(.bottom, -40)
                        }
                    }
                    .onReceive(timer) { _ in
                        guard isRunning else { return }
                        if timeRemaining > 0 {
                            timeRemaining -= 1
                            if timeRemaining == 0 {
                                timerFinished = true
                                showConfetti = true
                                timeConsumed = DIYtimer.duration
                            }
                        }
                    }
                    
                    if timerFinished {
                        ZStack {
                            VStack {
                                Spacer()
                                
                                HStack {
                                    // LEFT BUTTON - Home
                                    NavigationLink(destination: HomeView()) {
                                        ZStack {
                                            Circle()
                                                .fill(Color.ButtonYellow)
                                                .frame(width: 100, height: 100)
                                            Image(systemName: "house.fill")
                                                .resizable()
                                                .frame(width: 80, height: 70)
                                                .foregroundColor(.black)
                                        }
                                    }
                                    
                                    Spacer()
                                    
                                    // RIGHT BUTTON - Camera with Auto-Navigation
                                    Button(action: { showCamera = true }) {
                                        ZStack {
                                            Circle()
                                                .fill(Color.ButtonYellow)
                                                .frame(width: 100, height: 100)
                                            Image(systemName: "camera.fill")
                                                .resizable()
                                                .frame(width: 60, height: 60)
                                                .foregroundColor(.black)
                                        }
                                    }
                                    .sheet(isPresented: $showCamera) {
                                        CameraView(
                                            onImagePicked: { _ in
                                                isProcessing = true
                                            },
                                            onProcessedImage: { processedImage in
                                                // Save to SwiftData
                                                if let data = processedImage.pngData() {
                                                    let newPhoto = MasterPiece(imageData: data)
                                                    modelContext.insert(newPhoto)
                                                    try? modelContext.save()
                                                    print("Photo saved to database!")
                                                }
                                                capturedImage = processedImage
                                                isProcessing = false
                                                
                                                // ✅ Navigate to ShelfBoxView after saving
                                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                                    navigateToShelfBox = true
                                                }
                                            }
                                        )
                                    }
                                }
                                .padding(.horizontal, 24)
                                .padding(.bottom, 20)
                            }
                        }
                        .frame(width: 760, height: 510)
                    }
                    
                    if showConfetti {
                        ConfettiView()
                    }
                    
                    // Processing overlay
                    if isProcessing {
                        ZStack {
                            Color.black.opacity(0.4)
                                .ignoresSafeArea()
                            
                            VStack(spacing: 20) {
                                ProgressView()
                                    .scaleEffect(2)
                                    .tint(.white)
                                Text("Processing photo...")
                                    .font(.headline)
                                    .foregroundColor(.white)
                            }
                            .padding(40)
                            .background(Color(red: 0.984, green: 0.863, blue: 0.494))
                            .cornerRadius(20)
                        }
                    }
                }
                
                // ✅ Hidden NavigationLink for programmatic navigation
                NavigationLink(
                    destination: ShelfBoxView(),
                    isActive: $navigateToShelfBox
                ) {
                    EmptyView()
                }
                .hidden()
            }
        }
        .navigationBarBackButtonHidden(true)
    }

    private func timeString(from totalSeconds: Int) -> String {
        let hour = totalSeconds / 3600
        let minutes = (totalSeconds % 3600) / 60
        let seconds = totalSeconds % 60
        return String(format: "%02d:%02d:%02d", hour, minutes, seconds)
    }

    struct ConfettiView: View {
        let colors: [Color] = [.red, .purple, .yellow, .green, .orange, .pink, .white, .mint]

        var body: some View {
            GeometryReader { geo in
                ForEach(0..<500, id: \.self) { _ in
                    ConfettiPiece(
                        color: colors.randomElement()!,
                        x: CGFloat.random(in: 0...geo.size.width),
                        delay: Double.random(in: 0...3),
                        availableHeight: geo.size.height
                    )
                }
            }
            .ignoresSafeArea()
        }
    }

    struct ConfettiPiece: View {
        let color: Color
        let x: CGFloat
        let delay: Double
        let availableHeight: CGFloat

        @State private var y: CGFloat = -20
        @State private var rotation: Double = 0

        var body: some View {
            Rectangle()
                .fill(color)
                .frame(width: 8, height: 14)
                .rotationEffect(.degrees(rotation))
                .position(x: x, y: y)
                .onAppear {
                    withAnimation(
                        .easeIn(duration: 2.5)
                            .delay(delay)
                    ) {
                        y = availableHeight + 20
                        rotation = Double.random(in: 0...360)
                    }
                }
        }
    }
}

#Preview {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: MasterPiece.self, configurations: config)
        
        return drawView()
            .modelContainer(container)
    } catch {
        return drawView()
    }
}
