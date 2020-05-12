//
//  ProfileDataStore.swift
//  HealthKit-MapKit
//
//  Created by Alex Rhodes on 5/3/20.
//  Copyright © 2020 Alex Rhodes. All rights reserved.
//

import HealthKit

class ProfileDataStore {
  
    class func getAgeSexAndBloodType() throws -> (age: Int,
                                                  biologicalSex: HKBiologicalSex,
                                                  bloodType: HKBloodType) {
                                                    
        let healthKitStore = HKHealthStore()
                                                   
      do {

        //1. This method throws an error if these data are not available.
        let birthdayComponents =  try healthKitStore.dateOfBirthComponents()
        let biologicalSex =       try healthKitStore.biologicalSex()
        let bloodType =           try healthKitStore.bloodType()
          
        //2. Use Calendar to calculate age.
        let today = Date()
        let calendar = Calendar.current
        let todayDateComponents = calendar.dateComponents([.year],
                                                            from: today)
        let thisYear = todayDateComponents.year!
        let age = thisYear - birthdayComponents.year!
         
        //3. Unwrap the wrappers to get the underlying enum values.
        let unwrappedBiologicalSex = biologicalSex.biologicalSex
        let unwrappedBloodType = bloodType.bloodType
          
        return (age, unwrappedBiologicalSex, unwrappedBloodType)
      }
    }
    
    class func getMostRecentSample(for sampleType: HKSampleType,
                                   completion: @escaping (HKQuantitySample?, Error?) -> Swift.Void) {
      
    //1. Use HKQuery to load the most recent samples.
    let mostRecentPredicate = HKQuery.predicateForSamples(withStart: Date.distantPast,
                                                          end: Date(),
                                                          options: .strictEndDate)
        
    let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate,
                                          ascending: false)
        
    let limit = 1
        
    let sampleQuery = HKSampleQuery(sampleType: sampleType,
                                    predicate: mostRecentPredicate,
                                    limit: limit,
                                    sortDescriptors: [sortDescriptor]) { (query, samples, error) in
        
        //2. Always dispatch to the main thread when complete.
        DispatchQueue.main.async {
            
          guard let samples = samples,
                let mostRecentSample = samples.first as? HKQuantitySample else {
                    
                completion(nil, error)
                return
          }
            
          completion(mostRecentSample, nil)
        }
      }
     
    HKHealthStore().execute(sampleQuery)
    }
    
    class func getTodaysSteps(completion: @escaping (Double) -> Void) {
        
        let healthKitStore = HKHealthStore()
        let stepsQuantityType = HKQuantityType.quantityType(forIdentifier: .stepCount)!

        let now = Date()
        let startOfDay = Calendar.current.startOfDay(for: now)
        let predicate = HKQuery.predicateForSamples(withStart: startOfDay, end: now, options: .strictStartDate)

        let query = HKStatisticsQuery(quantityType: stepsQuantityType, quantitySamplePredicate: predicate, options: .cumulativeSum) { _, result, _ in
            guard let result = result, let sum = result.sumQuantity() else {
                completion(0.0)
                return
            }
            completion(sum.doubleValue(for: HKUnit.count()))
            print(result)
        }

        healthKitStore.execute(query)
    }
    
    class func saveBodyMassIndexSample(bodyMassIndex: Double, date: Date) {
      
      //1.  Make sure the body mass type exists
      guard let bodyMassIndexType = HKQuantityType.quantityType(forIdentifier: .bodyMassIndex) else {
        fatalError("Body Mass Index Type is no longer available in HealthKit")
      }
        
      //2.  Use the Count HKUnit to create a body mass quantity
      let bodyMassQuantity = HKQuantity(unit: HKUnit.count(),
                                        doubleValue: bodyMassIndex)
        
      let bodyMassIndexSample = HKQuantitySample(type: bodyMassIndexType,
                                                 quantity: bodyMassQuantity,
                                                 start: date,
                                                 end: date)
        
      //3.  Save the same to HealthKit
      HKHealthStore().save(bodyMassIndexSample) { (success, error) in
          
        if let error = error {
          print("Error Saving BMI Sample: \(error.localizedDescription)")
        } else {
          print("Successfully saved BMI Sample")
        }
      }
    }
}

