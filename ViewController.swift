//
//  ViewController.swift
//  UID
//
//  Created by David Bolis on 2/9/20.
//

import UIKit
import CoreNFC

class ViewController: UIViewController, NFCTagReaderSessionDelegate {
    @IBOutlet weak var UIDLabel: UILabel!
    var session: NFCTagReaderSession?
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func CaptureBtn(_ sender: Any) {
        self.session = NFCTagReaderSession(pollingOption: .iso14443, delegate: self)
        self.session?.alertMessage = "Hold Your Phone Near the NFC Tag"
        self.session?.begin()
        
    }
    func tagReaderSessionDidBecomeActive(_ session: NFCTagReaderSession) {
        print("Session Begun!")
    }
    func tagReaderSession(_ session: NFCTagReaderSession, didInvalidateWithError error: Error) {
        print("Error with Launching Session")
    }
 
    func tagReaderSession(_ session: NFCTagReaderSession, didDetect tags: [NFCTag]) {
     print("Connecting To Tag")
        if tags.count > 1{
            session.alertMessage = "More Than One Tag Detected, Please try again"
            session.invalidate()
        }
        let tag = tags.first!
        session.connect(to: tag) { (error) in
            if nil != error{
                session.invalidate(errorMessage: "Connection Failed")
            }
            if case let .miFare(sTag) = tag{
                let UID = sTag.identifier.map{ String(format: "%.2hhx", $0)}.joined()
                print("UID:", UID)
                print(sTag.identifier)
                session.alertMessage = "UID Captured"
                session.invalidate()
                DispatchQueue.main.async {
                    self.UIDLabel.text = "\(UID)"
                }
            }
            
        }
        
        
        
        
        
    }
    
    
    
}

