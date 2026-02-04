 bool _isMountainArea(double latitude, double longitude) {
    // 🛡️ LEVEL 1: GLOBAL PLAIN EXCLUSION (Safety Filter)
    // Anything below this latitude in North India is definitely the plains.
    // Chandigarh Airport is ~30.67, so we set the floor at 30.85 to be safe.
    if (latitude < 30.85 && longitude < 77.2) return false;

    // 🏔️ HIMACHAL PRADESH & KASHMIR
    // Includes: Shimla, Manali, Dharamshala, Leh, Srinagar, Gulmarg, etc.
    if (latitude >= 30.5 && latitude <= 37.0 && 
        longitude >= 74.0 && longitude <= 79.5) {
      
      // Amritsar, Jalandhar, Ludhiana plains
      if (latitude < 32.0 && longitude < 75.8) return false;
      
      // Chandigarh, Mohali, Zirakpur & Airport Area
      // The Shivalik hills start around 30.85+ N or 77.0+ E
      if (latitude < 30.95 && longitude < 77.0) return false;
      
      return true;
    }
    
    // 🏔️ UTTARAKHAND
    // Includes: Mussoorie, Nainital, Rishikesh (Hilly parts), etc.
    if (latitude >= 28.8 && latitude <= 31.5 && 
        longitude >= 77.5 && longitude <= 81.5) {
      // Exclude plains of Haridwar (29.9), Rishikesh plains (30.0), Haldwani (29.2)
      if (latitude < 30.1 && longitude < 78.4) return false;
      return true;
    }

    // 🏔️ NORTH EAST INDIA (Sikkim, Meghalaya, etc.)
    if (latitude >= 23.0 && latitude <= 29.5 && 
        longitude >= 88.0 && longitude <= 97.5) {
      // Exclude Guwahati plains if possible
      if (latitude > 26.0 && latitude < 26.5 && longitude > 91.5 && longitude < 92.0) return false;
      return true;
    }

    // 🏔️ WESTERN GHATS (Mahabaleshwar, Lonavala, Munnar, etc.)
    // Mahabaleshwar (17.9, 73.6), Munnar (10.0, 77.0), Ooty (11.4, 76.7)
    // Checking specific pockets for expansion
    
    // Maharashtra Hills
    if (latitude >= 17.5 && latitude <= 19.5 && longitude >= 73.2 && longitude <= 74.0) return true;
    
    // South India Hills (Ooty/Munnar/Kodai)
    if (latitude >= 8.5 && latitude <= 12.0 && longitude >= 76.0 && longitude <= 77.8) return true;

    return false;
  }

  // Calculate fare based on distance, duration, car type with Uber-like pricing
  // Uber pricing model: Base fare + (Per km rate * distance) + (Per minute rate * time)
  double calculateFare(
    double distanceInKm,
    String carType, {
    double durationInMinutes = 0.0,
    LocationModel? pickupLocation,
    LocationModel? dropoffLocation,
    List<LatLng>? routePoints,
  }) {
    // 🛡️ 3-Level Verification for Mountain Surcharge (Industry Standard)
    bool isMountainRoute = false;
    
    // Level 1: Point-of-Interest (POI) & Terminal Check
    bool pickupInMountain = pickupLocation != null && _isMountainArea(pickupLocation.latitude, pickupLocation.longitude);
    bool dropoffInMountain = dropoffLocation != null && _isMountainArea(dropoffLocation.latitude, dropoffLocation.longitude);
    
    // Level 2: Intelligent Route Sampling
    int mountainPointCount = 0;
    int totalSamples = 0;
    
    if (routePoints != null && routePoints.isNotEmpty) {
      // Sample more points for higher accuracy
      int step = (routePoints.length / 20).clamp(1, 50).toInt();
      for (int i = 0; i < routePoints.length; i += step) {
        totalSamples++;
        if (_isMountainArea(routePoints[i].latitude, routePoints[i].longitude)) {
          mountainPointCount++;
        }
      }
    }

    // Level 3: Confidence Score & Final Confirmation
    // A route is only "Mountain" if:
    // 1. Both terminals are in mountain (100% confidence)
    // 2. Either terminal is in mountain AND at least 30% of route is mountain
    // 3. Neither terminal is in mountain BUT > 60% of the route is mountain (Transit through hills)
    
    double mountainConfidence = totalSamples > 0 ? (mountainPointCount / totalSamples) : 0;
    
    if (pickupInMountain && dropoffInMountain) {
      isMountainRoute = true;
    } else if ((pickupInMountain || dropoffInMountain) && mountainConfidence > 0.3) {
      isMountainRoute = true;
    } else if (mountainConfidence > 0.6) {
      isMountainRoute = true;
    }

    // Uber-like pricing structure: Base fare + (per km * distance) + (per minute * time)
    double baseFare = 0.0;
    double perKmRate = 0.0;
    double perMinuteRate = 0.0;

    // Set pricing based on vehicle type (Uber-like rates in INR)
    switch (carType) {
      case 'bike':
        baseFare = 25.0;
        perKmRate = 5.0;
        perMinuteRate = 0.5;
        break;
      case 'auto':
        baseFare = 40.0;
        perKmRate = 8.0;
        perMinuteRate = 0.75;
        break;
      case 'mini':
        baseFare = 50.0;
        // Tiered pricing for Mini (Hatchback)
        if (distanceInKm <= 100) {
          perKmRate = 15.0;
        } else if (distanceInKm <= 300) {
          perKmRate = 14.0;
        } else {
          perKmRate = 12.0;
        }
        perMinuteRate = 0.8;
        break;
      case 'sedan':
        baseFare = 60.0;
        // Tiered pricing for Sedan (Plain area)
        if (distanceInKm <= 150) {
          perKmRate = 20.0;
        } else if (distanceInKm <= 400) {
          perKmRate = 18.0;
        } else if (distanceInKm <= 500) {
          perKmRate = 16.0;
        } else {
          perKmRate = 15.0;
        }
        perMinuteRate = 0.0;
        break;
      case 'suv':
        baseFare = 70.0;
        // Tiered pricing for SUV (Plain area)
        if (distanceInKm <= 100) {
          perKmRate = 26.0;
        } else if (distanceInKm <= 300) {
          perKmRate = 28.5;
        } else if (distanceInKm <= 500) {
          perKmRate = 27.5;
        } else {
          perKmRate = 20.0;
        }
        perMinuteRate = 0.0;
        break;
      default:
        // Default to sedan pricing
        baseFare = 60.0;
        perKmRate = 12.0;
        perMinuteRate = 1.0;
    }

    // Calculate fare: Base + (Distance * Per Km) + (Time * Per Minute)
    double distanceFare = distanceInKm * perKmRate;
    double timeFare = durationInMinutes * perMinuteRate;
    double totalFare = baseFare + distanceFare + timeFare;

    // Apply mountain/hilly area surcharge for sedans and SUVs
    if (isMountainRoute) {
      if (carType == 'mini') {
        // Add ₹7 per km for sedans in hilly areas (on top of tiered base)
        double mountainSurcharge = distanceInKm * 5.0;
        totalFare = totalFare + mountainSurcharge;
      }
      else if (carType == 'sedan') {
        // Add ₹7 per km for sedans in hilly areas (on top of tiered base)
        double mountainSurcharge = distanceInKm * 5.5;
        totalFare = totalFare + mountainSurcharge;
      } else if (carType == 'suv') {
        // Add ₹16 per km for SUVs in hilly areas (on top of tiered base)
        double mountainSurcharge = distanceInKm * 10.5;
        totalFare = totalFare + mountainSurcharge;
      } else {
        // For bike, auto, mini, apply 20% multiplier
        totalFare = totalFare * 1.2;
      }
    }

    // Minimum fare guarantee
    double minimumFare = baseFare * 1.5;
    if (totalFare < minimumFare) {
      totalFare = minimumFare;
    }

    return totalFare;
  }
