import UIKit
import DGCharts
import Firebase
import FirebaseFirestore

class MainViewController1: UIViewController {

    
    @IBOutlet weak var headerContainer: UIView!
    @IBOutlet weak var barChartView: BarChartView!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var bigMealsCard: UIView!
    @IBOutlet weak var donationsCard: UIView!
    @IBOutlet weak var previousYearTapped: UIButton!
    @IBOutlet weak var nextYearTapped: UIButton!
    
    
    private let db = Firestore.firestore()

    
    let months = [
        "Jan","Feb","Mar","Apr","May","Jun",
        "Jul","Aug","Sep","Oct","Nov","Dec"
    ]

    var selectedYear = Calendar.current.component(.year, from: Date())

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        styleCard(bigMealsCard)
        styleCard(donationsCard)

        setupBarChartStyle()
        loadYear()

         pushTestDataToFirebase() // Use this to push data
        self.navigationController?.setNavigationBarHidden(false, animated: false)

    }

    
    func loadYear() {
        yearLabel.text = "\(selectedYear)"
        fetchMonthlyData(for: selectedYear)
    }

    @IBAction func previousYearTapped(_ sender: UIButton) {
        selectedYear -= 1
        loadYear()
    }

    @IBAction func nextYearTapped(_ sender: UIButton) {
        selectedYear += 1
        loadYear()
    }

    
    func pushTestDataToFirebase() {
        
        let userID = "testUserID"
        let collectionRef = db.collection("users").document(userID).collection("monthly_stats")

        
        let data: [(month: Int, total: Double)] = [
            (1, 5000),
            (4, 2000),
            (8, 1500)
        ]

        
        for entry in data {
            let month = entry.month
            let total = entry.total
            let createdAt = Calendar.current.date(bySetting: .month, value: month, of: Date())!

            
            collectionRef.addDocument(data: [
                "month": month,
                "total": total,
                "createdAt": Timestamp(date: createdAt)
            ]) { error in
                if let error = error {
                    print("Error adding document: \(error)")
                } else {
                    print("Document successfully added for month \(month) with total \(total)")
                }
            }
        }
    }

    func fetchMonthlyData(for year: Int) {
        
        let userID = "testUserID"
        db.collection("users")
            .document(userID)
            .collection("monthly_stats")
            .whereField("createdAt", isGreaterThanOrEqualTo: Timestamp(date: Calendar.current.date(from: DateComponents(year: year))!))
            .whereField("createdAt", isLessThan: Timestamp(date: Calendar.current.date(byAdding: .year, value: 1, to: Calendar.current.date(from: DateComponents(year: year))!)!))
            .getDocuments { snapshot, error in
                var monthlyTotals = Array(repeating: 0.0, count: 12)

                
                if let error = error {
                    print("Error fetching documents: \(error.localizedDescription)")
                    return
                }

                guard let documents = snapshot?.documents else {
                    self.updateBarChart(with: monthlyTotals)
                    return
                }

                
                for doc in documents {
                    let data = doc.data()
                    let total = data["total"] as? Double ?? 0.0
                    guard let createdAt = data["createdAt"] as? Timestamp else {
                        print("Missing createdAt timestamp for document \(doc.documentID)")
                        continue
                    }

                    
                    let monthIndex = Calendar.current.component(.month, from: createdAt.dateValue()) - 1

                    if (0...11).contains(monthIndex) {
                        monthlyTotals[monthIndex] += total
                    }
                }

                
                print("Aggregated Monthly Totals: \(monthlyTotals)")

                
                let df = DateFormatter()
                df.dateFormat = "MMM"
                let labels: [String] = (0..<12).compactMap { i in
                    guard let date = Calendar.current.date(byAdding: .month, value: i, to: Calendar.current.date(from: DateComponents(year: year))!) else { return nil }
                    return df.string(from: date)
                }

                
                let entries = monthlyTotals.enumerated().map { i, total in
                    BarChartDataEntry(x: Double(i), y: total)
                }

                
                DispatchQueue.main.async {
                    let dataSet = BarChartDataSet(entries: entries, label: "Monthly Donations")
                    let chartData = BarChartData(dataSet: dataSet)
                    self.barChartView.data = chartData
                    self.barChartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: labels)
                    self.barChartView.notifyDataSetChanged()
                }
            }
    }

    
    func setupBarChartStyle() {
        barChartView.rightAxis.enabled = false
        barChartView.xAxis.labelPosition = .bottom
        barChartView.xAxis.granularity = 1
        barChartView.legend.enabled = true
        barChartView.doubleTapToZoomEnabled = false
        barChartView.animate(yAxisDuration: 1)
    }

    func updateBarChart(with data: [Double]) {
        var entries: [BarChartDataEntry] = []

        
        for i in 0..<12 {
            entries.append(
                BarChartDataEntry(x: Double(i), y: data[i])
            )
        }

        let dataSet = BarChartDataSet(entries: entries, label: "Monthly Donations")
        dataSet.valueFont = .systemFont(ofSize: 10)
        dataSet.colors = [NSUIColor.blue]

        let chartData = BarChartData(dataSet: dataSet)
        chartData.barWidth = 0.6

        barChartView.data = chartData
        barChartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: months)
        barChartView.notifyDataSetChanged()
    }

    
    func styleCard(_ card: UIView) {
        card.layer.cornerRadius = 16
        card.clipsToBounds = true
    }
}

class PercentFormatter: ValueFormatter {
    func stringForValue(
        _ value: Double,
        entry: ChartDataEntry,
        dataSetIndex: Int,
        viewPortHandler: ViewPortHandler?
    ) -> String {
        return "\(Int(value))%"
    }
}
