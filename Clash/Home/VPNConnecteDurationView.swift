import SwiftUI

struct VPNConnecteDurationView: View {
    
    @EnvironmentObject private var controller: VPNController
    
    @State private var connectedDuration: String = ""
    
    var body: some View {
        HStack {
            Image(systemName: "clock")
                .font(.title2)
                .foregroundColor(Color.accentColor)
            Text("连接时间")
            Spacer()
            Text(connectedDuration)
                .foregroundColor(.secondary)
        }
        .onReceive(Timer.publish(every: 0.5, on: .current, in: .common).autoconnect()) { _ in
            guard let date = controller.connectedDate else {
                return connectedDuration = ""
            }
            let duration = Int64(abs(date.timeIntervalSinceNow))
            let hs = duration / 3600
            let ms = duration % 3600 / 60
            let ss = duration % 60
            connectedDuration = String(format: "%02d:%02d:%02d", hs, ms, ss)
        }
        .onChange(of: controller.connectionStatus) { status in
            switch status {
            case .invalid, .connecting, .disconnected:
                connectedDuration = ""
            case .connected, .disconnecting, .reasserting:
                break
            @unknown default:
                connectedDuration = ""
            }
        }
    }
}
