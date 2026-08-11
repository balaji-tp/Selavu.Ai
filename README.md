# 💰 Selavu.Ai — Smart Income & Expense Tracker

**Take control of your finances, one transaction at a time.**

Selavu.Ai is a full-stack personal finance web app for tracking balances, logging transactions, setting category budgets, visualizing spending trends, and staying on top of savings goals — all wrapped in a clean, modern interface.

---

## 📋 Table of Contents

- [Features](#-features)
- [Tech Stack](#-tech-stack)
- [Project Structure](#-project-structure)
- [Getting Started](#-getting-started)
- [Environment Variables](#-environment-variables)
- [Seeding Sample Data](#-seeding-sample-data)
- [Running the App](#-running-the-app)
- [Available Scripts](#-available-scripts)
- [Roadmap](#-roadmap)
- [License](#-license)

---

## ✨ Features

| Category | Highlights |
|---|---|
| 🔐 **Authentication** | Secure signup/login with JWT-based session handling |
| 📊 **Dashboard** | Glassmorphism UI, donut charts for category breakdown, income vs. expense comparisons, live stats |
| 📒 **Transaction Ledger** | Full CRUD, search, multi-field filtering (category/type/date), and sorting |
| 🎯 **Budgeting Engine** | Monthly category limits with automatic overspend warnings |
| 🏦 **Savings Goals** | Target amounts, deadlines, and incremental deposit tracking |
| 📤 **Data Export** | Download your ledger as CSV or generate printable PDF reports |
| 🌗 **Theming** | Light/dark mode with saved user preference |

---

## 🛠 Tech Stack

**Frontend**
- React (Vite)
- Tailwind CSS
- Recharts
- React Router
- Lucide React (icons)

**Backend**
- Node.js + Express (REST API)
- MongoDB with Mongoose ODM
- JWT for authentication

---

## 📁 Project Structure

```
Selavu.Ai/
├── backend/          # Express REST API, models, routes, auth
│   ├── .env          # Environment configuration (not committed)
│   └── package.json
├── frontend/          # React + Vite client
│   └── package.json
└── README.md
```

---

## 🚀 Getting Started

### Prerequisites

Make sure you have the following installed:

- **Node.js** v16 or higher
- **MongoDB** — either running locally on port `27017`, or a MongoDB Atlas connection URI

### Installation

```bash
# Clone the repository
git clone <your-repo-url>
cd Selavu.Ai

# Install backend dependencies
cd backend
npm install

# Install frontend dependencies
cd ../frontend
npm install
```

---

## ⚙️ Environment Variables

Create a `.env` file inside the `backend/` directory:

```env
PORT=5000
MONGO_URI=mongodb://localhost:27017/selavu
JWT_SECRET=your_own_secret_key_here
NODE_ENV=development
```

> ⚠️ **Security note:** Never commit a real `.env` file or use a placeholder secret like `supersecretkey_...` in production. Generate a strong, random `JWT_SECRET` for each environment.

---

## 🌱 Seeding Sample Data

To populate the database with ~6 months of realistic sample transactions (so charts are populated right away):

```bash
cd backend
npm run seed
```

This creates a demo account you can log in with immediately:

| Field | Value |
|---|---|
| Email | `demo@selavu.ai` |
| Password | `password123` |

---

## ▶️ Running the App

Run the backend and frontend in two separate terminals.

**1. Start the API server** (from `backend/`):
```bash
npm run dev
```
→ Available at `http://localhost:5000`

**2. Start the frontend** (from `frontend/`):
```bash
npm run dev
```
→ Available at `http://localhost:3000`

Then open **`http://localhost:3000`** in your browser and log in with the demo account (or sign up).

---

## 📜 Available Scripts

| Location | Command | Description |
|---|---|---|
| `backend/` | `npm run dev` | Start API in development mode with hot reload |
| `backend/` | `npm run seed` | Seed the database with sample data |
| `frontend/` | `npm run dev` | Start the Vite dev server |
| `frontend/` | `npm run build` | Build the frontend for production |

---

## 🗺 Roadmap

- [ ] Multi-currency support
- [ ] Recurring transaction scheduling
- [ ] Shared/family budgets
- [ ] Mobile app (React Native)

---

## 📄 License

This project is licensed under the MIT License — feel free to use, modify, and distribute it.
