# 🚕 RUNWAYRIDE

A **Full-Stack Ride Hailing Platform**  
(Customer App + Driver App + Terrain-Aware Pricing Engine)

Production-oriented ride-hailing system inspired by Ola, Uber, and Rapido.

Focuses on **architecture**, **real-time logic**, **pricing intelligence**, and **business-critical flows** — the parts that actually make ride-hailing systems hard and interesting.

## 🧠 What Makes RUNWAYRIDE Different

Most demo projects show pretty screens.  
**RUNWAYRIDE shows how real ride-hailing systems work under the hood:**

- Two independent mobile apps (Customer & Driver)
- Real-time bidirectional location tracking
- Server-authoritative pricing & driver matching
- **Terrain-aware fare calculation** (plains, hills, mountains)
- Full payment + referral + earnings workflows
- Scalable, production-minded backend design

## 🏗️ High-Level Architecture
┌──────────────────┐
│   Customer App   │
│ (Flutter / iOS)  │
└────────┬─────────┘
│ HTTP + WebSocket
▼
┌──────────────────┐
│   Backend APIs   │
│ (Node.js / ...)  │
│  Auth · Rides    │
│  Pricing · Maps  │
└────────┬─────────┘
┌──────────┼──────────┬──────────┐
▼          ▼          ▼          ▼
┌────────────────┐ ┌───────────────┐ ┌───────────────┐ ┌───────────────┐
│  Pricing Engine│ │Real-Time      │ │ Payment       │ │  Driver App   │
│ (Core Logic)   │ │Tracking       │ │ (Razorpay)    │ │ (Flutter)     │
└────────────────┘ └───────────────┘ └───────────────┘ └───────────────┘
▲
│ WebSocket / Location Updates
└───────────────────────────────┘

## 📱 1. Customer Application (Rider App)

**Core Features**

- Google Maps SDK + Places Autocomplete
- Pickup & drop-off selection
- Route planning + ETA calculation
- **Server-driven real-time fare estimation**
- Driver matching & ride state machine
- Live ride tracking (WebSocket)
- Online payments (Razorpay)
- Ride status push notifications

**Main Integrations**

- Google Maps JavaScript/Directions API
- Firebase Auth + Firestore
- Backend REST + WebSocket APIs

## 🚗 2. Driver Application

**Core Features**

- Driver onboarding & document verification flow
- Go Online / Go Offline toggle
- Live GPS location streaming (optimized intervals)
- Ride request → Accept/Reject logic
- Turn-by-turn Google Maps navigation
- Earnings dashboard + payout summary
- Referral & incentive tracking

**Location Tracking Strategy**

- Battery & data efficient updates
- Backend broadcasts driver position to rider in real-time
- Fallback to periodic polling when WebSocket disconnects

## 💳 3. Payments & Earnings

- **Razorpay** integration (customer payments)
- Backend payment verification webhook
- Cancellation & partial refund logic
- Driver earnings calculation:
  - Gross fare
  - Platform commission
  - Referral bonus / incentives
  - Net payable amount

## 🏔️ 4. Pricing Engine – The Core Highlight

**Why pricing lives in its own module**

- Business-critical & security-sensitive
- Must be server-authoritative (never trust client)
- Independently scalable
- Shared logic between customer preview and final billing

### Pricing Intelligence Layers

1. **Latitude–Longitude Zoning**  
   Classifies area: Plain · Hill · Mountain · High Mountain

2. **Route Terrain Awareness**  
   Looks at worst terrain on the entire route (not just average)

3. **Time + Speed Bias**  
   Hilly/low-speed routes → higher weight on time component

### Fare Formula
-Fare = [
Base Fare
(Distance_km × Per-Km Rate)
(Duration_min × Per-Min Rate)
] × Terrain Multiplier × Surge Multiplier

**Example Terrain Multipliers**

| Terrain       | Multiplier |
|---------------|------------|
| Plain         | 1.00×      |
| Hill          | 1.10×      |
| Mountain      | 1.18×      |
| High Mountain | 1.30×      |

→ Simulates fuel, wear, driver fatigue, slower average speed

### Sample Calculation – SUV Mountain Ride

- Distance: 140 km
- Duration: 360 min (6 hours)
- Terrain: Mountain
-Base           ₹80
-Distance       ₹22 × 140 = ₹3,080
-Time           ₹1.1 × 360 = ₹396
-Subtotal       ₹3,556
-Terrain 1.18×  ≈ ₹4,196
-Final Fare     ~₹4,200 (after min fare & rounding rules)

## 🧪 Edge Cases Handled

- Minimum fare enforcement
- Very long outstation rides
- Mixed terrain routes (worst terrain wins)
- Very slow hill driving
- Surge × terrain combinations
- Cancellation fee logic

## 🔐 Security & Safety Notes

- **No API keys or credentials** in client code
- All pricing & final fare calculation → server-side
- Client apps are thin UI layers
- WebSocket authentication & rate limiting

## 🚀 Scalability & Future Direction

- Pricing engine ready to become microservice
- City/region specific pricing configs
- Elevation API integration possible
- ML-based ETA improvement
- Admin dashboard for pricing rules
- Heat-map / dynamic surge logic

## ⚠️ Disclaimer

RUNWAYRIDE is a **personal engineering & learning project**.  
It is **not** affiliated with Ola, Uber, Rapido, or any commercial ride-hailing company.

## 👨‍💻 Author

**Your Name**  
📧 [your@email.com](mailto:your@email.com)  
🔗 [LinkedIn](https://linkedin.com/in/yourprofile)  
💻 [GitHub](https://github.com/yourusername)

---

Built with ❤️ for system design & real-world backend challenges.
