//
//  SceneDelegate.swift
//  Thesis
//
//  Created by István Juhász on 2022. 11. 01..
//

import UIKit
import CoreData

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        
        //window?.rootViewController = UINavigationController(rootViewController: ARViewController())
        
        if UserDefaults.standard.bool(forKey: "hasOnboarded") {
            let layout = UICollectionViewFlowLayout()
            let vc = MainViewController(collectionViewLayout: layout)
            let nav = UINavigationController(rootViewController: vc)
            window?.rootViewController = nav
            window?.makeKeyAndVisible()
        } else {
            loadData()
            let nav = UINavigationController(rootViewController: OnboardingPageViewController())
            window?.rootViewController = nav
            window?.makeKeyAndVisible()
        }
    }

    func deleteData() {
        let appDel:AppDelegate = (UIApplication.shared.delegate as! AppDelegate)
        let context:NSManagedObjectContext = appDel.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ARModel")
        fetchRequest.returnsObjectsAsFaults = false
        do {
            let results = try context.fetch(fetchRequest)
            for managedObject in results {
                if let managedObjectData: NSManagedObject = managedObject as? NSManagedObject {
                    context.delete(managedObjectData)
                }
            }
        } catch let error as NSError {
            print("Deleted all my data in myEntity error : \(error) \(error.userInfo)")
        }
    }
    
    func loadData() {
        deleteData()
        let skeletalSystem: [[String]] = [
            ["Laryngeal", "This is the Laryngeal."],
            ["Chest", "This is the Chest."],
            ["Skull", "This is the Skull."],
            ["Arm", "This is the Arm."],
            ["Foot", "This is the Foot."],
            ["Hand", "This is the Hand."],
            ["Leg", "This is the Leg."],
            ["PelvicGirdle", "This is the PelvicGirdle."],
            ["ShoulderGirdle", "This is the ShoulderGirdle."],
            ["VertebralColumn", "This is the VertebralColumn."],
        ]
        
        let skeletalQuestions: [Question] = [
            Question(question: "Hany fogad van?", answerIndex: 0, answers: ["1", "2", "3", "nullaaaa"]),
            Question(question: "be szartal?", answerIndex: 3, answers: ["nem tom", "esku nem", "nem", "be"]),
            Question(question:  "miert fosos a gatyad", answerIndex: 0, answers: ["mert be szartam", "nem is az", "sabaton", "miiii"]),
            Question(question: "miert fogsz bukni falmaszasbol", answerIndex: 1, answers: ["nem mondom el", "mert nem jarok orara", "temi anyja miatt", "meguntam"]),
        ]
        
        let visceralSystem: [[String]] = [
            // TODO
        ]
        
        let muscularSystem: [[String]] = [
            // TODO
        ]
        
        skeletalSystems.forEach { system in
            let anatomyModel = AnatomyModel(name: system, informationText: "skeletalSystem", category: "skeletal", questions: skeletalQuestions)
            AnatomyModelArray.append(anatomyModel)
        }
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

