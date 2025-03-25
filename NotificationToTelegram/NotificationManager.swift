//
//  NotificationManager.swift
//  NotificationToTelegram
//
//  Created by Muhammed Elşami on 21.03.2025.
//

import Foundation
import SwiftUI
import UserNotifications

class NotificationManager: NSObject, ObservableObject, UNUserNotificationCenterDelegate {
    static let shared = NotificationManager()
    
    override init() {
        super.init()
        UNUserNotificationCenter.current().delegate = self
    }
    
    func requestPermissions() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if granted {
                print("Bildirim izni alındı")
            } else {
                print("Bildirim izni alınamadı: \(String(describing: error))")
            }
        }
    }
    
    // Ön planda bildirim geldiğinde
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        // Debug bilgisi
        let content = notification.request.content
        print("Bildirim alındı:")
        print("- title: \(content.title)")
        print("- subtitle: \(content.subtitle)")
        print("- body: \(content.body)")
        print("- categoryIdentifier: \(content.categoryIdentifier)")
        print("- threadIdentifier: \(notification.request.content.threadIdentifier)")
        
        processSMSNotification(notification)
        completionHandler([.banner, .sound])
    }
    
    // Kullanıcı bildirime tıkladığında
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        processSMSNotification(response.notification)
        completionHandler()
    }
    
    private func processSMSNotification(_ notification: UNNotification) {
        let content = notification.request.content
        
        let title = content.title
        let body = content.body
        
        print("SMS yakalandı: \(title) - \(body)")
        
        // Telegram'a gönder
        sendToTelegram(title: title, message: body)
        
        // SMS bildirimleri için kontrol
        if content.categoryIdentifier == "message" ||
           notification.request.content.threadIdentifier.contains("sms") ||
           content.subtitle.contains("Mesajlar") ||
           content.subtitle.contains("Messages") {
            
            let title = content.title
            let body = content.body
            
            print("SMS yakalandı: \(title) - \(body)")
            
            // Telegram'a gönder
            sendToTelegram(title: title, message: body)
        }
    }
    
    // Test mesajı göndermek için public metod
    func sendTestMessage() {
        print("Test mesajı gönderiliyor...")
        sendToTelegram(title: "Test Mesajı", message: "Bu bir test mesajıdır. SMS iletim sistemi çalışıyor!")
    }
    
    // Telegram'a mesaj gönderme
    func sendToTelegram(title: String, message: String) {
        let botToken = "" // Kendi bot token'ınızı buraya ekleyin
        let chatId = ""     // Kendi chat ID'nizi buraya ekleyin
        
        let urlString = "https://api.telegram.org/bot\(botToken)/sendMessage"
        let parameters: [String: Any] = [
            "chat_id": chatId,
            "text": "Yeni SMS: \(title)\n\(message)"
        ]
        
        guard let url = URL(string: urlString) else {
            print("Geçersiz URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters)
        } catch {
            print("Veri serileyeme hatası: \(error)")
            return
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Telegram API hatası: \(error)")
                return
            }
            
            if let data = data, let responseString = String(data: data, encoding: .utf8) {
                print("Telegram yanıtı: \(responseString)")
            }
        }.resume()
    }
    
    func createTestNotification() {
        let content = UNMutableNotificationContent()
        content.title = "Test Kişisi"
        content.subtitle = "Mesajlar" // "Messages" için sistem dilinize göre ayarlayın
        content.body = "Merhaba, bu bir test SMS mesajıdır"
        content.sound = UNNotificationSound.default
        content.categoryIdentifier = "message" // SMS için kategori kimliği
        
        // 5 saniye sonra göster
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Bildirim oluşturma hatası: \(error)")
            } else {
                print("Test bildirimi 5 saniye içinde gösterilecek")
            }
        }
    }
}
