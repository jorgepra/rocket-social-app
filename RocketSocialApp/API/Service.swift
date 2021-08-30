//
//  Service.swift
//  RocketSocialApp
//
//  Created by Jorge Pillaca Ramirez on 5/08/21.
//

import Foundation
import Alamofire

class Service: NSObject {
    
    static var shared = Service()
    
    var base_url: String {
      get {
        guard let filePath = Bundle.main.path(forResource: "SocialApp-Info", ofType: "plist") else{
          fatalError("Couldn't find file 'SocialApp-Info.plist'.")
        }
        let plist = NSDictionary(contentsOfFile: filePath)
        guard let value = plist?.object(forKey: "BASE_URL") as? String else {
          fatalError("Couldn't find key 'BASE_URL' in 'SocialApp-Info.plist'.")
        }
        return value
      }
    }
    
    func login(email: String, password: String, completion: @escaping (Result<Data, Error>)->Void) {
        
        guard let url = URL(string: "\(base_url)/api/v1/entrance/login") else { return }
        
        let params = ["emailAddress": email, "password": password]
        
        AF.request(url, method: .put, parameters: params, encoding: URLEncoding())
            .validate(statusCode: 200..<300)
            .responseData { dataResp in
                                                
                if let error = dataResp.error {
                    completion(.failure(error))
                    return
                }
                                
                completion(.success(dataResp.data ?? Data()))
        }
    }
    
    func logout(completion: @escaping (Error?)->Void)  {
        guard let url = URL(string: "\(base_url)/api/v1/account/logout") else { return }
        
        
        AF.request(url)
            .validate(statusCode: 200..<300)
            .responseData { dataResp in
                                                
                if let error = dataResp.error {
                    completion(error)
                    return
                }
                print(String(data: dataResp.data ?? Data(), encoding: .utf8) ?? "")
                completion(nil)
        }
    }
    
    func signup(fullName: String, email: String, password: String, completion: @escaping (Result<Data,Error>)->Void ) {
        guard let url = URL(string: "\(base_url)/api/v1/entrance/signup") else { return }
        
        let params = [
            "fullName": fullName,
            "emailAddress": email,
            "password": password
        ]
        
        AF.request(url, method: .post, parameters: params)
            .validate(statusCode: 200..<300)
            .responseData { dataResp in
                
                if let error = dataResp.error{
                    completion(.failure(error))
                    return
                }
                
                print("Successfully signed up.")
                completion(.success(dataResp.data ?? Data()))
            }
    }
    
    
    func fetchPosts(completion: @escaping (Result<[Post],Error>)->Void) {
        guard let url = URL(string: "\(base_url)/post") else { return }
        
        AF.request(url)
            .validate(statusCode: 200..<300)
            .responseDecodable(of: [Post].self) { dataResp in
                if let error = dataResp.error{
                    completion(.failure(error))
                    return
                }
                                
                completion(.success(dataResp.value ?? []))
            }
    }
    
    func fetchPostDetails(postId: String, completion: @escaping (Result<Post, Error>)->Void) {
        guard let url = URL(string: "\(base_url)/post/\(postId)") else { return }
        AF.request(url)
            .validate(statusCode: 200..<300)
            .responseDecodable(of: Post.self) { dataResp in
                if let error = dataResp.error{
                    completion(.failure(error))
                    return
                }
                                
                if let post = dataResp.value {
                    completion(.success(post))
                }
            }
    }
    
    func deletePost(post: Post, completion: @escaping (Error?)->Void) {
        guard let url = URL(string: "\(base_url)/post/\(post.id)") else {return}
        
        AF.request(url, method: .delete)
            .validate(statusCode: 200..<300)
            .responseData { resp in
                if let error = resp.error {                    
                    completion(error)
                    return
                }                
                completion(nil)
        }
    }
    
    func createComment(postId: String, text: String, completion: @escaping (Error?)->Void)  {
        guard let url = URL(string: "\(base_url)/comment/post/\(postId)") else {return}
        
        let params = [
            "id" : postId,
            "text": text
        ] as [String: Any]
        
        AF.request(url, method: .post, parameters: params)
            .validate(statusCode: 200..<300)
            .responseData { resp in
                if let error = resp.error {
                    completion(error)
                    return
                }
                
                print(String(data: resp.data ?? Data(), encoding: .utf8) ?? "")
                
                completion(nil)
        }
    }
    
    func searchForUsers(completion: @escaping (Result<[User],Error>)->Void) {
        guard let url = URL(string: "\(base_url)/search") else {return}
        
        AF.request(url, method: .get)
            .validate(statusCode: 200..<300)
            .responseDecodable(of: [User].self) { dataResp in
                if let error = dataResp.error{
                    completion(.failure(error))
                    return
                }
                
                completion(.success(dataResp.value ?? []))
            }
    }
    
    func followTo(user: User, completion: @escaping (Result<Bool,Error>)->Void) {
        let isFollowing = user.isFollowing == true
        
        guard let url = URL(string: "\(base_url)/\(isFollowing ? "unfollow": "follow" )/\(user.id)") else {return}
        
        AF.request(url, method: .post)
            .validate(statusCode: 200..<300)
            .responseData { resp in
                if let error = resp.error {
                    completion(.failure(error))
                    return
                }
                completion(.success(!isFollowing))
        }
    }
    
    func fetchProfile(userId: String, completion: @escaping (Result<User,Error>)->Void) {
        
        let publicProfileUrl = "\(base_url)/user/\(userId)"
        let currentUserProfile = "\(base_url)/profile"
                        
        guard let url = URL(string: ( userId.isEmpty ? currentUserProfile: publicProfileUrl) ) else { return }
        
        AF.request(url, method: .get)
            .validate(statusCode: 200..<300)
            .responseDecodable(of: User.self) { dataResp in
                if let error = dataResp.error{
                    completion(.failure(error))
                    return
                }
                if let user = dataResp.value {
                    completion(.success(user))
                } 
            }
    }
    
    func uploadPost(text: String, image: UIImage, completion: @escaping (Error?)->Void) {
        let url = String("\(base_url)/post")
        
        guard let _ = URL(string: url) else { return }
        
        let headers = ["Content-type": "multipart/form-data","Content-Disposition" : "form-data"]
        let httpHeader = HTTPHeaders(headers)
                                
        AF.upload(multipartFormData: { formData in
            
            formData.append(Data(text.utf8), withName: "postText")
            
            guard let imageData = image.jpegData(compressionQuality: 0.5) else {return}
            formData.append(imageData, withName: "imageFile",fileName: "aaa",mimeType: "image/jpg")
        }, to: url, method: .post, headers: httpHeader)
        .response { response in
            
            if let error = response.error {
                completion(error)
                return
            }
            completion(nil)
            print("Successfully uploaded:", String(data: response.data ?? Data(), encoding: .utf8) ?? "")
        }
    }
    
    func uploadProfile(fullName: String, bio: String, image: UIImage, completion: @escaping (Error?)->Void) {
        let url = String("\(base_url)/profile")
        guard let _ = URL(string: url) else { return }
        
        let headers = ["Content-type": "multipart/form-data","Content-Disposition" : "form-data"]
        let httpHeader = HTTPHeaders(headers)
                                
        AF.upload(multipartFormData: { formData in
                            
            formData.append(Data(fullName.utf8), withName: "fullName")
            formData.append(Data(bio.utf8), withName: "bio")
            
            guard let imageData = image.jpegData(compressionQuality: 0.5) else {return}
            formData.append(imageData, withName: "imageFile",fileName: "aaa",mimeType: "image/jpg")
        }, to: url, method: .post, headers: httpHeader)
//        .uploadProgress(queue: .main) { progress in
//            DispatchQueue.main.async {
//                print("Progress: ", progress.fractionCompleted)
//                print("Progress: ", progress)
//            }
//        }
        .validate(statusCode: 200..<300)
        .response { res in
            
            switch res.result{
            case .failure(let error):
                //print(String(data: res.data ?? Data(), encoding: .utf8) ?? "")
                completion(error)
            case .success(let data):
                print("Profile successfully uploaded:", String(data: data ?? Data(), encoding: .utf8) ?? "")
                completion(nil)
            }
        }
    }
    
    func deleteFromFeed(post: Post, completion: @escaping (Error?)->Void)  {
        guard let url = URL(string: "\(base_url)/feedItem/\(post.id)") else {return}
        
        AF.request(url, method: .delete)
            .validate(statusCode: 200..<300)
            .responseData { resp in
                if let error = resp.error {
                    completion(error)
                    return
                }
                print(String(data: resp.data ?? Data(), encoding: .utf8) ?? "")
                completion(nil)
        }
    }
    
    func likePostFromFeed(post: Post, completion: @escaping (Result<Bool,Error>)->Void) {
                
        let hasLiked = post.hasLiked == true

        let string = hasLiked ? "dislike": "like"
        
        guard let url = URL(string: "\(base_url)/\(string)/\(post.id)") else {return}
        
        AF.request(url, method: .post)
            .validate(statusCode: 200..<300)
            .responseData { resp in
                if let error = resp.error {
                    completion(.failure(error))
                    return
                }
                                                
                print(String(data: resp.data ?? Data(), encoding: .utf8) ?? "")
                completion(.success(!hasLiked))
        }
    }
    
    func fetchLikes(postId: String, completion: @escaping (Result<[Like],Error>)->Void)  {
        guard let url = URL(string: "\(base_url)/likes/\(postId)") else { return }
        
        AF.request(url)
            .validate(statusCode: 200..<300)
            .responseDecodable(of: [Like].self) { dataResp in
                if let error = dataResp.error{
                    completion(.failure(error))
                    return
                }
                                
                completion(.success(dataResp.value ?? []))
            }
    }
    
    func fetchFriends(completion: @escaping (Result<[User],Error>)->Void) {
        guard let url = URL(string: "\(base_url)/friends") else { return }
        
        AF.request(url)
            .validate(statusCode: 200..<300)
            .responseDecodable(of: [User].self) { dataResp in
                if let error = dataResp.error{
                    completion(.failure(error))
                    return
                }
                                
                completion(.success(dataResp.value ?? []))
            }
    }
}
