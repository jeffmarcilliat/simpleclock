import SwiftUI



struct ContentView: View {
    @State private var currentTime = Date()
    
    var body: some View {
        TimelineView(.animation) { timeline in
            ClockFace(currentTime: currentTime)
        }
        .frame(width: 300, height: 300)
        .onAppear {
            Timer.scheduledTimer(withTimeInterval: 1/60, repeats: true) { _ in
                currentTime = Date()
            }
        }
        .background(.clear)
    }
}

struct ClockFace: View {
    let currentTime: Date
    
    var body: some View {
        Canvas { context, size in
            let center = CGPoint(x: size.width / 2, y: size.height / 2)
            let radius = min(size.width, size.height) / 2 * 0.8
            
            drawClockFace(context: context, center: center, radius: radius)
            drawClockHands(context: context, center: center, radius: radius, currentTime: currentTime)
        }
    }
    
    private func drawClockFace(context: GraphicsContext, center: CGPoint, radius: CGFloat) {
        // Draw clock face
        context.stroke(Circle().path(in: CGRect(x: center.x - radius, y: center.y - radius, width: radius * 2, height: radius * 2)), with: .color(.white), lineWidth: 1)
        
        // Draw minute tick marks
        for minute in 0..<60 {
            let angle = Double(minute) * .pi / 30
            drawMinuteTick(context: context, center: center, radius: radius, angle: angle)
        }
        
        // Draw hour markers and numbers
        for hour in 1...12 {
            let angle = Double(hour) * .pi / 6 - .pi / 2
            drawHourMarker(context: context, center: center, radius: radius, angle: angle, hour: hour)
        }
    }
    
    private func drawMinuteTick(context: GraphicsContext, center: CGPoint, radius: CGFloat, angle: Double) {
        let outerPoint = CGPoint(
            x: center.x + cos(angle) * radius,
            y: center.y + sin(angle) * radius
        )
        let innerPoint = CGPoint(
            x: center.x + cos(angle) * (radius - 5),
            y: center.y + sin(angle) * (radius - 5)
        )
        context.stroke(Path { path in
            path.move(to: innerPoint)
            path.addLine(to: outerPoint)
        }, with: .color(.white), lineWidth: 1)
    }
    
    private func drawHourMarker(context: GraphicsContext, center: CGPoint, radius: CGFloat, angle: Double, hour: Int) {
        let markerStart = CGPoint(
            x: center.x + cos(angle) * (radius - 10),
            y: center.y + sin(angle) * (radius - 10)
        )
        let markerEnd = CGPoint(
            x: center.x + cos(angle) * radius,
            y: center.y + sin(angle) * radius
        )
        context.stroke(Path { path in
            path.move(to: markerStart)
            path.addLine(to: markerEnd)
        }, with: .color(.white), lineWidth: 2)
        
        let numberPosition = CGPoint(
            x: center.x + cos(angle) * (radius - 25),
            y: center.y + sin(angle) * (radius - 25)
        )
        context.draw(Text("\(hour)").font(.system(size: 20, weight: .bold)), at: numberPosition)
    }
    
    private func drawClockHands(context: GraphicsContext, center: CGPoint, radius: CGFloat, currentTime: Date) {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.hour, .minute, .second, .nanosecond], from: currentTime)
        let hour = Double(components.hour ?? 0).truncatingRemainder(dividingBy: 12)
        let minute = Double(components.minute ?? 0)
        let second = Double(components.second ?? 0)
        let nanosecond = Double(components.nanosecond ?? 0)
        
        drawHand(context: context, center: center, angle: (hour + minute / 60) * .pi / 6 - .pi / 2, length: radius * 0.5, width: 4, color: .white)
        drawHand(context: context, center: center, angle: (minute + second / 60) * .pi / 30 - .pi / 2, length: radius * 0.7, width: 3, color: .white)
        drawHand(context: context, center: center, angle: (second + nanosecond / 1_000_000_000) * .pi / 30 - .pi / 2, length: radius * 0.8, width: 1, color: .red)
    }
    
    private func drawHand(context: GraphicsContext, center: CGPoint, angle: Double, length: CGFloat, width: CGFloat, color: Color) {
        let endPoint = CGPoint(
            x: center.x + cos(angle) * length,
            y: center.y + sin(angle) * length
        )
        context.stroke(Path { path in
            path.move(to: center)
            path.addLine(to: endPoint)
        }, with: .color(color), lineWidth: width)
    }
}

#Preview {
    ContentView()
}
