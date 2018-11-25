//
//  ViewController.swift
//  NFCReaderDemo
//
//  Created by Davlat Mirmanov on 25/11/2018.
//  Copyright © 2018 Davlat Mirmanov. All rights reserved.
//

import UIKit
import CoreNFC

class ViewController: UIViewController {
    @IBOutlet var messagesTextView: UITextView!
    private var readerSession: NFCNDEFReaderSession?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
}

extension ViewController {
    @IBAction func startScanning(_ sender: Any) {
        if NFCNDEFReaderSession.readingAvailable {
            readerSession = NFCNDEFReaderSession(delegate: self, queue: DispatchQueue.main, invalidateAfterFirstRead: true)
            readerSession?.alertMessage = "Hold your iPhone near the NFC tag"
            readerSession?.begin()
        }
        else {
            let alert = UIAlertController(title: "Ooops!", message: "Seems like your device doesn't support NFC tag reading.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
        }
    }
    
    func stopScanning() {
        readerSession?.invalidate()
    }
}

extension ViewController: NFCNDEFReaderSessionDelegate {
    func readerSession(_ session: NFCNDEFReaderSession, didInvalidateWithError error: Error) {
        messagesTextView.text = error.localizedDescription
    }
    
    func readerSession(_ session: NFCNDEFReaderSession, didDetectNDEFs messages: [NFCNDEFMessage]) {
        var messagesStr = "Scanned data:\n\n"
        for message in messages {
            for record in message.records {
                if let payloadStr = String(bytes: record.payload, encoding: .utf8) {
                    messagesStr += "Record:\n"
                    messagesStr += payloadStr
                    messagesStr += "\n\n"
                }
            }
        }
        messagesTextView.text = messagesStr
    }
}
