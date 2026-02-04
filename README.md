# 🚕 RUNWAYRIDE  
### A Full-Stack Ride Hailing Platform  
*(Customer App + Driver App + Pricing Engine)*

RUNWAYRIDE is a **production-oriented ride-hailing platform** inspired by Ola, Uber, and Rapido.  
It demonstrates **end-to-end system design**, including customer booking, driver operations, live tracking, payments, and a terrain-aware pricing engine.

This repository focuses on **architecture, APIs, and business logic**, which are the hardest and most critical parts of ride-hailing systems.

---

## 💡 What Makes RUNWAYRIDE Different

Most demo projects focus on UI screens.  
**RUNWAYRIDE focuses on how real ride-hailing systems actually work.**

- Two independent mobile applications (Customer & Driver)
- Real-time location tracking
- Server-driven pricing and ride matching
- Terrain-aware fare calculation
- Payment and referral workflows
- Scalable backend-first design

---

## 🏗️ High-Level System Architecture

```text
┌──────────────────┐
│  Customer App    │
│ (Flutter / iOS)  │
└────────┬─────────┘
         │
         ▼
┌──────────────────────────┐
│       Backend APIs       │
│ Auth | Rides | Pricing  │
│ Maps | Matching | ETA   │
└────────┬─────────────────┘
         │
 ┌───────┼─────────────┬─────────────┐
 ▼       ▼             ▼             ▼
Pricing Engine   Real-Time Tracking   Payment Service
(This Repo)      (Sockets / DB)       (Razorpay)
         ▲
         │
┌────────┴─────────┐
│   Driver App     │
│   (Flutter)      │
└──────────────────┘
📱 Customer Application (Rider App)

The Customer App handles ride discovery, booking, and tracking.

Core Responsibilities

Google Maps & Directions API integration

Pickup & drop location selection

Route distance and ETA calculation

Real-time fare estimation (server driven)

Driver assignment & ride lifecycle

Live ride tracking

Payment initiation

Push notifications

🚗 Driver Application

The Driver App is a separate system with its own workflows.

Core Responsibilities

Driver authentication & onboarding

Online / offline availability

Live GPS streaming

Ride accept / reject logic

Navigation support

Earnings tracking

Referral & incentive integration

💳 Payments & Earnings
Razorpay Integration

Secure payment processing

Ride-based transaction verification

Cancellation & refund handling

Driver Earnings Model

Gross fare calculation

Platform commission

Incentives & referrals

Net payout computation

🏔️ Pricing Engine (Core Highlight)

Pricing is the most business-critical part of any ride-hailing platform.

This repository publicly exposes the pricing engine & fare schema, while keeping full app code private for security and IP reasons.

🔍 Pricing Intelligence Layers
1️⃣ Latitude–Longitude Zoning

Regions are classified as:

Plain

Hill

Mountain

High Mountain

This decides base pricing rules.

2️⃣ Route Awareness (Pickup → Drop)

The pricing engine considers the worst terrain involved in the route.

3️⃣ Time & Speed Bias

Hilly routes emphasize time-based pricing more than distance.

💰 Fare Calculation Formula
Fare =
  Base Fare
+ (Distance × Per-Km Rate)
+ (Duration × Per-Minute Rate)
× Terrain Multiplier
× Surge Multiplier


Passengers see one final fare, without separate terrain charges.

📄 Fare Schema File

This repository includes a fare schema file defining:

Vehicle-wise base fares

Per-km & per-minute rates

Terrain multipliers

Minimum fare rules

Surge compatibility

The schema is config-driven and production-ready.

🧪 Sample Scenario

Sedan Ride – Mountain Route

Distance: 120 km

Duration: 300 minutes

Base Fare: ₹65
Distance Fare: ₹16 × 120
Time Fare: ₹0.9 × 300
Terrain Multiplier: 1.18×

Final Fare ≈ ₹2,100+

🔐 Security & Design Considerations

No API keys or secrets exposed

Pricing authority remains server-side

Client apps act as thin layers

Business logic is isolated and reusable

🚀 Scalability & Future Enhancements

Elevation-based terrain scoring

ML-driven ETA prediction

Admin pricing dashboard

Dynamic surge zones

Driver incentive optimization

⚠️ Disclaimer

RUNWAYRIDE is a personal engineering project built for learning and demonstration purposes.
It is not affiliated with Ola, Uber, or Rapido.

👨‍💻 Author

Your Name
📧 Email: your@email.com

🔗 LinkedIn: linkedin.com/in/yourprofile
💻 GitHub: github.com/yourusername
