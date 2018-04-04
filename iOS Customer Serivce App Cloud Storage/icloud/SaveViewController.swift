

import Foundation
import UIKit
import CloudKit

class SaveViewController: UIViewController {

    let database = CKContainer.default().publicCloudDatabase //store public cloud
    var defaultKeyStore: UserDefaults? = UserDefaults.standard
    let DefaultsTextKey = "DefaultsText"

    @IBOutlet var locationText: UITextField!
    @IBOutlet var reasonText: UITextField!
    @IBOutlet var descText: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()
        if !isIcloudAvailable() {
            print("iCloud is not available")
            displayAlertWithTitle("iCloud", message: "iCloud is not available." +
                " Please sign into your iCloud account and restart this app")
            return
        } else {
            print("iCloud is available")
        }
        localSetUp()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func isIcloudAvailable() -> Bool {
        if let _ = FileManager.default.ubiquityIdentityToken{
            return true
        } else {
            return false
        }
    }

    //Helper function to display alert if icloud is not available
    func displayAlertWithTitle(_ title: String, message: String){
        let controller = UIAlertController(title: title,
            message: message,
            preferredStyle: .alert)

        controller.addAction(UIAlertAction(title: "OK",
            style: .default,
            handler: nil))

        present(controller, animated: true, completion: nil)
    }

    func getDate() -> String {
        let todaysDate:Date = Date()
        let dateFormatter:DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd"
        let todayString:String = dateFormatter.string(from: todaysDate)
        return todayString
    }

    @IBAction func saveLocalBtn(_ sender: UIButton) {
        saveLocally()
    }

    @IBAction func saveCloudBtn(_ sender: UIButton)
    {
        print("Save to iCloud...")
        let callData = CKRecord(recordType: "CallData")
        callData.setObject(("Service Call " + getDate()) as CKRecordValue, forKey: "name")
        callData.setObject(locationText.text! as CKRecordValue?, forKey: "location")
        callData.setObject(reasonText.text! as CKRecordValue?, forKey: "reason")
        callData.setObject(descText.text! as CKRecordValue?, forKey: "description")
        /* Save this record publicly */
        database.save(callData, completionHandler:
            {
          (record: CKRecord?, error: Error?) in
          if error != nil
          {
            print("Error occurred. Error = \(error)")
          } else
          {
            print("Successfully saved the record in the public database")
          }
            } as! (CKRecord?, Error?) -> Void)
    }

    //Save locally (key)
    func generateLocalString() -> String {
        return locationText.text! + ", " + reasonText.text! + ", " + descText.text!
    }

    func localSetUp() {
        NotificationCenter.default.removeObserver(self, name: NSUbiquitousKeyValueStore.didChangeExternallyNotification, object: defaultKeyStore)
    }

    func saveLocally() {
        print("Save locally...")
        defaultKeyStore?.set(generateLocalString(), forKey: DefaultsTextKey)
        defaultKeyStore?.synchronize()
    }
}
