//
//  ViewController.swift
//  Demo Combine
//
//  Created by Petrus Nguyễn Thái Học on 10/6/19.
//  Copyright © 2019 Petrus Nguyễn Thái Học. All rights reserved.
//

import UIKit
import Combine

extension Notification.Name {
    static let newMessage = Notification.Name.init("newMessage")
}

struct Message {
    let title: String
    let content: String
}

class ViewController: UIViewController {
    @IBOutlet weak var switchAllowSend: UISwitch!
    @IBOutlet weak var buttonSend: UIButton!
    @IBOutlet weak var labelMessage: UILabel!

    @Published var enableSendButton = false
    var cancellable: AnyCancellable?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.cancellable = $enableSendButton
            .receive(on: DispatchQueue.main)
            .assign(to: \.isEnabled, on: self.buttonSend)
        self.enableSendButton = switchAllowSend.isOn

        NotificationCenter.Publisher.init(center: .default, name: .newMessage)
            .map { ($0.object as? Message)?.title ?? "" }
            .subscribe(Subscribers.Assign.init(object: self.labelMessage, keyPath: \.text))
    }


    @IBAction func switched(_ sender: UISwitch) {
        self.enableSendButton = sender.isOn
    }

    @IBAction func tappedSend(_ sender: Any) {
        NotificationCenter.default.post(.init(name: .newMessage, object: Message.init(title: "Hello \(Date())", content: "Hihi"), userInfo: nil))
    }
}

