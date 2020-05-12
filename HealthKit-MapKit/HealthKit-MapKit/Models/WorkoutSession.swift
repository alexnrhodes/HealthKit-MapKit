//
//  WorkoutSession.swift
//  HealthKit-MapKit
//
//  Created by Alex Rhodes on 5/3/20.
//  Copyright © 2020 Alex Rhodes. All rights reserved.
//

import Foundation

enum WorkoutSessionState {
  case notStarted
  case active
  case finished
}

class WorkoutSession {
  
  private (set) var startDate: Date!
  private (set) var endDate: Date!
  
  var state: WorkoutSessionState = .notStarted
  
  func start() {
    startDate = Date()
    state = .active
  }
  
  func end() {
    endDate = Date()
    state = .finished
  }
  
  func clear() {
    startDate = nil
    endDate = nil
    state = .notStarted
  }
  
  var completeWorkout: DistanceWorkout? {
    
    get {
      
      guard state == .finished,
        let startDate = startDate,
        let endDate = endDate else {
          return nil
      }
      
      return DistanceWorkout(start: startDate,
                                end: endDate)
      
    }
    
  }
  
}
