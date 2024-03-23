import MapKit
import SwiftUI

public extension MKPointOfInterestCategory {
    /// Image of MKPointOfInterestCategory
    var image: Image {
        switch self {
        case .airport:
            return Image(.unknown)

        case .amusementPark:
            return Image(.unknown)

        case .aquarium:
            return Image(.unknown)

        case .atm:
            return Image(.atm)

        case .bakery:
            return Image(.bakery)

        case .bank:
            return Image(.bank)

        case .beach:
            return Image(.unknown)

        case .brewery:
            return Image(.unknown)

        case .cafe:
            return Image(.cafe)

        case .campground:
            return Image(.unknown)

        case .carRental:
            return Image(.carRental)

        case .evCharger:
            return Image(.unknown)

        case .fireStation:
            return Image(.fireStation)

        case .fitnessCenter:
            return Image(.fitnessCenter)

        case .foodMarket:
            return Image(.foodMarket)

        case .gasStation:
            return Image(.gasStation)

        case .hospital:
            return Image(.hospital)

        case .hotel:
            return Image(.hotel)

        case .laundry:
            return Image(.laundry)

        case .library:
            return Image(.library)

        case .marina:
            return Image(.unknown)

        case .movieTheater:
            return Image(.movieTheater)

        case .museum:
            return Image(.museum)

        case .nationalPark:
            return Image(.unknown)

        case .nightlife:
            return Image(.unknown)

        case .park:
            return Image(.park)

        case .parking:
            return Image(.parking)

        case .pharmacy:
            return Image(.pharmacy)

        case .police:
            return Image(.police)

        case .postOffice:
            return Image(.unknown)

        case .publicTransport:
            return Image(.publicTransport)

        case .restaurant:
            return Image(.restaurant)

        case .restroom:
            return Image(.restroom)

        case .school:
            return Image(.school)

        case .stadium:
            return Image(.unknown)

        case .store:
            return Image(.store)

        case .theater:
            return Image(.unknown)

        case .university:
            return Image(.university)

        case .winery:
            return Image(.unknown)

        case .zoo:
            return Image(.unknown)

        default:
            return Image(.unknown)
        }
    }
}
