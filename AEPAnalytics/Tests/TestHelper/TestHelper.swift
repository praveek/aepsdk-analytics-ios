/*
 Copyright 2020 Adobe. All rights reserved.
 This file is licensed to you under the Apache License, Version 2.0 (the "License");
 you may not use this file except in compliance with the License. You may obtain a copy
 of the License at http://www.apache.org/licenses/LICENSE-2.0
 Unless required by applicable law or agreed to in writing, software distributed under
 the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR REPRESENTATIONS
 OF ANY KIND, either express or implied. See the License for the specific language
 governing permissions and limitations under the License.
 */

import XCTest
@testable import AEPCore

extension EventHub {
    static func reset() {
        shared = EventHub()
    }
}

extension UserDefaults {
    public static func clear() {
        for _ in 0 ... 5 {
            for key in UserDefaults.standard.dictionaryRepresentation().keys {
                UserDefaults.standard.removeObject(forKey: key)
            }
        }
    }
}
extension FileManager {
    func clearCache() {
        if let _ = self.urls(for: .cachesDirectory, in: .userDomainMask).first {
            do {
                try self.removeItem(at: URL(fileURLWithPath: "Library/Caches/com.adobe.module.identity"))
            } catch {
                print("ERROR DESCRIPTION: \(error)")
            }

            do {
                try self.removeItem(at: URL(fileURLWithPath: "Library/Caches/com.adobe.module.analytics"))
            } catch {
                print("ERROR DESCRIPTION: \(error)")
            }
        }
    }
}

extension Event {
    public func copyWithNewTimeStamp(_ timestamp: Date) -> Event {
        let encoder = JSONEncoder()
        let decoder = JSONDecoder()

        let data = try! encoder.encode(self)
        var json = try! JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
        json?["timestamp"] = timestamp.timeIntervalSinceReferenceDate
        let jsonData = try! JSONSerialization.data(withJSONObject: json as Any, options: .prettyPrinted)

        let newEvent = try! decoder.decode(Event.self, from: jsonData)
        return newEvent
    }
}
