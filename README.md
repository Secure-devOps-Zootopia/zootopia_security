# 🐾 Zootopia Petshop

**Secure DevOps Project**

Zootopia Petshop is a full-stack MERN (MongoDB, Express, React, Node.js) application developed as part of a **Secure DevOps** course project.
The project supports **both local development and Docker-based deployment**, following DevOps best practices such as containerization, environment isolation, and reproducibility.

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
SMTP_USER=ahmedemad8@gmail.com
SMTP_PASS=yqzj xcgu fijb cmof
SMTP_FROM="Zootopia PetShop"
SMTP_SECURE=true
MFA_OTP_TTL_MIN=10
MFA_OTP_MAX_ATTEMPTS=5

JWT_MFA_TEMP_SECRET=dev_secret_123_emad
```

### Frontend (`app/frontend/.env`)

```env
REACT_APP_GOOGLE_CLIENT_ID=811912472828-9mbtl501muu3qs00s9j7vvaidsvgc44t.apps.googleusercontent.com
PORT=3000
```

> In Docker, `MONGO_URI` is overridden via `docker-compose.yml` to use the Mongo service name.

---

## 🚀 Local Development Setup

This setup runs **MongoDB in Docker** and the **app on the host machine**.

### 1️⃣ Start MongoDB

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

### 3️⃣ Install Backend Dependencies

```bash
cd app
npm install
```

---

### 4️⃣ Install Frontend Dependencies

```bash
cd app/frontend
npm install
```

---

### 5️⃣ Run the Application (Dev Mode)

```bash
cd app
npm run dev
```

* Backend → [http://localhost:5000](http://localhost:5000)
* Frontend → [http://localhost:3000](http://localhost:3000)

---

## 🐳 Docker Setup (Recommended)

This setup runs **MongoDB, Backend, and Frontend fully containerized** using Docker Compose.

### 1️⃣ Build and Start All Services

```bash
docker-compose up -d --build
```

Docker Compose will:

* Create a private Docker network
* Start MongoDB with persistent volume
* Seed the database
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

2. **Create a Docker Network** (optional but recommended for container communication)

```bash
docker network create zootopia-net
```

3. **Start MongoDB**

```bash
docker run -d \
  --name petshop-mongo \
  --network zootopia-net \
  -p 27017:27017 \
  -v mongo-data:/data/db \
  mongo:7
```

* `--network zootopia-net` ensures the app can reach Mongo using the container name (`petshop-mongo`)
* Data is persisted in a Docker volume `mongo-data`

4. **Run the App Container**

```bash
docker run -d \
  --name petshop-app \
  --network zootopia-net \
  -p 5000:5000 \
  -p 3000:3000 \
  -e MONGO_URI=mongodb://petshop-mongo:27017/petshop \
  -e BACKEND_PORT=5000 \
  -e FRONTEND_PORT=3000 \
  hlahany/zootopia-petshop:latest
```

* Environment variables override `.env` values inside the container.
* The app connects to Mongo via `mongodb://petshop-mongo:27017/petshop`.

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

### Stop and remove Mongo (for local setup)

```bash
docker stop petshop-mongo
docker rm petshop-mongo
```

---

## 👤 Authors

**Zootopia Petshop – Secure DevOps Project**
Developed by:
*Ahmed Emad*
*Hla Hany*
*Habiba Assem*
*Khadija Swelam*
*Nada Tarek*

---