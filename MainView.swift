import SwiftUI

// 1. Restaurant Logo View
struct RestaurantLogoView: View {
    var body: some View {
        VStack {
            Image(systemName: "fork.knife.circle.fill")
                .resizable()
                .frame(width: 60, height: 60)
                .foregroundColor(.yellow)
            Text("Little Lemon")
                .font(.title)
                .bold()
        }
    }
}

// 2 & 5. Restaurant Location Model & Dynamic List View
struct RestaurantLocation: Identifiable {
    let id = UUID()
    let city: String
    let address: String
}

struct LocationsView: View {
    let locations = [
        RestaurantLocation(city: "Riyadh", address: "King Fahd Road"),
        RestaurantLocation(city: "Jeddah", address: "Corniche Road"),
        RestaurantLocation(city: "Dammam", address: "Gulf Avenue")
    ]
    
    @State private var isReservationActive: Bool = true
    
    var body: some View {
        NavigationView {
            VStack {
                // Logo View included
                RestaurantLogoView()
                
                // 4. Conditional Text
                Text(isReservationActive ? "Reservations Open" : "Select a Location")
                    .font(.subheadline)
                    .foregroundColor(isReservationActive ? .green : .secondary)
                    .padding(.bottom, 5)
                
                // 5 & 6. Dynamic List with NavigationLink
                List(locations) { location in
                    NavigationLink(destination: ReservationFormView(locationCity: location.city)) {
                        VStack(alignment: .leading) {
                            Text(location.city).font(.headline)
                            Text(location.address).font(.subheadline).foregroundColor(.secondary)
                        }
                    }
                }
            }
            .navigationTitle("Locations")
        }
    }
}

// 3. Main View
struct MainView: View {
    var body: some View {
        TabView {
            LocationsView()
                .tabItem {
                    Label("Locations", systemImage: "map")
                }
        }
    }
}

// 7, 8 & 9. Reservation Form with Validation & Alert
struct ReservationFormView: View {
    let locationCity: String
    
    @State private var customerName: String = ""
    @State private var partyCount: String = ""
    @State private var reservationDate = Date()
    
    @State private var showAlert: Bool = false
    @State private var errorMessage: String = ""
    @State private var isSuccess: Bool = false

    var body: some View {
        Form {
            Section(header: Text("Reservation for \(locationCity)")) {
                TextField("Customer Name", text: $customerName)
                TextField("Party Size", text: $partyCount)
                DatePicker("Date & Time", selection: $reservationDate, in: Date()...)
            }
            
            Section {
                // Button triggering validation
                Button("Confirm Reservation") {
                    validateForm()
                }
            }
        }
        .navigationTitle("Reserve Table")
        // Alert displaying validation messages
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text(isSuccess ? "Success" : "Error"),
                message: Text(errorMessage),
                dismissButton: .default(Text("OK"))
            )
        }
    }
    
    // Validation function
    func validateForm() {
        if customerName.trimmingCharacters(in: .whitespaces).isEmpty {
            errorMessage = "Please enter your name."
            isSuccess = false
            showAlert = true
            return
        }
        
        guard let count = Int(partyCount), count > 0 else {
            errorMessage = "Please enter a valid party size greater than 0."
            isSuccess = false
            showAlert = true
            return
        }
        
        errorMessage = "Your reservation at \(locationCity) for \(count) people is confirmed!"
        isSuccess = true
        showAlert = true
    }
}
