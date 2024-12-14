//
//  AppDelegate.swift
//  Bond_Helper
//


import UIKit
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate  {
    

    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        //App启动--最早执行代码的地方
        print("APP启动")
        
        print(Realm.Configuration.defaultConfiguration.fileURL)
                
        /*let user = User()
        user.name = "11"
        user.id = 1
        user.password = "123"
        user.mail = "11"
        user.birth = Date()
        
        do{
            let realm = try Realm()
            try realm.write{
                realm.add(user)
            }
        }catch{
            print(error)
        }*/

        return true
    }

    
    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

