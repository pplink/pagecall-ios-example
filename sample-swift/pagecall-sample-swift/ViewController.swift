//
//  ViewController.swift
//  pagecall-sample-swift
//
//  Created by Park Sehun on 26/04/2019.
//  Copyright © 2019 Park Sehun. All rights reserved.
//

import UIKit
import PageCallSDK

class ViewController: UIViewController {
    
    @IBOutlet var myId: UITextField!
    @IBOutlet var roomId: UITextField!
    @IBOutlet var serverURL: UITextField!
    @IBOutlet var start: UIButton!
    
    @IBAction func onStart(_ sender: UIButton) {
        
        let myId = self.myId.text!
        let roomId = self.roomId.text!
        let url = self.serverURL.text!
        
        UserDefaults.standard.set(myId, forKey: "myId")
        UserDefaults.standard.set(roomId, forKey: "roomId")
        UserDefaults.standard.set(url, forKey: "serverURL")
        
        let pageCall = PageCall.sharedInstance()
        pageCall.delegate = self
        
        #if DEBUG
        #else
        // enable pagecall log
        pageCall.enableLog()
        #endif
        
        // #1 Connect-In
        pageCall.connect(inMyID: myId, roomId: roomId, pcaURL: url)
        
        // #2 Call
        //pageCall.call(withMyId: myId, roomId: roomId, pcaURL: url)
        
        // #3 Load HTML
//        let htmlFile = Bundle.main.path(forResource: "Documents/test", ofType: "html")
//        let htmlString = try? String(contentsOfFile: htmlFile!, encoding: String.Encoding.utf8)
//        pageCall.loadHTMLString(htmlString ?? "")

        // present viewController
        pageCall.pcViewController?.modalPresentationStyle = .overFullScreen
        self.present(pageCall.pcViewController!, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.start.layer.cornerRadius = 10
        self.start.clipsToBounds = true
        
        self.myId.text = UserDefaults.standard.string(forKey: "myId") ?? "myId"
        self.roomId.text = UserDefaults.standard.string(forKey: "roomId") ?? "roomId"
        self.serverURL.text = UserDefaults.standard.string(forKey: "serverURL") ?? "https://pplink.net"
    }
}

extension ViewController: PageCallDelegate {
    func pageCallDidClose() {
        print("pageCallDidClose")
    }
}
