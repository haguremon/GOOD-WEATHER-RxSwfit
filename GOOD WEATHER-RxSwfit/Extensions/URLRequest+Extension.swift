//
//  URLRequest+Extension.swift
//  GOOD WEATHER-RxSwfit
//
//  Created by IwasakIYuta on 2022/01/14.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

struct Resource<T> {
    let url: URL
}

extension URLRequest  {
    
    
    static func load<T: Decodable>(resource: Resource<T>) -> Observable<T> {
        
        return Observable.just(resource.url)
            .flatMap { url -> Observable<(response: HTTPURLResponse, data: Data)> in
                // Observable<(response: HTTPURLResponse, data: Data)でresponseとデータにアクセスする
               
                let request = URLRequest(url: url)
                return URLSession.shared.rx.response(request: request)
                /*
                 func response(request: URLRequest) -> Observable<(response: HTTPURLResponse, data: Data)>
                 */
            
            }.map { response, data -> T in
                //通信エラーの処理を追加
                if 200..<300 ~= response.statusCode {
                    return try JSONDecoder().decode(T.self, from: data)
                } else {
                    //エラーをキャッチできるよになる
                    throw RxCocoaURLError.httpRequestFailed(response: response, data: data)
                
                }
            
            }.asObservable()
    }
    
    /*
    //ジェネリック関数を使って柔軟に対応 //サブスク可能なDecodableを継承してるObservableを返す
    static func load<T: Decodable>(resource: Resource<T>) -> Observable<T> {
        
        return Observable.from([resource.url])
            .flatMap { url -> Observable<Data> in
               
                let request = URLRequest(url: url)
                return URLSession.shared.rx.data(request: request)
            
            }.map { data -> T in
                
                return try JSONDecoder().decode(T.self, from: data)
            
            }.asObservable()
    }
    */
}
