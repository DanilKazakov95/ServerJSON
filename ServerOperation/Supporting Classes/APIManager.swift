//
//  APIManager.swift
//  ServerOperation
//
//  Created by Данил Казаков on 25/11/2018.
//  Copyright © 2018 Danil Moguchiy. All rights reserved.
//

import Foundation
class APIManager: NSObject {
    
    let baseURL = "https://jsonplaceholder.typicode.com"
    
    static let sharedInstance = APIManager()
    static let getPostsEndPointForUsers = "/users/"
    static let getPostEndPointForAlbums = "/albums?userId="
    static let getPostEndPointForPhotos = "/photos?albumId="
    static let getPostEndPointForTasks = "/posts?userId="
    static let getPostEndPointForNewTask = "/posts"
    
    func getPostWithIdForUsers(postId: Int, onSuccess: @escaping(Data) -> Void, onFailure: @escaping(Error) -> Void) {
        let url : String = baseURL + APIManager.getPostsEndPointForUsers + String(postId)
        let request: NSMutableURLRequest = NSMutableURLRequest(url: NSURL(string: url)! as URL)
        request.httpMethod = "GET"
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest, completionHandler: {data, response, error -> Void in
            if(error != nil){
                onFailure(error!)
            } else{
//                let result = try? JSON(data: data!)
                onSuccess(data!)
            }
        })
        task.resume()
    }
    
    func getPostWithIdForAlbums(postId: Int, onSuccess: @escaping(Data) -> Void, onFailure: @escaping(Error) -> Void) {
        let url : String = baseURL + APIManager.getPostEndPointForAlbums + String(postId)
        let request: NSMutableURLRequest = NSMutableURLRequest(url: NSURL(string: url)! as URL)
        request.httpMethod = "GET"
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest, completionHandler: {data, response, error -> Void in
            if(error != nil){
                onFailure(error!)
            } else{
                onSuccess(data!)
            }
        })
        task.resume()
    }
    
    func getPostForPhotos(postId: Int, onSuccess: @escaping(Data) -> Void, onFailure: @escaping(Error) -> Void) {
        let url : String = baseURL + APIManager.getPostEndPointForPhotos + String(postId)
        let request: NSMutableURLRequest = NSMutableURLRequest(url: NSURL(string: url)! as URL)
        request.httpMethod = "GET"
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest, completionHandler: {data, response, error -> Void in
            if(error != nil){
                onFailure(error!)
            } else{
                onSuccess(data!)
            }
        })
        task.resume()
    }
    
    func getPostForTasks(postId: Int, onSuccess: @escaping(Data) -> Void, onFailure: @escaping(Error) -> Void) {
        let url : String = baseURL + APIManager.getPostEndPointForTasks + String(postId)
        let request: NSMutableURLRequest = NSMutableURLRequest(url: NSURL(string: url)! as URL)
        request.httpMethod = "GET"
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest, completionHandler: {data, response, error -> Void in
            if(error != nil){
                onFailure(error!)
            } else{
                onSuccess(data!)
            }
        })
        task.resume()
    }
}
