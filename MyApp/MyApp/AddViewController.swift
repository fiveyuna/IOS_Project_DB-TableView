
import UIKit
import MobileCoreServices

class AddViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    @IBOutlet var dpPicker: UIDatePicker!
    @IBOutlet var tfTitle: UITextField!
    @IBOutlet var tfDetail: UITextField!
    @IBOutlet var imgView: UIImageView!
    
    let now = NSDate()
    let imagePicker: UIImagePickerController! = UIImagePickerController()
    
    var captureImage: UIImage!
    var imgURL: URL!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    
        // DatePicker 에 현재 시간 설정
        dpPicker.date = now as Date
    }
    
//    @IBAction func btnLoadingImageFromLibarary(_ sender: UIButton) {
//        if (UIImagePickerController.isSourceTypeAvailable(.photoLibrary)) {
//            imagePicker.delegate = self
//            imagePicker.sourceType = .photoLibrary
//            imagePicker.mediaTypes = ["public.image"]
//            imagePicker.allowsEditing = true
//
//            present(imagePicker, animated: true, completion: nil)
//        } else {
//            myAlert("Photo album inaccessable", message: "Application cannot access the photo album.")
//        }
//    }
    
    @IBAction func btnSave(_ sender: UIButton) {
        // 뷰에 입력한 값을 사용하여 DB에 추가
        let day = Int32(dpPicker.date.timeIntervalSince1970)
        manager.insertData(tfTitle.text!, day, tfDetail.text!, "cart.png")
        tfTitle.text = ""
        tfDetail.text = ""
        dpPicker.date = now as Date
        _ = navigationController?.popViewController(animated: true)
    }
    
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
//        let mediaType = info[UIImagePickerController.InfoKey.mediaType] as! NSString
//
//        if mediaType.isEqual(to: "public.image" as String) {
//            captureImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
//            imgURL = (info[UIImagePickerController.InfoKey.mediaURL] as! URL)
//            imgView.image  = captureImage
//        }
//
//        self.dismiss(animated: true, completion: nil)
//    }
//
//    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
//        self.dismiss(animated: true, completion: nil)
//    }
//
//    func myAlert(_ title: String, message: String) {
//        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
//        let action = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
//
//        alert.addAction(action)
//        self.present(alert, animated: true, completion: nil)
//    }
//

}

