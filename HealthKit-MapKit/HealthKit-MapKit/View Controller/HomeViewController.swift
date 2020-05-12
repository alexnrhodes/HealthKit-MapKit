//
//  HomeViewController.swift
//  HealthKit-MapKit
//
//  Created by Alex Rhodes on 5/3/20.
//  Copyright © 2020 Alex Rhodes. All rights reserved.
//

import UIKit
import HealthKit
import MapKit

class HomeViewController: UIViewController {
    
    var healthDataView: UIView!
    var stepsLabel: UILabel!
    var heightLabel: UILabel!
    var weightLabel: UILabel!
    var bmiLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        authorizeHealthKit()
        buildUI()
        healthDataView.isHidden = true
        updateHealthInfo()
    }
    
    private let userHealthProfile = UserHealthProfile()
    
    private func updateHealthInfo() {
        loadAndDisplayAgeSexAndBloodType()
        loadAndDisplayMostRecentWeight()
        loadAndDisplayMostRecentHeight()
        loadAndDisplaySteps()
        healthDataView.isHidden = false
    }
    
    private func loadAndDisplaySteps() {
        ProfileDataStore.getTodaysSteps { (steps) in
            DispatchQueue.main.async {
                self.stepsLabel.text = "\(steps)"
            }
        }
    }
    
    private func loadAndDisplayAgeSexAndBloodType() {
        do {
            let userAgeSexAndBloodType = try ProfileDataStore.getAgeSexAndBloodType()
            userHealthProfile.age = userAgeSexAndBloodType.age
            userHealthProfile.biologicalSex = userAgeSexAndBloodType.biologicalSex
            userHealthProfile.bloodType = userAgeSexAndBloodType.bloodType
            self.updateLabels()
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
            let heightInMeters = sample.quantity.doubleValue(for: HKUnit.foot())
            self.userHealthProfile.heightInMeters = heightInMeters
            self.updateLabels()
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
            
            let weightInKilograms = sample.quantity.doubleValue(for: HKUnit.pound())
            self.userHealthProfile.weightInKilograms = weightInKilograms
            self.updateLabels()
        }
    }
    
    private func updateLabels() {
        
        if let height = userHealthProfile.heightInMeters {
            heightLabel.text = "\(height)"
        }
        
        if let weight = userHealthProfile.weightInKilograms {
            weightLabel.text = "\(weight)"
        }
        
        if let bmi = userHealthProfile.bodyMassIndex {
            bmiLabel.text = "\(bmi)"
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
    
    // MARK: - UI
    
    func buildUI() {
        buildTopView()
        buildBottomView()
    }
    
    func buildTopView() {
        
        let healthKitDataView = ARGradientView()
        self.healthDataView = healthKitDataView
        healthKitDataView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(healthKitDataView)
        
        healthKitDataView.leadingAnchor.constraint(equalToSystemSpacingAfter: view.leadingAnchor, multiplier: 0).isActive = true
        healthKitDataView.trailingAnchor.constraint(equalToSystemSpacingAfter: view.trailingAnchor, multiplier: 0).isActive = true
        healthKitDataView.topAnchor.constraint(equalToSystemSpacingBelow: view.topAnchor, multiplier: 0).isActive = true
        healthKitDataView.heightAnchor.constraint(equalToConstant: view.frame.height * 0.45).isActive = true
        
        // add labels for pedometer
        
        let stepsLabel = UILabel()
        self.stepsLabel = stepsLabel
        stepsLabel.adjustsFontForContentSizeCategory = true
        stepsLabel.translatesAutoresizingMaskIntoConstraints = false
        stepsLabel.text = "1,000"
        stepsLabel.font = UIFont.systemFont(ofSize: 70, weight: .bold)
        
        healthKitDataView.addSubview(stepsLabel)
        
        stepsLabel.centerXAnchor.constraint(equalTo: healthKitDataView.centerXAnchor).isActive = true
        stepsLabel.centerYAnchor.constraint(equalTo: healthKitDataView.centerYAnchor).isActive = true
        
        // add height weigh and BMI
        
        // create labels for stack view
        let heightView = UIView()
        heightView.backgroundColor = .red
        heightView.translatesAutoresizingMaskIntoConstraints = false
        heightView.layer.cornerRadius = heightView.bounds.width/2
        heightView.clipsToBounds = true
        
        let heightLabel = UILabel()
        self.heightLabel = heightLabel
        heightLabel.adjustsFontForContentSizeCategory = true
        heightLabel.translatesAutoresizingMaskIntoConstraints = false
        heightLabel.text = "5'11"
        heightLabel.font = UIFont.systemFont(ofSize: 25, weight: .regular)
        
        let heightDescriptionLabel = UILabel()
        heightDescriptionLabel.adjustsFontForContentSizeCategory = true
        heightDescriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        heightDescriptionLabel.text = "INCHES"
        heightDescriptionLabel.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        
        let heightStackView = UIStackView(arrangedSubviews: [heightLabel, heightDescriptionLabel])
        heightStackView.translatesAutoresizingMaskIntoConstraints = false
        heightStackView.alignment = .center
        heightStackView.distribution = .equalCentering
        heightStackView.axis = .vertical
        heightStackView.spacing = 4
        
        heightView.addSubview(heightStackView)
        
        heightView.heightAnchor.constraint(greaterThanOrEqualToConstant: 100).isActive = true
        heightView.widthAnchor.constraint(greaterThanOrEqualToConstant: 100).isActive = true

        
        heightStackView.centerYAnchor.constraint(equalTo: heightView.centerYAnchor).isActive = true
        heightStackView.centerXAnchor.constraint(equalTo: heightView.centerXAnchor).isActive = true

        
        
        let weightLabel = UILabel()
        self.weightLabel = weightLabel
        weightLabel.adjustsFontForContentSizeCategory = true
        weightLabel.translatesAutoresizingMaskIntoConstraints = false
        weightLabel.text = "183"
        weightLabel.font = UIFont.systemFont(ofSize: 25, weight: .regular)
        
        let weightDescriptionLabel = UILabel()
        weightDescriptionLabel.adjustsFontForContentSizeCategory = true
        weightDescriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        weightDescriptionLabel.text = "POUNDS"
        weightDescriptionLabel.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        
        let weightStackView = UIStackView(arrangedSubviews: [weightLabel, weightDescriptionLabel])
        weightStackView.translatesAutoresizingMaskIntoConstraints = false
        weightStackView.alignment = .center
        weightStackView.distribution = .equalCentering
        weightStackView.axis = .vertical
        weightStackView.spacing = 4
        
        
        let bmiLabel = UILabel()
        self.bmiLabel = bmiLabel
        bmiLabel.adjustsFontForContentSizeCategory = true
        bmiLabel.translatesAutoresizingMaskIntoConstraints = false
        bmiLabel.text = "25.25"
        bmiLabel.font = UIFont.systemFont(ofSize: 25, weight: .regular)
        
        let bmiDescriptionLabel = UILabel()
        bmiDescriptionLabel.adjustsFontForContentSizeCategory = true
        bmiDescriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        bmiDescriptionLabel.text = "BMI"
        bmiDescriptionLabel.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        
        let bmiStackView = UIStackView(arrangedSubviews: [bmiLabel, bmiDescriptionLabel])
        bmiStackView.translatesAutoresizingMaskIntoConstraints = false
        bmiStackView.alignment = .center
        bmiStackView.distribution = .equalCentering
        bmiStackView.axis = .vertical
        bmiStackView.spacing = 4
        
        // create stackView
        let healthDataStackView = UIStackView(arrangedSubviews: [heightView, weightStackView, bmiStackView])
        healthDataStackView.translatesAutoresizingMaskIntoConstraints = false
        healthDataStackView.alignment = .center
        healthDataStackView.distribution = .equalCentering
        healthDataStackView.axis = .horizontal
        healthDataStackView.spacing = 8
        
        // aspect ratio for height, weight, and bmi view
        
        
        // add stack to view
        healthKitDataView.addSubview(healthDataStackView)
        
        // constrain stack
        healthDataStackView.leadingAnchor.constraint(equalTo: healthKitDataView.leadingAnchor, constant: 30).isActive = true
        healthDataStackView.trailingAnchor.constraint(equalTo: healthKitDataView.trailingAnchor, constant: -30).isActive = true
        healthDataStackView.bottomAnchor.constraint(equalTo: healthKitDataView.bottomAnchor, constant: -30).isActive = true
        
    }
    
    func buildBottomView() {
        
        let mapView = MKMapView()
        mapView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(mapView)
        
        mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        mapView.topAnchor.constraint(equalTo: healthDataView.bottomAnchor).isActive = true
        mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        
        let customBotttomButtonView = ARCustomBottomButtomView()
        customBotttomButtonView.translatesAutoresizingMaskIntoConstraints = false
        customBotttomButtonView.backgroundColor = .clear
        view.addSubview(customBotttomButtonView)
        view.bringSubviewToFront(customBotttomButtonView)
        
        customBotttomButtonView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        customBotttomButtonView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        customBotttomButtonView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        customBotttomButtonView.heightAnchor.constraint(equalToConstant: view.frame.height * 0.15).isActive = true
        
        
        print(customBotttomButtonView.self)
        
    }
}

// Emuns

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
