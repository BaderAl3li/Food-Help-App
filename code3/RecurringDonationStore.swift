import FirebaseAuth
import FirebaseFirestore

final class RecurringDonationStore {
    private let db = Firestore.firestore()

    private func docRef() throws -> DocumentReference {
        guard let uid = Auth.auth().currentUser?.uid else {
            throw NSError(domain: "Auth", code: 401,
                          userInfo: [NSLocalizedDescriptionKey: "Not signed in"])
        }
        return db.collection("users")
            .document(uid)
            .collection("recurringDonation")
            .document("current")
    }

    // Create or overwrite (use merge true if you want partial updates)
    func save(data: [String: Any], completion: @escaping (Error?) -> Void) {
        do {
            let ref = try docRef()
            ref.setData(data, merge: true, completion: completion)
        } catch {
            completion(error)
        }
    }

    // Load once
    func load(completion: @escaping ([String: Any]?, Error?) -> Void) {
        do {
            let ref = try docRef()
            ref.getDocument { snap, error in
                if let error = error { completion(nil, error); return }
                completion(snap?.data(), nil) // nil if doesn't exist
            }
        } catch {
            completion(nil, error)
        }
    }

    // Live listener (for your “Current Recurring Donation” screen)
    func listen(onChange: @escaping ([String: Any]?) -> Void) throws -> ListenerRegistration {
        let ref = try docRef()
        return ref.addSnapshotListener { snap, _ in
            onChange(snap?.data())
        }
    }
}
