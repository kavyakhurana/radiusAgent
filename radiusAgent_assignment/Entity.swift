//
//  Entity.swift
//  radiusagent
//
//  Created by Kavya Khurana on 30/06/23.
//

import Foundation

struct Entity {
    
    struct FacilityOption: Codable {
        let name: String
        let icon: String
        let id: String
    }

    struct Facility: Codable {
        let facilityID: String
        let name: String
        let options: [FacilityOption]

        enum CodingKeys: String, CodingKey {
            case facilityID = "facility_id"
            case name
            case options
        }
    }

    struct Exclusion: Codable {
        let facilityID: String
        let optionsID: String

        enum CodingKeys: String, CodingKey {
            case facilityID = "facility_id"
            case optionsID = "options_id"
        }
    }

    struct APIResponse: Codable {
        let facilities: [Facility]
        let exclusions: [[Exclusion]]

        enum CodingKeys: String, CodingKey {
            case facilities
            case exclusions
        }
    }

    
}
