//
//  Presenter.swift
//  radiusagent
//
//  Created by Kavya Khurana on 30/06/23.
//

import Foundation
import RxSwift

class Presenter: PresenterProtocol {
    
    var refreshSubj = PublishSubject<Void>()
    
    var dataSource: Entity.APIResponse?
    
    var interactor: InteractorProtocol?
    let disposeBag = DisposeBag()
    
    init(interactor: InteractorProtocol) {
        self.interactor = interactor
    }
    
    func viewLoaded() {
        subscribeObservables()
        interactor?.viewLoaded()
    }
    
    func subscribeObservables() {
        interactor?.dataSubj.subscribe(onNext: { [weak self] response in
            self?.dataSource = response
            self?.refreshSubj.onNext(())
        }).disposed(by: disposeBag)
    }
    
    func getNumberOfSections() -> Int {
        return dataSource?.facilities.count ?? 0
    }
    
    func getNumberOfRows(for section: Int) -> Int {
        if let facility = dataSource?.facilities.first(where: { $0.facilityID == "\(section + 1)" }) {
            return facility.options.count
        }
        return 0
    }
    
    func getSectionTitle(for section: Int) -> String {
        return dataSource?.facilities[section].name ?? ""
    }
    
    func getCellData(for section: Int) -> [Entity.FacilityOption] {
        return dataSource?.facilities[section].options ?? []
    }
    
    
    func getExcludedFacilityAndOption(selectedFacilityID: String, selectedOptionID: String) -> [(String, String)] {
        var excludedPairs: [(String, String)] = []
        
        guard let exclusions = dataSource?.exclusions else { return [] }
        
        for exclusion in exclusions {
            let selectedFacilityExclusion = exclusion.first { $0.facilityID == selectedFacilityID }
            if let selectedFacilityExclusion = selectedFacilityExclusion {
                let selectedExclusionOptionID = selectedFacilityExclusion.optionsID
                if selectedExclusionOptionID == selectedOptionID {
                    let otherExclusions = exclusion.filter { $0.facilityID != selectedFacilityID }
                    let excludedFacilityAndOptionPairs = otherExclusions.map { ($0.facilityID, $0.optionsID) }
                    excludedPairs.append(contentsOf: excludedFacilityAndOptionPairs)
                }
            }
        }
        
        return excludedPairs
    }
    
    func getFacilityID(for element: Int) -> String {
        return "\(element + 1)"
    }
    
    func getOptionID(for section: Int, row: Int) -> String {
        guard let sections = dataSource?.facilities,
              section < sections.count else {
            return ""
        }
        
        let sectionData = sections[section].options
        guard row < sectionData.count else {
            return ""
        }
        
        let rowData = sectionData[row]
        return rowData.id
    }
    
}
