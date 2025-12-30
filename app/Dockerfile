FROM node:20-alpine

# Set working directory (like: cd /app)
WORKDIR /app

# Create non-root user
RUN addgroup -S appgroup && adduser -S appuser -G appgroup

# ---- Backend dependencies ----
COPY package*.json ./
RUN npm install

# ---- Frontend dependencies ----
COPY frontend/package*.json ./frontend/
RUN cd frontend && npm install

# ---- Copy application source ----
COPY . .

# ---- Fix permissions ----
RUN chown -R appuser:appgroup /app

# ---- Drop privileges ----
USER appuser

# ---- Populate the database and start dev ----
CMD sh -c "npm run seed && PORT=$BACKEND_PORT npm run server & PORT=$FRONTEND_PORT npm start --prefix frontend"