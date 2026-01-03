import UIKit
import DGCharts
import Firebase
import FirebaseFirestore

class ViewController: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet weak var headerContainer: UIView!
    @IBOutlet weak var barChartView: BarChartView!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var bigMealsCard: UIView!
    @IBOutlet weak var donationsCard: UIView!
    @IBOutlet weak var previousYearTapped: UIButton!
    @IBOutlet weak var nextYearTapped: UIButton!
    
    // MARK: - Firebase
    private let db = Firestore.firestore()

    // MARK: - Data
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
    }

    // MARK: - Year Handling
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

    // MARK: - Firebase Fetch
    func fetchMonthlyData(for year: Int) {
        db.collection("monthly_stats")
            .whereField("year", isEqualTo: year)
            .getDocuments { snapshot, error in

                var monthlyTotals = Array(repeating: 0.0, count: 12)

                guard let documents = snapshot?.documents else {
                    self.updateBarChart(with: monthlyTotals)
                    return
                }

                for doc in documents {
                    let month = doc["month"] as? Int ?? 0
                    let total = doc["total"] as? Double ?? 0

                    if month >= 1 && month <= 12 {
                        monthlyTotals[month - 1] = total
                    }
                }

                self.updateBarChart(with: monthlyTotals)
            }
    }

    // MARK: - Bar Chart
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

        let chartData = BarChartData(dataSet: dataSet)
        chartData.barWidth = 0.6

        barChartView.data = chartData
        barChartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: months)
        barChartView.notifyDataSetChanged()
    }

    // MARK: - Card Styling
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





func fetchMonthlyData(for userID: String, year: Int) {
    let db = Firestore.firestore()
    
    // Reference to the specific user's monthly_stats collection
    let monthlyStatsRef = db.collection("users").document(userID).collection("monthly_stats")
    
    // Query the collection filtered by the year (if needed)
    monthlyStatsRef
        .whereField("createdAt", isGreaterThan: Timestamp(date: Calendar.current.date(from: DateComponents(year: year))!)) // Example filter for year
        .whereField("createdAt", isLessThan: Timestamp(date: Calendar.current.date(from: DateComponents(year: year + 1))!)) // Example filter for next year
        .getDocuments { snapshot, error in
            
            var monthlyTotals = Array(repeating: 0.0, count: 12)  // Array to hold totals for each month
            
            // Handle errors or empty snapshots
            if let error = error {
                print("Error fetching documents: \(error.localizedDescription)")
                return
            }
            
            guard let documents = snapshot?.documents else {
                print("No documents found")
                return
            }
            
            // Process each document in the snapshot
            for doc in documents {
                let createdAt = doc["createdAt"] as? Timestamp
                let total = doc["total"] as? Double ?? 0.0
                
                // Extract month from the createdAt timestamp
                if let createdAt = createdAt {
                    let calendar = Calendar.current
                    let month = calendar.component(.month, from: createdAt.dateValue()) // Get the month from the timestamp
                    
                    if month >= 1 && month <= 12 {
                        monthlyTotals[month - 1] += total // Sum the total for each month
                    }
                }
            }
            
            // Update the UI on the main thread
            DispatchQueue.main.async {
            }
        }
}
