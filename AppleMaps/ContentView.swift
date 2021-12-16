//
//  ContentView.swift
//  AppleMaps
//
//  Created by Hector Vazquez on 12/14/21.
//

import SwiftUI
import MapKit

struct ContentView: View {
    @State private var viewModel = ContentViewModel()
    @State private var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 37.331516, longitude: -121.891054), span: MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.1))
    
    var body: some View {
        Map(coordinateRegion: $region).ignoresSafeArea()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

final class ContentViewModel : NSObject, ObservableObject , CLLocationManagerDelegate
                                                            //CLLocationManagerDelegate listens to chnages with settings if location is ever turned off, not sure about NSObject
{
    var locationManager : CLLocationManager?                //locationManger is of type CLLlocationManager, ? means that it is optional.
    
    func checkIfLocationisEnabled ()                        //func to check location is enabled
    {
        if CLLocationManager.locationServicesEnabled()      //if statement to check if the locaiton is enabled and if so set locationManger to CLLlocationManager. LocationServices returns a bool value
        {
            locationManager = CLLocationManager()           //creating a locations manager, once this is created it makes a call to locationManagerDidChangeAuthorization Automatically 
            //locationManager?.desiredAccuracy = kCLLocationAccuracyBest     this depends on what you're application is using user location for
        }
        else
        {
            print ("location services are off")
        }
    }
    
    //now check if our app has permission to use the users location
    //1.ask for permission
    //2.might already have permission
    //3.restricted.
     
    func checkApplicationAuthorization()
    {
        guard let locationManager = locationManager else {return}       //since locationManager is optional in line 28 we must unwrap it

        
        switch locationManager.authorizationStatus{
            
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            print("You locaiton is resticted likely due to parental controls")
        case .denied:
            print ("You have denied current location for this application, open setting to change it ")
        case .authorizedAlways:
            break
        case .authorizedWhenInUse:
            break
        @unknown default:
            break
        }
        
        
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkApplicationAuthorization()
        
        //The system calls the delegate’s locationManagerDidChangeAuthorization(_:) method immediately when you create a location manager, and again when the app’s authorization changes. The delegate handles all location and heading-related updates and events.

    }
    
    
}
