//
//  Taskable+Combine.swift
//  TaskKit
//
//  Created by Tadashi.Chiu on 2020/07/13.
//

import Foundation
import Combine

@available(iOS 13.0, macOS 10.15, tvOS 13.0, *)
extension Taskable {
    typealias Publisher = Publishers.Task.RequestPublisher<Self>
    func request(for request: TaskRequest) -> Publisher {
        return Publisher(request: request, task: self)
    }
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, *)
extension Publishers.Task {
    struct RequestPublisher<T: Taskable>: Publisher {
        typealias Output = T.TaskValue
        typealias Failure = T.TaskError
        
        private typealias Subscription = Subscriptions.Task.RequestSubscription
        
        private let request: T.TaskRequest
        private let task: T
        
        init(request: T.TaskRequest, task: T) {
            self.request = request
            self.task = task
        }
        
        func receive<S: Subscriber>(subscriber: S) where
            Failure == S.Failure, Output == S.Input {
                let subscription = Subscription(request: request,
                                                subscriber: subscriber,
                                                task: task)
                subscriber.receive(subscription: subscription)
        }
    }
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, *)
extension Subscriptions.Task {
    class RequestSubscription<Input, Output, Failure: Error>: Subscription {
        private let task: AnyTask<Input, Output, Failure>
        private let request: Input
        private var subscriber: AnySubscriber<Output, Failure>?
        
        init<S: Subscriber, T: Taskable>(request: T.TaskRequest, subscriber: S, task: T) where S.Input == Output, S.Failure == Failure, T.TaskRequest == Input, T.TaskValue == Output, T.TaskError == Failure {
            self.request = request
            self.subscriber = AnySubscriber(subscriber)
            self.task = task.asTask()
        }
        
        func request(_ demand: Subscribers.Demand) {
            sendRequest()
        }
        
        func cancel() {
            subscriber = nil
        }
        
        private func sendRequest() {
            guard let subscriber = subscriber else { return }
            task.request(request) {
                switch $0 {
                case .success(let value):
                    subscriber.receive(value)
                    subscriber.receive(completion: .finished)
                case .failure(let error):
                    subscriber.receive(completion: .failure(error))
                }
            }
        }
    }
}
