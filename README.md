# 🐾 Zootopia Petshop

**Secure DevOps Project**

Zootopia Petshop is a full-stack MERN (MongoDB, Express, React, Node.js) application developed as part of a **Secure DevOps** course project.
The project supports local development, Docker-based deployment, Docker Hub distribution, and cloud deployment, following DevOps best practices such as containerization, environment isolation, and reproducibility.

---

## 🌐 Live Deployment (Render)

The application is **publicly deployed on Render** and accessible at:

👉 **[https://zootopia-security.onrender.com/](https://zootopia-security.onrender.com/)**

This deployment uses:

* **Render** for application hosting
* **MongoDB Atlas** as the managed cloud database
* Environment variables securely configured via Render dashboard

> This represents the **production-ready deployment** of the project.


---

## 📁 Project Structure

```text
app/
├── backend/
│   ├── server.js
│   ├── seed-random.js
│   └── ...
├── frontend/
│   ├── src/
│   ├── package.json
│   └── .env
├── package.json
├── .env
├── Dockerfile
docker-compose.yml
README.md
```

---

## 🛠 Prerequisites

### For Local Setup

* Node.js (v18+ recommended)
* npm
* Docker (for MongoDB)

### For Docker Setup

* Docker
* Docker Compose

---

## 🔐 Environment Variables

Environment variables are **not committed** to GitHub.

### Backend (`app/.env`)

```env
NODE_ENV=development
PORT=5000
MONGO_URI=mongodb://localhost:27017/petshop
JWT_SECRET=5d8f7a9c1e0a4f6b9d2c8e7a3b1f0c4d
PAYPAL_CLIENT_ID=sb

GOOGLE_CLIENT_ID=811912472828-9mbtl501muu3qs00s9j7vvaidsvgc44t.apps.googleusercontent.com

SMTP_HOST=smtp.gmail.com
SMTP_PORT=587
SMTP_USER=<email>
SMTP_PASS=<app_password>
SMTP_FROM="Zootopia PetShop"
SMTP_SECURE=true
MFA_OTP_TTL_MIN=10
MFA_OTP_MAX_ATTEMPTS=5

JWT_MFA_TEMP_SECRET=dev_secret_123
```

### Frontend (`app/frontend/.env`)

```env
REACT_APP_GOOGLE_CLIENT_ID=811912472828-9mbtl501muu3qs00s9j7vvaidsvgc44t.apps.googleusercontent.com
PORT=3000
```

> In Docker, `MONGO_URI` is overridden via `docker-compose.yml` to use the Mongo service name.

---

## ☁️ Cloud Database Setup (MongoDB Atlas)

Instead of running MongoDB locally, you can use our MongoDB Atlas cluster:

Connection string:
```env
MONGO_URI=mongodb+srv://ahmedemad8:0GhF7o9qKQ2Fib1y@zootopia.ccmdxat.mongodb.net/
```

---

## 🚀 Local Database Setup

## 1️⃣ Start MongoDB Locally

```bash
docker run --name petshop-mongo -d -p 27017:27017 mongo
```

> MongoDB will be available at `localhost:27017`

---

### 2️⃣ Seed the Database

```bash
cd app
npm run seed
```

---

## 🚀 Local Development Setup

This setup runs **MongoDB in Docker** and the **app on the host machine**.

### 1️⃣ Install Backend Dependencies

```bash
cd app
npm install
```

---

### 2️⃣ Install Frontend Dependencies

```bash
cd app/frontend
npm install
```

---

### 3️⃣ Run the Application (Dev Mode)

```bash
cd app
npm run dev
```

* Backend → [http://localhost:5000](http://localhost:5000)
* Frontend → [http://localhost:3000](http://localhost:3000)

---

## 🐳 Docker Setup (Recommended)

This setup runs **Backend and Frontend fully containerized** using Docker Compose.

### 1️⃣ Build and Start All Services

```bash
docker-compose up -d --build
```

Docker Compose will:

* Create a private Docker network
* Run backend and frontend services

---

### 2️⃣ Access the Application

* Frontend → [http://localhost:3000](http://localhost:3000)
* Backend API → [http://localhost:5000](http://localhost:5000)

---

## 🐳 Docker Hub Setup

1. **Pull the App Image**

```bash
docker pull hlahany/zootopia-petshop:latest
```

4. **Run the App Container**

```bash
docker run -d \
  --name petshop-app \
  -p 5000:5000 \
  -p 3000:3000 \
  -e MONGO_URI="mongodb+srv://ahmedemad8:0GhF7o9qKQ2Fib1y@zootopia.ccmdxat.mongodb.net/" \
  -e BACKEND_PORT=5000 \
  -e FRONTEND_PORT=3000 \
  hlahany/zootopia-petshop:latest
```

* Environment variables override `.env` values inside the container.

5. **Access the App**

* Backend: [http://localhost:5000](http://localhost:5000)
* Frontend: [http://localhost:3000](http://localhost:3000)

---

## 🧪 Development Notes

* Hot reload enabled via Docker volumes (dev mode)
* Backend uses `nodemon`
* Frontend uses `react-scripts`
* Ports are configurable via environment variables

---

## 🧹 Cleanup

### Stop containers (for Docker setup)

```bash
docker-compose down
```

---

## 👤 Authors

**Zootopia Petshop – Secure DevOps Project**
Developed by:
* Ahmed Emad
* Hla Hany
* Habiba Assem
* Khadija Swelam
* Nada Tarek

---