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
    
    // get request
    @IBOutlet var publicRoomId: UITextField!
    @IBOutlet var requestUrl: UITextField!
    @IBOutlet var query: UITextField!
    @IBOutlet var replayUrl: UITextField!
    @IBOutlet var replayRoomId: UITextField!
    @IBOutlet var btnStart: UIButton!
    @IBOutlet var btnReplay: UIButton!
    
    // post request
    @IBOutlet var userId: UITextField!
    @IBOutlet var postPublicRoomId: UITextField!
    @IBOutlet var postUrl: UITextField!
    @IBOutlet var allowedTime: UITextField!
    @IBOutlet var appName: UITextField!
    @IBOutlet var appVersion: UITextField!
    @IBOutlet var roomData: UITextView!
    @IBOutlet var userData: UITextView!
    @IBOutlet var template: UITextView!
    @IBOutlet var btnPostStart: UIButton!
    
    // lsa
    @IBOutlet var userID: UITextField!
    @IBOutlet var userName: UITextField!
    @IBOutlet var lsaRoomID: UITextField!
    @IBOutlet var lsaServerURL: UITextField!
    @IBOutlet var btnLsaStart: UIButton!
    @IBOutlet var switchHost: UISwitch!
    
    @IBAction func onPostStart(_ sender: UIButton) {
        let userId = self.userId.text!
        let postPublicRoomId = self.postPublicRoomId.text!
        let postUrl = self.postUrl.text!
        let allowedTime = Int(self.allowedTime.text!) ?? 0
        let appName = self.appName.text!
        let appVersion = self.appVersion.text!
        
        // pcaInfo
        let pcaInfo = ["url": postUrl,
                       "userId": userId,
                       "publicRoomId": postPublicRoomId,
                       "allowedTime": allowedTime,
                       "appName": appName,
                       "appVersion": appVersion] as [String : Any]
        
        // json data
        let roomData = convertToDictionary(text: self.roomData.text!)
        let userData = convertToDictionary(text: self.userData.text!)
        let template = convertToDictionary(text: self.template.text!)
        
        UserDefaults.standard.set(userId, forKey: "userId")
        UserDefaults.standard.set(postPublicRoomId, forKey: "postPublicRoomId")
        UserDefaults.standard.set(postUrl, forKey: "postUrl")
        UserDefaults.standard.set(allowedTime, forKey: "allowedTime")
        UserDefaults.standard.set(appName, forKey: "appName")
        UserDefaults.standard.set(appVersion, forKey: "appVersion")
        UserDefaults.standard.set(roomData, forKey: "roomData")
        UserDefaults.standard.set(userData, forKey: "userData")
        UserDefaults.standard.set(template, forKey: "template")
        
        let pageCall = PageCall.sharedInstance()
        pageCall.delegate = self
        
        #if DEBUG
        #else
        // pagecall log
        pageCall.redirectLogToDocuments(withTimeInterval: 4)
        #endif
        
        // PageCall MainViewController present
        pageCall.mainViewController!.modalPresentationStyle = .overFullScreen
        self.present(pageCall.mainViewController!, animated: true, completion: {
            // Request with POST method
            pageCall.connect(in: pcaInfo, roomData: roomData, userData: userData, template: template);
        })
    }
        
    @IBAction func onStart(_ sender: UIButton) {
        
        let publicRoomId = self.publicRoomId.text!
        let requestUrl = self.requestUrl.text!
        let query = self.query.text!
        //let myId = self.userId.text!
        
        UserDefaults.standard.set(publicRoomId, forKey: "publicRoomId")
        UserDefaults.standard.set(requestUrl, forKey: "requestUrl")
        UserDefaults.standard.set(query, forKey: "query")
        
        let pageCall = PageCall.sharedInstance()
        pageCall.delegate = self
        
        #if DEBUG
        #else
        // pagecall log
        pageCall.redirectLogToDocuments(withTimeInterval: 4)
        #endif

        // PageCall MainViewController present
        pageCall.mainViewController!.modalPresentationStyle = .overFullScreen
        self.present(pageCall.mainViewController!, animated: true, completion: {
            
            // #1 Call
            pageCall.call(requestUrl, publicRoomId: publicRoomId, query: query)
            
            // #2 Connect-In
            //pageCall.connect(in: requestUrl, myId: myId, publicRoomId: publicRoomId)
            
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
        pageCall.redirectLogToDocuments(withTimeInterval: 4)
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
        pageCall.redirectLogToDocuments(withTimeInterval: 4)
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
        
        self.roomData.layer.cornerRadius = 5.0
        self.roomData.layer.borderWidth = 0.5
        self.userData.layer.cornerRadius = 5.0
        self.userData.layer.borderWidth = 0.5
        self.template.layer.cornerRadius = 5.0
        self.template.layer.borderWidth = 0.5
        self.btnPostStart.layer.cornerRadius = 10
        self.btnPostStart.clipsToBounds = true
        
        self.btnLsaStart.layer.cornerRadius = 10
        self.btnLsaStart.clipsToBounds = true
        
        self.publicRoomId.text = UserDefaults.standard.string(forKey: "publicRoomId") ?? "publicRoomId"
        self.requestUrl.text = UserDefaults.standard.string(forKey: "requestUrl") ?? "https://pplink.net"
        self.query.text = UserDefaults.standard.string(forKey: "query") ?? "preset=seoltab"
        
        self.replayUrl.text = UserDefaults.standard.string(forKey: "replayUrl") ?? "https://pplink.net"
        self.replayRoomId.text = UserDefaults.standard.string(forKey: "replayRoomId") ?? ""
        
        self.userId.text = UserDefaults.standard.string(forKey: "userId") ?? "userId"
        self.postPublicRoomId.text = UserDefaults.standard.string(forKey: "postPublicRoomId") ?? "publicRoomId"
        self.postUrl.text = UserDefaults.standard.string(forKey: "postUrl") ?? "https://pplink.net"
        self.appName.text = UserDefaults.standard.string(forKey: "appName") ?? ""
        self.appVersion.text = UserDefaults.standard.string(forKey: "appVersion") ?? ""
        
        var allowedTime = UserDefaults.standard.integer(forKey: "allowedTime")
        if allowedTime == 0 {
            allowedTime = 10
        }
        self.allowedTime.text = String(allowedTime)
        
        var roomData = UserDefaults.standard.dictionary(forKey: "roomData")
        if roomData == nil {
            roomData = ["room": "testRoom", "title": "PageCall Mobile!!!"]
        }
        self.roomData.text = convertToString(dic: roomData!)
        
        var userData = UserDefaults.standard.dictionary(forKey: "userData")
        if userData == nil {
            userData = ["frame": NSNumber(value: 30), "mirror": NSNumber(value: false)]
        }
        self.userData.text = convertToString(dic: userData!)
        
        var template = UserDefaults.standard.dictionary(forKey: "template")
        if template == nil {
            template = ["videoPosition": "floating", "language": "en"]
        }
        self.template.text = convertToString(dic: template!)
        
        self.userID.text = UserDefaults.standard.string(forKey: "userID") ?? "testID"
        self.userName.text = UserDefaults.standard.string(forKey: "userName") ?? "testName"
        self.lsaRoomID.text = UserDefaults.standard.string(forKey: "lsaRoomID") ?? "class101_test_"
        self.lsaServerURL.text = UserDefaults.standard.string(forKey: "lsaServerURL") ?? "https://pplink.net"
    }
}

func convertToDictionary(text: String) -> [String: Any]? {
    if let data = text.data(using: .utf8) {
        do {
            return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
        } catch {
            print(error.localizedDescription)
        }
    }
    return nil
}

func convertToString(dic: Dictionary<String, Any>) -> String? {
    let jsonData = try? JSONSerialization.data(withJSONObject: dic, options: [])
    let jsonString = String(data: jsonData!, encoding: .utf8)
    return jsonString
}

extension ViewController: PageCallDelegate {
    func pageCallDidClose() {
        print("pageCallDidClose")
    }

    func pageCallDidReceive(_ message: WKScriptMessage) {
        print("pageCallDidReceive message")
        
        /* sample JS
        var message = {
            command: 'finishedLoading',
            interval: 1
        };
        window.webkit.messageHandlers.pageCallSDK.postMessage(message);
        */
        
        if message.name == "pageCallSDK" {
            guard let dict = message.body as? [String: AnyObject],
                  let command = dict["command"] as? String,
                  let interval = dict["interval"] as? Int else {
                    return
            }
            print("pageCallDidReceiveScriptMessage command: \(command), interval: \(interval)")
        }
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        print("webView decidePolicyFor navigationAction")
        decisionHandler(.allow)
    }
}
