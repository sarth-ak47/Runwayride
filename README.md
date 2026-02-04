🚕 RUNWAYRIDE
A Full-Stack Ride Hailing Platform (Customer App + Driver App + Pricing Engine)

RUNWAYRIDE is a production-oriented ride-hailing platform inspired by Ola, Uber, and Rapido.
It demonstrates end-to-end system design, including customer booking, driver operations, live tracking, payments, and a terrain-aware pricing engine.

This repository focuses on architecture, APIs, and business logic, which are the hardest and most critical parts of ride-hailing systems.

🧠 What Makes RUNWAYRIDE Different

Most demo projects show screens.
RUNWAYRIDE shows how real ride-hailing systems actually work:

Two independent mobile apps (Customer & Driver)

Real-time location tracking

Server-driven pricing & matching

Terrain-aware fare calculation

Payment & referral workflows

Scalable backend design

🏗️ High-Level System Architecture
                ┌──────────────────┐
                │   Customer App   │
                │ (Flutter / iOS)  │
                └────────┬─────────┘
                         │
                         ▼
                ┌──────────────────┐
                │   Backend APIs   │
                │ (Auth, Rides,    │
                │  Pricing, Maps)  │
                └────────┬─────────┘
                         │
        ┌────────────────┼────────────────┐
        ▼                ▼                ▼
 Pricing Engine   Real-Time Tracking   Payment Service
 (This Repo)      (Sockets / DB)       (Razorpay)
        ▲
        │
┌───────────────┐
│  Driver App   │
│ (Flutter)     │
└───────────────┘

📱 1️⃣ Customer Application (Rider App)

The Customer App is responsible for ride discovery, booking, and payment.

🔹 Core Features

📍 Google Maps SDK integration

🧭 Pickup & drop selection with autocomplete

🛣️ Route & ETA calculation

💰 Real-time fare estimation (server driven)

🚕 Driver matching & ride lifecycle

📡 Live ride tracking

💳 Online payments

🔔 Notifications (ride status)

🔹 APIs & Services Used

Google Maps & Directions API

Backend REST APIs

Firebase Authentication

Firestore / Cloud Database

Push Notifications

🚗 2️⃣ Driver Application

The Driver App is a completely separate system with different responsibilities.

🔹 Core Features

🔐 Driver authentication & onboarding

🟢 Online / Offline availability

📍 Live GPS location streaming

🚦 Ride accept / reject workflow

🧭 Turn-by-turn navigation

💸 Earnings & payout tracking

👥 Referral & incentive system

🔹 Real-Time Location Tracking

Driver location updates pushed at intervals

Backend broadcasts updates to customer app

Optimized to reduce battery & data usage

💳 3️⃣ Payments & Earnings
Razorpay Integration

Secure online payments

Ride-based transaction handling

Payment verification via backend

Refund & cancellation handling

Driver Earnings Logic

Gross fare

Platform commission

Incentives / referrals

Net payout calculation

🏔️ 4️⃣ Pricing Engine (Core Highlight)

The pricing engine is the heart of RUNWAYRIDE and is the only publicly exposed code in this repository.

Why pricing is isolated

In real systems, pricing is:

Shared across apps

Security-sensitive

Business-critical

Independently scalable

🔍 Pricing Intelligence Layers

RUNWAYRIDE uses multi-layer pricing intelligence, inspired by real Ola/Uber systems.

1️⃣ Latitude–Longitude Zoning

Classifies region as:

Plain

Hill

Mountain

High Mountain

This decides base pricing rules.

2️⃣ Route Awareness (Pickup → Drop)

Pricing is based on the worst terrain involved

Prevents underpricing long hill routes

3️⃣ Time & Speed Bias

Hilly routes rely more on time-based pricing

Low average speed increases effective fare

💰 Fare Calculation Model
Fare =
  Base Fare
+ (Distance × Per-Km Rate)
+ (Duration × Per-Minute Rate)
× Terrain Multiplier
× Surge Multiplier


No visible “hill charge” — pricing adjustments are internal.

📐 Terrain Multipliers (Example)
Terrain	Multiplier
Plain	1.00×
Hill	1.10×
Mountain	1.18×
High Mountain	1.30×

These simulate:

Fuel consumption

Driver fatigue

Time delay

Vehicle wear

📄 Fare Schema File (Public)

This repository includes the fare schema file, which defines:

Vehicle-wise base fares

Distance & time rates

Terrain multipliers

Minimum fare rules

Surge compatibility

The schema is:

Config-driven

Extendable

Production-ready

🧪 Sample Scenario

SUV Ride – Mountain Route

Distance: 140 km

Duration: 360 minutes

Terrain: Mountain

Base Fare: ₹80
Distance Fare: ₹22 × 140
Time Fare: ₹1.1 × 360
Terrain Multiplier: 1.18×

Final Fare ≈ ₹2,600+

🧩 Edge Cases Covered

Minimum fare enforcement

Long outstation rides

Mixed terrain routes

Low-speed hill driving

Surge & peak demand

Ride cancellation scenarios

🔐 Security & Safety Considerations

No API keys exposed

No production credentials

Server-side pricing authority

Client apps act as thin layers

🚀 Scalability Considerations

Pricing engine can be moved to microservice

City / region pricing via config

Compatible with ML-based ETA systems

Can integrate elevation APIs

🔮 Planned Enhancements

Elevation-based terrain scoring

ML ETA prediction

Admin pricing dashboard

Dynamic driver incentives

Heat-map based surge pricing

⚠️ Disclaimer

RUNWAYRIDE is a personal engineering project built for learning and demonstration.
It is not affiliated with Ola, Uber, Rapido, or any commercial ride-hailing platform.

👨‍💻 Author

Your Name
📧 Email: your@email.com

🔗 LinkedIn: linkedin.com/in/yourprofile
💻 GitHub: github.com/yourusername

⭐ Note for Recruiters

This repository focuses on system design, pricing intelligence, and real-world constraints, not just UI implementation.

It demonstrates:

End-to-end product thinking

Backend-driven mobile architecture

Business-aware engineering decisions
