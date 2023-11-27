//
//
// TimeIsMoney
// NotificationManager.swift
//
// Created by Alexander Kist on 26.11.2023.
//

import NotificationCenter

protocol NotificationManagerDelegate: AnyObject {
    func didGetPermission()
}

final class NotificationManager {

    weak var delegate: NotificationManagerDelegate?

    func requestNotificationsPermission() {
        print("Запрос разрешения на уведомления")
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, _ in
            print("Получено разрешение: \(granted)")
            if granted {
                print("Планируем уведомление")
                self.isNotificationsAllowed = granted
                self.scheduleNotifications()
            }
            print("Обновляем статус в delegate")
            self.delegate?.didGetPermission()
        }

    }

    var isNotificationsAllowed: Bool {
        get {
            return UserDefaults.standard.bool(forKey: "notificationsAllowed")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "notificationsAllowed")
        }
    }

    private let titles = ["Отличная работа!", "Молодец!", "Так держать!"]
    private let bodies = ["Cделаем перерыв на кофе?", "Вы потрудились на славу", "Продолжайте в том же духе"]

    private let notificationID = "earnedMoneyNotification"

    private func scheduleNotifications() {

        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [notificationID])
        print("Удаляем старые запросы на уведомления")
        print("Создаем контент уведомления")

        let content = UNMutableNotificationContent()
        content.title = titles.randomElement() ?? "Хорошая работа!"
        content.body = bodies.randomElement() ?? "Может, сделаешь разминку?"
        content.sound = .default

        print("Создаем триггер с интервалом")

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 3600 , repeats: true)

        let request = UNNotificationRequest(identifier: notificationID, content: content, trigger: trigger)

        print("Запрашиваем новое уведомление")
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Ошибка планирования уведомления: \(error)")
            } else {
                print("Уведомление успешно запланировано!")

            }
        }
        print("Уведомление запланировано")

    }
}
