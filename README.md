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

```text
┌──────────────────────────┐        HTTP / WebSocket
│      Customer App        │  ─────────────────────────▶
│    (Flutter / iOS)       │
└───────────┬──────────────┘
            │
            ▼
┌──────────────────────────────────────────────┐
│                 Backend APIs                 │
│  (Node.js / Server)                          │
│  Auth | Rides | Pricing | Maps | ETA         │
└───────────┬──────────────┬──────────────────┘
            │              │
            │              ▼
            │      ┌──────────────────┐
            │      │   Payment Service │
            │      │    (Razorpay)     │
            │      └──────────────────┘
            │
            ▼
┌──────────────────┐      WebSocket / DB
│  Pricing Engine  │◀──────────────────────────┐
│   (This Repo)    │                           │
└───────────┬──────┘                           │
            │                                  │
            ▼                                  │
┌──────────────────┐                           │
│   Driver App     │───────────────────────────┘
│   (Flutter)      │   Live Location Updates
└──────────────────┘
```

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
<img width="283" height="610" alt="image" src="https://github.com/user-attachments/assets/dae0e8b6-f766-4bc0-a2e3-3cf36bb7d195" />
<img width="281" height="617" alt="image" src="https://github.com/user-attachments/assets/db540a7f-fe26-4cd5-9a85-daec0d393d01" />
<img width="281" height="621" alt="image" src="https://github.com/user-attachments/assets/a8892e9c-ebd9-48c4-97fa-30d88a7fe913" />
<img width="281" height="622" alt="image" src="https://github.com/user-attachments/assets/57f9381c-1901-4457-a8b5-6bbcfbb1a11c" />

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
  <img width="280" height="622" alt="image" src="https://github.com/user-attachments/assets/2284c1b0-d080-45e6-8148-a5755fb28556" />
  <img width="276" height="616" alt="image" src="https://github.com/user-attachments/assets/1e073440-4e5c-404b-b032-d3c44e682f19" />
  <img width="278" height="617" alt="image" src="https://github.com/user-attachments/assets/949a412b-a5fd-464d-b59a-c6bbff68b4ac" />
  <img width="281" height="618" alt="image" src="https://github.com/user-attachments/assets/1f135d01-3b38-4708-a37d-195bff3b9e42" />
  <img width="278" height="617" alt="image" src="https://github.com/user-attachments/assets/fcf22ae1-746b-4211-bdd2-0f9da80b7fee" />


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

**Sarthak Pandey**  
📧 [sarthakvarsh9696@gmail.com](mailto:sarthakvarsh9696@gmail.com)  
🔗 [LinkedIn](https://www.linkedin.com/in/sarthakpandey96/)  
💻 [GitHub](https://github.com/sarth-ak47/Runwayride)

---

Built with ❤️ for system design & real-world backend challenges.
