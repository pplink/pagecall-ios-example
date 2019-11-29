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
        
        UserDefaults.standard.set(self.myId.text, forKey: "myId")
        UserDefaults.standard.set(self.roomId.text, forKey: "roomId")
        UserDefaults.standard.set(self.serverURL.text, forKey: "serverURL")
        
        let pageCall = PageCall.sharedInstance()
        #if DEBUG
        #else
        // enable pagecall log
        pageCall.enableLog()
        #endif
        // 1. startMeeting with URL
        //let url = String(format: "%@:5000", self.serverURL.text!);
        //pageCall.connect(inMyID: self.myId.text ?? "", roomId: self.roomId.text ?? "", pcaURL: url)
        //pageCall.delegate = self
        
        // 1. call
        pageCall.call(withMyId: self.myId.text ?? "", roomId: self.roomId.text ?? "", pcaURL: self.serverURL.text ?? "")
        pageCall.delegate = self
        
        /*
        // 2. startMeeting with htmlString
        let htmlFile = Bundle.main.path(forResource: "Documents/test", ofType: "html")
        let htmlString = try? String(contentsOfFile: htmlFile!, encoding: String.Encoding.utf8)
        pageCall.loadHTMLString(htmlString ?? "")
        pageCall.delegate = self
        */

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
