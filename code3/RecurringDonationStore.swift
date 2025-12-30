//
//  ViewController.swift
//  code3
//
//  Created by BP-19-114-09 on 21/12/2025.
//

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

    func save(data: [String: Any], completion: @escaping (Error?) -> Void) {
        do {
            let ref = try docRef()
            ref.setData(data, merge: true, completion: completion)
        } catch {
            completion(error)
        }
    }

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

    func listen(onChange: @escaping ([String: Any]?) -> Void) throws -> ListenerRegistration {
        let ref = try docRef()
        return ref.addSnapshotListener { snap, _ in
            onChange(snap?.data())
        }
    }
}
