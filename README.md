# SURGO — Flutter Local Transportation & Vehicle Rental Platform

SurGo is a **Flutter-based prototype** of a local transportation and vehicle rental platform designed for Tandag City, Surigao del Sur. The application combines passenger ride booking, rider operations, vehicle rentals, and assisted booking into a single mobile platform.

Unlike a traditional ride-hailing prototype with separate driver and passenger accounts, SurGo uses **one unified user identity** that can switch between three modes: **Passenger, Rider, and Vehicle Owner**.

The current application uses **mock JSON data and local application state** to simulate users, riders, passengers, vehicles, ride requests, rental requests, vehicle documents, and Tandag City locations. The project is currently focused on demonstrating the application's user interface, navigation, workflows, and map experience before connecting it to a production backend.

## Screens and Features Included

### Passenger Mode

Home → Activity → Wallet → Profile

Passenger Mode includes:

- Automatic location detection
- Nearby rider discovery
- Pickup location
- Destination selection
- Barangay selection
- Purok selection
- Motorcycle and tricycle selection
- Fare estimation
- Distance estimation
- ETA estimation
- Ride request
- Nearby/nearest rider matching
- Rider information
- Rider rating
- Active ride
- Ride completion
- Ride history
- Trip rating
- Rental vehicle browsing
- Rental vehicle details
- Rental requests
- Assisted Booking / Book for Someone

### Rider Mode

Home → Trips → Earnings → Profile

Rider Mode includes:

- Online / Offline status
- Incoming ride requests
- Expandable ride request cards
- Passenger information
- Pickup information
- Destination information
- Payment information
- Passenger rating
- Accept ride request
- Reject ride request
- Active Ride section
- Start ride
- Complete ride
- Ride history
- Trip information
- Earnings
- Rider ratings
- Vehicle documents
- Map view with passenger locations

### Vehicle Owner Mode

Home → Bookings → Earnings → Profile

Vehicle Owner Mode includes:

- Vehicle owner dashboard
- Owned vehicle list
- Vehicle information
- Vehicle photos
- Vehicle documents
- Document verification status
- Rental pricing
- Rental availability
- Rental booking requests
- Accept / manage rental requests
- Active rentals
- Rental earnings
- Rental history
- Map view with rental vehicles

## User Account

SurGo uses a **single account** that can operate in multiple modes.

Current prototype user:

**Jr Derigay**

```text
Jr Derigay
│
├── Passenger Mode
│
├── Rider Mode
│
└── Vehicle Owner Mode