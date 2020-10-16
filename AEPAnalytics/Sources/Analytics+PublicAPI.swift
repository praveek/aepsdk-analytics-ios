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

import AEPCore
import AEPServices
import Foundation

/// Defines the public interface for the Analytics extension
@objc public extension Analytics {

    /// Clears all hits from the tracking queue and removes them from the database.
    @objc(clearQueue)
    static func clearQueue() {
        let data  = [AnalyticsConstants.EventDataKeys.CLEAR_HITS_QUEUE: true]
        let event = Event(name: "ClearHitsQueue", type: EventType.analytics, source: EventSource.requestContent, data: data)
        MobileCore.dispatch(event: event)
    }
    /// Retrieves the number of hits currently in the tracking queue
    /// - Parameters:
    ///  - completion: closure invoked with the queue size value
    @objc(getQueueSize:)
    static func getQueueSize(completion: @escaping (Int, AEPError) -> Void) {
        let data  = [AnalyticsConstants.EventDataKeys.GET_QUEUE_SIZE: true]
        let event = Event(name: "GetQueueSize", type: EventType.analytics, source: EventSource.requestContent, data: data)

        MobileCore.dispatch(event: event) { responseEvent in
            guard let responseEvent = responseEvent else {
                completion(0, .callbackTimeout)
                return
            }

            guard let queueSize = responseEvent.data?[AnalyticsConstants.EventDataKeys.QUEUE_SIZE] as? Int else {
                completion(0, .unexpected)
                return
            }
            completion(queueSize, .none)
        }
    }
    /// Forces analytics to send all queued hits regardless of current batch options
    @objc(sendQueuedHits)
    static func sendQueuedHits() {
        let data  = [AnalyticsConstants.EventDataKeys.FORCE_KICK_HITS: true]
        let event = Event(name: "SendQueuedHits", type: EventType.analytics, source: EventSource.requestContent, data: data)
        MobileCore.dispatch(event: event)
    }
    /// Retrieves the analytics tracking identifier.
    /// - Parameters:
    ///  - completion: closure invoked with the analytics identifier value
    @objc(getTrackingIdentifier:)
    static func getTrackingIdentifier(completion: @escaping (String?, AEPError) -> Void) {
        let event = Event(name: "GetTrackingIdentifier", type: EventType.analytics, source: EventSource.requestIdentity, data: nil)

        MobileCore.dispatch(event: event) { responseEvent in
            guard let responseEvent = responseEvent else {
                completion(nil, .callbackTimeout)
                return
            }

            guard let trackingIdentifier = responseEvent.data?[AnalyticsConstants.EventDataKeys.ANALYTICS_ID] as? String else {
                completion(nil, .unexpected)
                return
            }
            completion(trackingIdentifier, .none)
        }
    }
    /// Retrieves the visitor tracking identifier.
    /// - Parameters:
    ///  - completion: closure invoked with the visitor identifier value
    @objc(getVisitorIdentifier:)
    static func getVisitorIdentifier(completion: @escaping (String?, AEPError) -> Void) {
        let event = Event(name: "GetVisitorIdentifier", type: EventType.analytics, source: EventSource.requestIdentity, data: nil)

        MobileCore.dispatch(event: event) { responseEvent in
            guard let responseEvent = responseEvent else {
                completion(nil, .callbackTimeout)
                return
            }

            guard let visitorIdentifier = responseEvent.data?[AnalyticsConstants.EventDataKeys.VISITOR_IDENTIFIER] as? String else {
                completion(nil, .unexpected)
                return
            }
            completion(visitorIdentifier, .none)
        }
    }
    /// Sets the visitor tracking identifier.
    /// - Parameters:
    ///  - visitorIdentifier: new value for visitor identifier
    @objc(setVisitorIdentifier:)
    static func setVisitorIdentifier(visitorIdentifier: String) {
        let data  = [AnalyticsConstants.EventDataKeys.VISITOR_IDENTIFIER: visitorIdentifier]
        let event = Event(name: "SetVisitorIdentifier", type: EventType.analytics, source: EventSource.requestIdentity, data: data)
        MobileCore.dispatch(event: event)
    }
}