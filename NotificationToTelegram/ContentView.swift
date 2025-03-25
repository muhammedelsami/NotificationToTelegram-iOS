//
//  ContentView.swift
//  NotificationToTelegram
//
//  Created by Muhammed Elşami on 21.03.2025.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var notificationManager = NotificationManager.shared
    
    var body: some View {
        VStack(spacing: 20) {
            Text("SMS Bildirim Dinleyici")
                .font(.title)
                .padding()
            
            Text("Uygulama aktif. Gelen SMS bildirimleri Telegram'a iletilecek.")
                .multilineTextAlignment(.center)
                .padding()
            
            Text("Bildirimlere izin vermeyi unutmayın!")
                .foregroundColor(.red)
            
            Button(action: {
                // Test mesajı gönder
                notificationManager.sendTestMessage()
            }) {
                Text("Test Mesajı Gönder")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding(.top, 30)
            
            Button(action: {
                notificationManager.createTestNotification()
            }) {
                Text("Test Bildirimi Oluştur")
                    .padding()
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding(.top, 10)
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
