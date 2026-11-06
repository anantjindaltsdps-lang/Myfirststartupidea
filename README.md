# 🛵 RideSplit (Rapido Pool MVP)

> **Peer-to-peer ride pooling for Rapido riders.** Book a Rapido bike, auto, or cab, post your empty seats, match with co-commuters, and split the fare 50-50 via WhatsApp.

---

## 🌟 Features Implemented

1. **Post a Ride**:
   - Quick form to specify Pickup, Drop destination, Departure Time, Seats Available (1 to 4).
   - Vehicle selector: Rapido Bike 🏍️, Rapido Auto 🛺, or Rapido Cab 🚗.
   - Dynamic Fare Split calculation: Shows individual share in real-time.
   - Poster Name, Phone number & optional landmark notes.

2. **Find & View Rides (Basic Matching)**:
   - Search bar filtering by **destination keywords** (e.g., Koramangala, ITPL, Indiranagar, Metro).
   - Filter by vehicle type (Bike, Auto, Cab).
   - Sort by departure time, lowest fare, or seats remaining.
   - Quick one-click hotspot filter chips.

3. **Join via WhatsApp**:
   - One-click `wa.me` integration with pre-filled message template:
     > *"Hi Rahul, I saw your Rapido Auto ride on RideSplit from MG Road Metro to Koramangala at 6:15 PM. Can I join you and split the fare (₹80)? Please confirm if the seat is available!"*
   - Modal fallback to copy message and contact details to clipboard.

4. **Interactive Map Route Visualization**:
   - Leaflet.js interactive map with OpenStreetMap tiles (100% free, zero API key required).
   - Pickup marker (green), Drop marker (red), and dashed route polyline.
   - **Open in Google Maps** direct link button for turn-by-turn driving directions.

5. **Instant Fare Splitter Widget**:
   - Enter booking amount and number of riders to calculate per-person share and savings.

6. **Interactive Demo Simulation**:
   - Toggle buttons for **User A (Rahul - Poster)** and **User B (Priya - Seeker)** to test the full peer-to-peer loop immediately.
   - Pre-loaded realistic Bangalore & NCR metro routes.
   - Reset data button anytime.

---

## 🚀 How to Run the Project

### Option 1: Direct Browser (Zero Setup - Instant!)
Simply double-click `index.html` in your file explorer, or open it in any web browser (Chrome, Edge, Firefox).
All features (ride search, post ride, WhatsApp links, Leaflet map, LocalStorage data persistence) work immediately out of the box!

### Option 2: Zero-Install Local Server (PowerShell)
Open PowerShell in the project directory and run:
```powershell
.\start-server.ps1
```
This automatically starts a local HTTP server at `http://localhost:3000/` and opens your browser.

### Option 3: Node.js & Express (Optional Backend)
If you have Node.js installed:
```bash
cd backend-node
npm install
npm start
```
Runs at `http://localhost:3000`.

### Option 4: Python & Flask (Optional Backend)
If you have Python installed:
```bash
cd backend-python
pip install -r requirements.txt
python app.py
```
Runs at `http://localhost:5000`.

---

## 🗂️ Project Structure

```text
Untitled Project/
├── index.html            # Main single-page application UI
├── css/
│   └── styles.css        # Custom styles, animations, scrollbars
├── js/
│   ├── app.js            # Core logic, filtering, WhatsApp message builder
│   ├── map.js            # Leaflet route visualization & Google Maps links
│   └── rides-data.js     # Demo rides & LocalStorage sync
├── backend-node/
│   ├── server.js         # Express REST API (GET/POST /api/rides)
│   ├── package.json      # Node dependencies
│   └── rides.json        # JSON file database
├── backend-python/
│   ├── app.py            # Flask REST API (GET/POST /api/rides)
│   ├── requirements.txt  # Python dependencies
│   └── rides.json        # JSON file database
├── start-server.ps1      # Native Windows zero-install HTTP server
└── README.md             # Documentation
```

---

## 🔄 User Workflow (MVP Example)

1. **User A (Rahul)** books a Rapido ride from *MG Road Metro* to *Koramangala* for ₹160.
2. Rahul opens RideSplit and clicks **"Post a Ride"** with 2 available seats.
3. The platform calculates each co-passenger's share as ₹80.
4. **User B (Priya)** opens RideSplit, types "Koramangala" in the search box, and spots Rahul's ride.
5. Priya clicks **"Join via WhatsApp"**.
6. A WhatsApp chat with Rahul opens containing a pre-populated confirmation message.
7. Both meet at the pickup spot, commute together, and Priya pays ₹80 directly to Rahul via UPI or Cash.
