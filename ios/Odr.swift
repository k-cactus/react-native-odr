import Foundation

@objc(Odr)
class Odr: NSObject {
    @objc(download:withResolver:withRejecter:)
    func download(_ options:NSDictionary, resolve:@escaping RCTPromiseResolveBlock, reject:@escaping RCTPromiseRejectBlock) -> Void {
        let odrDownloader = OdrDownloader(packageName: options["packageName"] as! String, packageType: options["packageType"] as! String)
        odrDownloader.download(onSuccess: { path in
            guard let path = path else { return }
            resolve(path)
        }) { error in
            reject("odr_error", "ODR Failed", error)
        }
    }
}



