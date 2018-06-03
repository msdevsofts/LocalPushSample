//
//  LocalNotificationController.swift
//  LocalPushSample
//
//  Created by M.S. on 2018/06/03.
//  Copyright © 2018年 M.S. All rights reserved.
//

import UIKit
import UserNotifications

class LocalNotificationController: NSObject {

    static let sharedInstance: LocalNotificationController = LocalNotificationController()

    /// アクション
    ///
    /// - Show: 表示
    enum Action: String {
        case Show
    }

    /// プッシュ通知の許可リクエストを実行する
    ///
    /// - Parameter application: アプリケーション
    internal static func requestAuthentication() {
        // iOS 10.0+
        if #available(iOS 10.0, *) {
            // 通知許可リクエスト
            UNUserNotificationCenter.current().requestAuthorization(
                options: [.alert, .sound], completionHandler: { (success, error) in
                    if (success) {
                        // アクションの設定
                        let action: UNNotificationAction = UNNotificationAction(identifier: Action.Show.rawValue,
                                                                                title: "表示",
                                                                                options: UNNotificationActionOptions(rawValue: 0))
                        let category: UNNotificationCategory = UNNotificationCategory(identifier: "カテゴリ",
                                                                                      actions: [action],
                                                                                      intentIdentifiers: [],
                                                                                      options: UNNotificationCategoryOptions(rawValue: 0))
                        UNUserNotificationCenter.current().setNotificationCategories([category])
                    }

                    if (error != nil) {
                        print(error!)
                    }
            })
        }
        else {
            // アクションの設定
            let action: UIMutableUserNotificationAction = UIMutableUserNotificationAction()
            action.identifier = Action.Show.rawValue
            action.title = "表示"
            action.activationMode = .foreground
            action.isAuthenticationRequired = true
            action.isDestructive = false

            let category: UIMutableUserNotificationCategory = UIMutableUserNotificationCategory()
            category.identifier = "カテゴリ"
            category.setActions([action], for: .default)

            // 通知許可リクエスト
            let settings: UIUserNotificationSettings = UIUserNotificationSettings(types: [.alert, .sound], categories: [category])
            UIApplication.shared.registerUserNotificationSettings(settings)
        }
    }

    internal static func notification(title: String, message: String, additionalData: [String: Any]?) {
        // iOS 10.0+
        if #available(iOS 10.0, *) {

            // 通知の作成
            let content: UNMutableNotificationContent = UNMutableNotificationContent()
            content.title = title
            content.body = message
            if (additionalData != nil) {
                content.userInfo = additionalData!
            }
            content.sound = .default()
            content.categoryIdentifier = "カテゴリ"

            // 通知
            let trigger: UNTimeIntervalNotificationTrigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
            let request: UNNotificationRequest = UNNotificationRequest(identifier: Action.Show.rawValue, content: content, trigger: trigger)
            UNUserNotificationCenter.current().add(request, withCompletionHandler: { (error) in
                if (error != nil) {
                    print(error!)
                }
            })
        }
        else {
            // 通知の作成
            let notification: UILocalNotification = UILocalNotification()
            if #available(iOS 8.2, *) {
                notification.alertTitle = title
            }
            notification.alertBody = message
            if (additionalData != nil) {
                notification.userInfo = additionalData!
            }
            notification.soundName = UILocalNotificationDefaultSoundName
            notification.hasAction = true
            notification.alertAction = "表示"
            notification.category = "カテゴリ"
            notification.fireDate = Date(timeIntervalSinceNow: 1)

            // 通知
            UIApplication.shared.scheduleLocalNotification(notification)
        }
    }


}
