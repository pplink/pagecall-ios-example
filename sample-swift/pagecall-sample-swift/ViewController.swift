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
    @IBOutlet var publicRoomId: UITextField!
    @IBOutlet var requestUrl: UITextField!
    @IBOutlet var query: UITextField!
    @IBOutlet var replayUrl: UITextField!
    @IBOutlet var replayRoomId: UITextField!
    
    @IBOutlet var btnStart: UIButton!
    @IBOutlet var btnReplay: UIButton!
    
    @IBOutlet var userID: UITextField!
    @IBOutlet var userName: UITextField!
    @IBOutlet var lsaRoomID: UITextField!
    @IBOutlet var lsaServerURL: UITextField!
    @IBOutlet var btnLsaStart: UIButton!
    @IBOutlet var switchHost: UISwitch!
    
    @IBAction func onStart(_ sender: UIButton) {
        
        let myId = self.myId.text!
        let publicRoomId = self.publicRoomId.text!
        let requestUrl = self.requestUrl.text!
        let query = self.query.text!
        
        UserDefaults.standard.set(myId, forKey: "myId")
        UserDefaults.standard.set(publicRoomId, forKey: "publicRoomId")
        UserDefaults.standard.set(requestUrl, forKey: "requestUrl")
        UserDefaults.standard.set(query, forKey: "query")
        
        let pageCall = PageCall.sharedInstance()
        pageCall.delegate = self
        
        #if DEBUG
        #else
        // pagecall log
        pageCall.redirectLogToDocuments(withRoomCount: 3)
        #endif

        // PageCall MainViewController present
        pageCall.mainViewController!.modalPresentationStyle = .overFullScreen
        self.present(pageCall.mainViewController!, animated: true, completion: {
            // #1 Call
            pageCall.call(requestUrl, publicRoomId: publicRoomId, query: query)
            
            // #2 Connect-In
            pageCall.connect(in: requestUrl, myId: myId, publicRoomId: publicRoomId)
            
            // #3 Load HTML
//            let htmlFile = Bundle.main.path(forResource: "Documents/test", ofType: "html")
//            let htmlString = try? String(contentsOfFile: htmlFile!, encoding: String.Encoding.utf8)
//            pageCall.loadHTMLString(htmlString ?? "")
        })
    }
    
    @IBAction func onReplay(_ sender: UIButton) {
            
        let replayUrl = self.replayUrl.text!
        let replayRoomId = self.replayRoomId.text!
            
        UserDefaults.standard.set(replayUrl, forKey: "replayUrl")
        UserDefaults.standard.set(replayRoomId, forKey: "replayRoomId")
            
        let pageCall = PageCall.sharedInstance()
        pageCall.delegate = self
            
        #if DEBUG
        #else
        // pagecall log
        pageCall.redirectLogToDocuments(withRoomCount: 3)
        #endif

        // PageCall MainViewController present
        pageCall.mainViewController!.modalPresentationStyle = .overFullScreen
        self.present(pageCall.mainViewController!, animated: true, completion: {
            pageCall.replay(replayUrl, roomId: replayRoomId)
        })
    }
    
    @IBAction func onLSA(_ sender: UIButton) {
        let userID = self.userID.text!
        let userName = self.userName.text!
        let lsaRoomID = self.lsaRoomID.text!
        let lsaServerURL = self.lsaServerURL.text!
        
        UserDefaults.standard.set(userID, forKey: "userID")
        UserDefaults.standard.set(userName, forKey: "userName")
        UserDefaults.standard.set(lsaRoomID, forKey: "lsaRoomID")
        UserDefaults.standard.set(lsaServerURL, forKey: "lsaServerURL")
        
        let pageCall = PageCall.sharedInstance()
        pageCall.delegate = self
        
        #if DEBUG
        #else
        // pagecall log
        pageCall.redirectLogToDocuments(withRoomCount: 3)
        #endif

        // PageCall MainViewController present
        let mainViewController = pageCall.mainViewController
        mainViewController!.modalPresentationStyle = .overFullScreen
        self.present(mainViewController!, animated: true, completion: {
            pageCall.liveStreaming(withURL: lsaServerURL, isHost: self.switchHost.isOn, roomID: lsaRoomID, userID: userID, userName: userName)
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.btnStart.layer.cornerRadius = 10
        self.btnStart.clipsToBounds = true
        self.btnReplay.layer.cornerRadius = 10
        self.btnReplay.clipsToBounds = true
        self.btnLsaStart.layer.cornerRadius = 10
        self.btnLsaStart.clipsToBounds = true
        
        self.myId.text = UserDefaults.standard.string(forKey: "myId") ?? ""
        self.publicRoomId.text = UserDefaults.standard.string(forKey: "publicRoomId") ?? "publicRoomId"
        self.requestUrl.text = UserDefaults.standard.string(forKey: "requestUrl") ?? "https://pplink.net"
        self.query.text = UserDefaults.standard.string(forKey: "query") ?? "preset=seoltab"
        
        self.replayUrl.text = UserDefaults.standard.string(forKey: "replayUrl") ?? "https://pplink.net"
        self.replayRoomId.text = UserDefaults.standard.string(forKey: "replayRoomId") ?? ""
        
        self.userID.text = UserDefaults.standard.string(forKey: "userID") ?? "testID"
        self.userName.text = UserDefaults.standard.string(forKey: "userName") ?? "testName"
        self.lsaRoomID.text = UserDefaults.standard.string(forKey: "lsaRoomID") ?? "class101_test_"
        self.lsaServerURL.text = UserDefaults.standard.string(forKey: "lsaServerURL") ?? "https://pplink.net"
    }
}

extension ViewController: PageCallDelegate {
    func pageCallDidClose() {
        print("pageCallDidClose")
    }
}
