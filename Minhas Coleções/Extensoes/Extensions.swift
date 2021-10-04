//
//  Extensions.swift
//  Minhas Coleções
//
//  Created by Natalia da Rosa on 27/09/2021.
//

import Foundation

extension UserDefaults {
    
    func set<T>(encodable: T?, forKey key: String) throws where T : Encodable {
        do {
            let data = try JSONEncoder().encode(encodable)
            UserDefaults.standard.set(data, forKey: key)
            UserDefaults.standard.synchronize()
        } catch {
            print("Error saving encodable to user defaults: \(error)")
            throw error
        }
    }
    
    func decodable<T>(forKey key: String, as decodable:T.Type) -> T? where T : Decodable {
        if let data = UserDefaults.standard.value(forKey: key) as? Data {
            do {
                return try JSONDecoder().decode(decodable, from: data)
            } catch {
                print("Error recovering decodable from user defaults: \(error)")
            }
        }
        return nil
    }
}
