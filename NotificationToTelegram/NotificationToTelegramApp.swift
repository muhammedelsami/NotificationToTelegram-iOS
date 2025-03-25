//
//  NotificationToTelegramApp.swift
//  NotificationToTelegram
//
//  Created by Muhammed Elşami on 21.03.2025.
//

import SwiftUI

@main
struct NotificationToTelegramApp: App {
    
    @StateObject private var notificationManager = NotificationManager.shared
    @Environment(\.scenePhase) private var scenePhase
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .onAppear {
                    // Uygulama açıldığında bildirim izinlerini iste
                    notificationManager.requestPermissions()
                }
        }
        .onChange(of: scenePhase) { newPhase in
            switch newPhase {
            case .active:
                print("Uygulama aktif")
            case .inactive:
                print("Uygulama inaktif")
            case .background:
                print("Uygulama arka planda")
                // Burada arka plan görevleri başlatılabilir
            @unknown default:
                print("Bilinmeyen uygulama durumu")
            }
        }
    }
}
