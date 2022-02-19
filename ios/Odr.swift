import Foundation
import UIKit

@objc(Odr)
class Odr: NSObject {
    @objc var bridge: RCTBridge! // this is synthesized

    private let OdrEventProgress = "downloadProgress"
    private let OdrEventFinished = "downloadFinished"
    @objc private var progressUpdateTimer: Timer!
    private var odrDownloader: OdrDownloader? = nil;

    @objc(download:withResolver:withRejecter:)
    func download(_ options:NSDictionary, resolve:@escaping RCTPromiseResolveBlock, reject:@escaping RCTPromiseRejectBlock) -> Void {
        odrDownloader = OdrDownloader(packageName: options["packageName"] as! String, packageType: options["packageType"] as! String)
        observerProgress();
        odrDownloader?.download(onSuccess: { path in
            guard let path = path else { return }
            self.bridge.eventDispatcher().sendAppEvent(withName: self.OdrEventFinished, body: ["success":true])
            resolve(path)
        }) { error in
            self.bridge.eventDispatcher().sendAppEvent(withName: self.OdrEventFinished, body: ["success":false, "error":error])
            reject("odr_error", "ODR Failed", error)
        }
    }
    func observerProgress() {
        self.odrDownloader?.getProgress()?.addObserver(self, forKeyPath: "fractionCompleted", options: .new, context: nil)
    }
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "fractionCompleted" {
            DispatchQueue.main.async {
                var body: [AnyHashable : Any] = [:]
                let progress = self.odrDownloader?.getProgress()
                body["completedUnitCount"] = NSNumber(value: progress!.completedUnitCount)
                body["fractionCompleted"] = NSNumber(value: progress!.fractionCompleted)
                body["totalUnitCount"] = NSNumber(value: progress!.totalUnitCount)
                self.bridge.eventDispatcher().sendAppEvent(withName: self.OdrEventProgress, body: body)
            }
        }
    }
}



