//
//  HomeViewController.swift
//  HealthKit-MapKit
//
//  Created by Alex Rhodes on 5/3/20.
//  Copyright © 2020 Alex Rhodes. All rights reserved.
//

import UIKit
import HealthKit

class HomeViewController: UIViewController {
    
    private enum ProfileSection: Int {
       case ageSexBloodType
       case weightHeightBMI
       case readHealthKitData
       case saveBMI
     }
     
     private enum ProfileDataError: Error {
       
       case missingBodyMassIndex
       
       var localizedDescription: String {
         switch self {
         case .missingBodyMassIndex:
           return "Unable to calculate body mass index with available profile data."
         }
       }
     }
     
    override func viewDidLoad() {
        super.viewDidLoad()
        authorizeHealthKit()
        updateHealthInfo()
        // Do any additional setup after loading the view.
    }
    
    private let userHealthProfile = UserHealthProfile()
    
    private func updateHealthInfo() {
      loadAndDisplayAgeSexAndBloodType()
      loadAndDisplayMostRecentWeight()
      loadAndDisplayMostRecentHeight()
    }
    
    private func loadAndDisplayAgeSexAndBloodType() {
      do {
        let userAgeSexAndBloodType = try ProfileDataStore.getAgeSexAndBloodType()
        userHealthProfile.age = userAgeSexAndBloodType.age
        userHealthProfile.biologicalSex = userAgeSexAndBloodType.biologicalSex
        userHealthProfile.bloodType = userAgeSexAndBloodType.bloodType
       #warning("update ui")
      } catch let error {
        self.displayAlert(for: error)
      }
    }
    
    private func loadAndDisplayMostRecentHeight() {
      //1. Use HealthKit to create the Height Sample Type
      guard let heightSampleType = HKSampleType.quantityType(forIdentifier: .height) else {
        print("Height Sample Type is no longer available in HealthKit")
        return
      }
          
      ProfileDataStore.getMostRecentSample(for: heightSampleType) { (sample, error) in
            
        guard let sample = sample else {
            
          if let error = error {
            self.displayAlert(for: error)
          }
              
          return
        }
            
        //2. Convert the height sample to meters, save to the profile model,
        //   and update the user interface.
        let heightInMeters = sample.quantity.doubleValue(for: HKUnit.meter())
        self.userHealthProfile.heightInMeters = heightInMeters
        #warning("update ui")
      }
    }
    
    private func loadAndDisplayMostRecentWeight() {
      guard let weightSampleType = HKSampleType.quantityType(forIdentifier: .bodyMass) else {
        print("Body Mass Sample Type is no longer available in HealthKit")
        return
      }
          
      ProfileDataStore.getMostRecentSample(for: weightSampleType) { (sample, error) in
            
        guard let sample = sample else {
              
          if let error = error {
            self.displayAlert(for: error)
          }
          return
        }
            
        let weightInKilograms = sample.quantity.doubleValue(for: HKUnit.gramUnit(with: .kilo))
        self.userHealthProfile.weightInKilograms = weightInKilograms
        #warning("update ui")
        }
    }
    
    private func displayAlert(for error: Error) {
       
       let alert = UIAlertController(title: nil,
                                     message: error.localizedDescription,
                                     preferredStyle: .alert)
       
       alert.addAction(UIAlertAction(title: "O.K.",
                                     style: .default,
                                     handler: nil))
       
       present(alert, animated: true, completion: nil)
     }

    private func authorizeHealthKit() {
      HealthKitSetupAssistant.authorizeHealthKit { (authorized, error) in
            
        guard authorized else {
              
          let baseMessage = "HealthKit Authorization Failed"
              
          if let error = error {
            print("\(baseMessage). Reason: \(error.localizedDescription)")
          } else {
            print(baseMessage)
          }
              
          return
        }
            
        print("HealthKit Successfully Authorized.")
      }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
