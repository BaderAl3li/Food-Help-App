import UIKit
import DGCharts
import Firebase
import FirebaseFirestore

class MainViewController1: UIViewController {

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

         pushTestDataToFirebase() // Use this to push data
        self.navigationController?.setNavigationBarHidden(false, animated: false)

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

    // MARK: - Push Test Data to Firebase
    func pushTestDataToFirebase() {
        // Assuming a userID (replace with the actual user ID if needed)
        let userID = "testUserID"  // Replace with the actual user ID
        let collectionRef = db.collection("users").document(userID).collection("monthly_stats")

        // Hardcoded data for each month (Total and Month)
        let data: [(month: Int, total: Double)] = [
            (1, 5000),  // January
            (4, 2000),  // April
            (8, 1500)   // August
        ]

        // Push the data to Firestore
        for entry in data {
            let month = entry.month
            let total = entry.total
            let createdAt = Calendar.current.date(bySetting: .month, value: month, of: Date())!

            // Creating a document for each entry
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

    // MARK: - Firebase Fetch
    func fetchMonthlyData(for year: Int) {
        // Reference to the user's monthly_stats collection
        let userID = "testUserID" // Replace with actual userID
        db.collection("users")
            .document(userID) // Accessing the specific user's document
            .collection("monthly_stats")
            .whereField("createdAt", isGreaterThanOrEqualTo: Timestamp(date: Calendar.current.date(from: DateComponents(year: year))!)) // Start of the year
            .whereField("createdAt", isLessThan: Timestamp(date: Calendar.current.date(byAdding: .year, value: 1, to: Calendar.current.date(from: DateComponents(year: year))!)!)) // Start of the next year
            .getDocuments { snapshot, error in
                var monthlyTotals = Array(repeating: 0.0, count: 12)

                // Handle error if fetching fails
                if let error = error {
                    print("Error fetching documents: \(error.localizedDescription)")
                    return
                }

                guard let documents = snapshot?.documents else {
                    self.updateBarChart(with: monthlyTotals)
                    return
                }

                // Process the documents and sum totals for each month
                for doc in documents {
                    let data = doc.data()
                    let total = data["total"] as? Double ?? 0.0
                    guard let createdAt = data["createdAt"] as? Timestamp else {
                        print("Missing createdAt timestamp for document \(doc.documentID)")
                        continue
                    }

                    // Get the month from the createdAt timestamp (1-12, so we subtract 1 to make it 0-11)
                    let monthIndex = Calendar.current.component(.month, from: createdAt.dateValue()) - 1

                    if (0...11).contains(monthIndex) {
                        monthlyTotals[monthIndex] += total
                    }
                }

                // Print the aggregated monthly totals
                print("Aggregated Monthly Totals: \(monthlyTotals)")

                // Create month labels for x-axis
                let df = DateFormatter()
                df.dateFormat = "MMM" // Short month name (Jan, Feb, etc.)
                let labels: [String] = (0..<12).compactMap { i in
                    guard let date = Calendar.current.date(byAdding: .month, value: i, to: Calendar.current.date(from: DateComponents(year: year))!) else { return nil }
                    return df.string(from: date)
                }

                // Create BarChartDataEntry for each month
                let entries = monthlyTotals.enumerated().map { i, total in
                    BarChartDataEntry(x: Double(i), y: total)
                }

                // Update chart data on the main thread
                DispatchQueue.main.async {
                    let dataSet = BarChartDataSet(entries: entries, label: "Monthly Donations")
                    let chartData = BarChartData(dataSet: dataSet)
                    self.barChartView.data = chartData
                    self.barChartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: labels)
                    self.barChartView.notifyDataSetChanged()
                }
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

        // Prepare chart data entries based on fetched data
        for i in 0..<12 {
            entries.append(
                BarChartDataEntry(x: Double(i), y: data[i])
            )
        }

        let dataSet = BarChartDataSet(entries: entries, label: "Monthly Donations")
        dataSet.valueFont = .systemFont(ofSize: 10)
        dataSet.colors = [NSUIColor.blue] // Optional: Set bar color

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
