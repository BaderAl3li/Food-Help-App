import FirebaseAuth
import FirebaseFirestore

final class RecurringDonationStore {
    private let db = Firestore.firestore()

    private func docRef() throws -> DocumentReference {
        guard let uid = Auth.auth().currentUser?.uid else {
            throw NSError(domain: "Auth", code: 401, userInfo: [NSLocalizedDescriptionKey: "Not signed in"])
        }
        return db.collection("users")
            .document(uid)
            .collection("recurringDonation")
            .document("current")
    }

    func listen(onChange: @escaping (RecurringDonation?) -> Void) throws -> ListenerRegistration {
        let ref = try docRef()
        return ref.addSnapshotListener { snap, _ in
            guard let snap = snap, snap.exists else { onChange(nil); return }
            onChange(try? snap.data(as: RecurringDonation.self))
        }
    }
}
