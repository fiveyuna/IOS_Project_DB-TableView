
import UIKit

class DetailViewController: UIViewController {
    
    var receiveTask: TaskDto!

    @IBOutlet var lblDate: UILabel!
    @IBOutlet var tfTitle: UITextField!
    @IBOutlet var tfDetail: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // 전달 받은 TaskDto 의 시간 정수 값을 시간 형식으로 변경하여 표시
        let date = Date(timeIntervalSince1970: TimeInterval(receiveTask.date))
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd EEE hh:mm a"
        lblDate.text = formatter.string(from: date)
        
        tfTitle.text = receiveTask.title
        tfDetail.text = receiveTask.detail
    }
    
    func receiveItem(_ task: TaskDto) {
        // TaskDto 가 잘 전달되었는지 확인
        print("received: \(task.id)")
        receiveTask = task
    }

    // 화면의 입력 값(제목, 내용) 으로 DB 수정
    @IBAction func btnModify(_ sender: UIButton) {
        manager.updateData(receiveTask.id, tfTitle.text!, tfDetail.text!)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
