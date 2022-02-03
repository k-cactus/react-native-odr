import Foundation

/* ODR Downloading */

class OdrDownloader {
  
  private var resourceRequest: NSBundleResourceRequest?
  private var packageName: String
  private var packageType: String

  init(packageName: String, packageType: String) {
    resourceRequest = NSBundleResourceRequest(tags: Set([packageName]), bundle: Bundle.main)
    self.packageName = packageName
    self.packageType = packageType
  }
  
  public func download(onSuccess: @escaping (String?) -> Void, onFailed: @escaping (Error) -> Void) {
    
    resourceRequest?.conditionallyBeginAccessingResources { (available) in
      if available {
        DispatchQueue.main.async {
          let path = self.resourceRequest?.bundle.path(forResource: self.packageName, ofType: self.packageType)
          onSuccess(path)
        }
      } else {
        self.downloadRequest(onSuccess: onSuccess, onFailed: onFailed)
      }
    }
  }
  
  private func downloadRequest(onSuccess: @escaping (String?) -> Void, onFailed: @escaping (Error) -> Void) {
    resourceRequest?.beginAccessingResources(completionHandler: { (error) in
      guard let error = error else {
        DispatchQueue.main.async {
          let path = self.resourceRequest?.bundle.path(forResource: self.packageName, ofType: self.packageType)
          onSuccess(path)
        }
        return
      }
      DispatchQueue.main.async {
        onFailed(error)
      }
    })
  }
  
  deinit {
    resourceRequest?.endAccessingResources()
    resourceRequest = nil
  }
}
