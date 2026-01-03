import UIKit

class ImgBBService {
    static let shared = ImgBBService()
    private let apiKey = "0029419628aeb9968749f552ebc8e30c"
    private let uploadURL = "https://api.imgbb.com/1/upload"
    
    private init() {}
    
    func uploadImages(_ images: [UIImage], completion: @escaping (Result<[String], Error>) -> Void) {
        guard !images.isEmpty else {
            completion(.success([]))
            return
        }
        
        let limitedImages = Array(images.prefix(3))
        
        let group = DispatchGroup()
        var uploadedURLs: [String] = []
        var uploadError: Error?
        
        for image in limitedImages {
            group.enter()
            
            let resizedImage = image.resized(to: CGSize(width: 800, height: 600))
            guard let imageData = resizedImage?.jpegData(compressionQuality: 0.7) else {
                group.leave()
                continue
            }
            
            uploadSingleImage(imageData: imageData) { result in
                switch result {
                case .success(let imageURL):
                    uploadedURLs.append(imageURL)
                case .failure(let error):
                    uploadError = error
                }
                group.leave()
            }
        }
        
        group.notify(queue: .main) {
            if let error = uploadError {
                completion(.failure(error))
            } else {
                completion(.success(uploadedURLs))
            }
        }
    }
    
    private func uploadSingleImage(imageData: Data, completion: @escaping (Result<String, Error>) -> Void) {
        guard let url = URL(string: uploadURL) else {
            completion(.failure(ImgBBError.invalidURL))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let boundary = UUID().uuidString
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        var body = Data()
        
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"key\"\r\n\r\n".data(using: .utf8)!)
        body.append("\(apiKey)\r\n".data(using: .utf8)!)
        
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"image\"; filename=\"donation.jpg\"\r\n".data(using: .utf8)!)
        body.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
        body.append(imageData)
        body.append("\r\n".data(using: .utf8)!)
        body.append("--\(boundary)--\r\n".data(using: .utf8)!)
        
        request.httpBody = body
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    completion(.failure(error))
                    return
                }
                
                guard let data = data else {
                    completion(.failure(ImgBBError.noData))
                    return
                }
                
                do {
                    let response = try JSONDecoder().decode(ImgBBResponse.self, from: data)
                    if response.success {
                        completion(.success(response.data.displayURL))
                    } else {
                        completion(.failure(ImgBBError.uploadFailed))
                    }
                } catch {
                    completion(.failure(error))
                }
            }
        }.resume()
    }
}

struct ImgBBResponse: Codable {
    let data: ImgBBData
    let success: Bool
    let status: Int
}

struct ImgBBData: Codable {
    let id: String
    let title: String
    let urlViewer: String
    let url: String
    let displayURL: String
    let width: String
    let height: String
    let size: String
    let time: String
    let expiration: String
    let image: ImgBBImage
    let thumb: ImgBBImage
    let medium: ImgBBImage
    let deleteURL: String
    
    enum CodingKeys: String, CodingKey {
        case id, title, url, width, height, size, time, expiration, image, thumb, medium
        case urlViewer = "url_viewer"
        case displayURL = "display_url"
        case deleteURL = "delete_url"
    }
}

struct ImgBBImage: Codable {
    let filename: String
    let name: String
    let mime: String
    let fileExtension: String
    let url: String
    
    enum CodingKeys: String, CodingKey {
        case filename, name, mime, url
        case fileExtension = "extension"
    }
}

enum ImgBBError: Error, LocalizedError {
    case invalidURL
    case noData
    case uploadFailed
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid upload URL"
        case .noData:
            return "No data received from server"
        case .uploadFailed:
            return "Image upload failed"
        }
    }
}