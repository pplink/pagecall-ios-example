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
    
    @IBOutlet var myID: UITextField!
    @IBOutlet var roomID: UITextField!
    @IBOutlet var serverURL: UITextField!
    @IBOutlet var start: UIButton!
    
    @IBAction func onStart(_ sender: UIButton) {
        
        let myID = self.myID.text!
        let roomID = self.roomID.text!
        let serverURL = self.serverURL.text!
        
        UserDefaults.standard.set(myID, forKey: "myID")
        UserDefaults.standard.set(roomID, forKey: "roomID")
        UserDefaults.standard.set(serverURL, forKey: "serverURL")
        
        let pageCall = PageCall.sharedInstance()
        pageCall.delegate = self
        
        #if DEBUG
        #else
        // pagecall log
        pageCall.redirectLogToDocuments(withInterval:1)
        #endif

        // PageCall MainViewController present
        let mainViewController = pageCall.mainViewController
        mainViewController.modalPresentationStyle = .overFullScreen
        self.present(mainViewController, animated: true, completion: {
            // #1 Call
            pageCall.callMyID(myID, roomID: roomID, serverURL: serverURL)
            
            // #2 Connect-In
            //pageCall.connect(inMyID: myID, roomID: roomID, serverURL: serverURL)
            
            // #3 Load HTML
//            let htmlFile = Bundle.main.path(forResource: "Documents/test", ofType: "html")
//            let htmlString = try? String(contentsOfFile: htmlFile!, encoding: String.Encoding.utf8)
//            pageCall.loadHTMLString(htmlString ?? "")
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.start.layer.cornerRadius = 10
        self.start.clipsToBounds = true
        
        self.myID.text = UserDefaults.standard.string(forKey: "myID") ?? "testID"
        self.roomID.text = UserDefaults.standard.string(forKey: "roomID") ?? "testRoomID"
        self.serverURL.text = UserDefaults.standard.string(forKey: "serverURL") ?? "https://pplink.net"
    }
}

extension ViewController: PageCallDelegate {
    func pageCallDidClose() {
        print("pageCallDidClose")
    }
}
