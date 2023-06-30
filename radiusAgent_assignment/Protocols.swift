//
//  Protocols.swift
//  radiusagent
//
//  Created by Kavya Khurana on 30/06/23.
//

import Foundation
import UIKit
import RxSwift

protocol PresenterProtocol: AnyObject {
    var refreshSubj: PublishSubject<Void> { get }
    
    func viewLoaded()
    func getNumberOfSections() -> Int
    func getNumberOfRows(for section: Int) -> Int
    func getCellData(for section: Int) -> [Entity.FacilityOption]
    func getSectionTitle(for section: Int) -> String
    func getExcludedFacilityAndOption(selectedFacilityID: String, selectedOptionID: String) -> [(String, String)]
    func getFacilityID(for element: Int) -> String
    func getOptionID(for section: Int, row: Int) -> String
}


protocol InteractorProtocol: AnyObject {
    var dataSubj: PublishSubject<Entity.APIResponse> { get }
    
    func viewLoaded()
    func getDataFromApi()
}


protocol RouterProtocol: AnyObject {
    
}

