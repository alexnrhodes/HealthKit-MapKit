//
//  DistanceWorkout.swift
//  HealthKit-MapKit
//
//  Created by Alex Rhodes on 5/3/20.
//  Copyright © 2020 Alex Rhodes. All rights reserved.
//

import Foundation

struct DistanceWorkout {
  
  var start: Date
  var end: Date
  
  init(start: Date, end: Date) {
    self.start = start
    self.end = end
  }
  
  var duration: TimeInterval {
    return end.timeIntervalSince(start)
  }
  
  var totalEnergyBurned: Double {
    
    let distanceCaloriesPerHour: Double = 450
    
    let hours: Double = duration/3600
    
    let totalCalories = distanceCaloriesPerHour*hours
    
    return totalCalories
  }
}
