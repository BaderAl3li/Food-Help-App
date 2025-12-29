//
//  donorProfile.swift
//  Signin
//
//  Created by BP-19-131-02 on 29/12/2025.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import DGCharts

class donorProfile: UIViewController {

    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var donorEmail: UILabel!
    @IBOutlet weak var donorNum: UILabel!
    @IBOutlet weak var barChart: BarChartView!
    
    override func viewDidLoad() {
        loadUserData()
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    func loadUserData(){
        guard let uid = Auth.auth().currentUser?.uid else { return }

            Firestore.firestore()
                .collection("users")
                .document(uid)
                .getDocument { snap, error in

                    if let error = error {
                        print("Error")
                        return
                    }

                    guard let data = snap?.data() else {
                        print("Error")
                        return
                    }

                    DispatchQueue.main.async {
                        self.userName.text = data["donor name"] as? String ?? "-"
                        self.donorEmail.text = data["email"] as? String ?? "-"
                        self.donorNum?.text = data["number"] as? String ?? "-"
                    }
                }

    }
    
    @IBAction func signoutClicked(_ sender: UIButton) {
        
        let alert = UIAlertController(
            title: "Are you sure?",
            message: "Logging out requires to log in again. Are you sure you want to continue?",
            preferredStyle: .alert
        )

        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))

        alert.addAction(
            UIAlertAction(title: "Sign out", style: .destructive) { _ in
                do {
                    try Auth.auth().signOut()
                    self.navigateToLogin()
                } catch {
                    self.showAlert(title: "Signout Failed", message: "Retry in a few minutes")
                }
            }
        )

        present(alert, animated: true)

    }
    
    func loadGraph(){
        guard let uid = Auth.auth().currentUser?.uid else {return}
        
        let cal = Calendar.current
        let startOfWeek = cal.date(from: cal.dateComponents([.yearForWeekOfYear, .weekOfYear], from: Date()))!
        let endOfWeek = cal.date(byAdding: .day, value: 7, to: startOfWeek)!
        
        Firestore.firestore().collection("users").document(uid).collection("food_donations").whereField("createdAt", isGreaterThanOrEqualTo: Timestamp(date: startOfWeek)).whereField("createdAt", isLessThan: Timestamp(date: endOfWeek)).getDocuments{ [weak self] snapshot, _ in guard let self = self else {return}
            
            var totals = Array(repeating: 0, count: 7)
            
            for doc in snapshot?.documents ?? [] {
                let data = doc.data()
                let qty = data["quantity"] as? Int ?? 0
                guard let ts = data["createdAt"] as? Timestamp else {continue}
                
                let dayIndex = cal.dateComponents([.day], from: startOfWeek, to: ts.dateValue()).day ?? 0
                
                if(0...6).contains(dayIndex){
                    totals[dayIndex] += qty
                }
            }
            let df = DateFormatter()
            df.dateFormat = "EEE"
            
            let labels = (0..<7).compactMap { i -> String?
                guard let d = cal.date(byAdding: .day, value: i, to: startOfWeek) else{
                    return df.string(from: d)
                }
                let entries = totals.enumerated().map { i, total in
                    BarChartDataEntry(x: Double(i), y: Double(total))
                }
                DispatchQueue.main.async{
                    let set = BarChartDataSet(entries: entries, label: "This Week")
                    let data = BarChartData(dataSet: set)
                    
                    self.barChart.data = data
                    self.barChart.xAxis.valueFormatter = IndexAxisValueFormatter(values: labels)
                    self.barChart.xAxis.granularity = 1
                    self.barChart.xAxis.labelPosition = .bottom
                    self.barChart.rightAxis.enabled = false
                    
                    self.barChart.notifyDataSetChanged()
                }
            }
        }
    }
    
    func navigateToLogin(){
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let loginVC = sb.instantiateViewController(withIdentifier: "Home")

            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
               let window = windowScene.windows.first {
                window.rootViewController = loginVC
                window.makeKeyAndVisible()
            }
    }
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
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
