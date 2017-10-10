//
//  AppDelegate.swift
//  airdropdrive
//
//  Created by shdwprince on 10/11/17.
//  Copyright © 2017 shdwprince. All rights reserved.
//

import UIKit

// handy helper
extension UIView {
    func subview(at: NSInteger) -> AnyObject { return self.subviews[at] }
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UITableViewDataSource, UITableViewDelegate {
    var window: UIWindow!
    var vc: UIViewController!

    // MARK: model
    var files: [URL] {
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        let inbox = path.appending("/Inbox")
        let url = URL(fileURLWithPath: inbox, isDirectory: true)
        return (try? FileManager.default.contentsOfDirectory(at: url,
                                                             includingPropertiesForKeys: nil,
                                                             options: .skipsHiddenFiles)) ?? []
    }

    // MARK: controller
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        self.vc = UIViewController()

        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window.backgroundColor = UIColor.white
        self.window.rootViewController = self.vc
        self.window.makeKeyAndVisible()

        let table = UITableView(frame: self.vc.view.bounds.offsetBy(dx: 0, dy: 18))
        table.delegate = self
        table.dataSource = self
        table.reloadData()
        self.vc.view.addSubview(table)

        return true
    }

    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        self.vc.view.subview(at: 0).reloadData()
        return true
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.vc.present(UIActivityViewController(activityItems: [self.files[indexPath.row], ], applicationActivities: nil),
                        animated: false,
                        completion: nil)
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        do {
            try FileManager.default.removeItem(at: self.files[indexPath.row])
            tableView.deleteRows(at: [indexPath, ], with: .automatic)
        } catch {}
    }

    // MARK: view
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let content = cell.subview(at: 0)
        content.addSubview(UILabel(frame: content.bounds.offsetBy(dx: 16, dy: 0)))
        content.subview(at: 0).setValue(self.files[indexPath.row].absoluteString.components(separatedBy: "/").last, forKey: "text")
        return cell
    }

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool { return true }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat { return 48.0 }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { return self.files.count }
}
