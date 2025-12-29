FROM node:20-alpine

# Create app directory
WORKDIR /app

# Create non-root user
RUN addgroup -S appgroup && adduser -S appuser -G appgroup

# Install only production deps
COPY package*.json ./
RUN npm install --omit=dev
# RUN npm ci --only=production

# Copy app code
COPY . .

# Drop privileges
USER appuser

EXPOSE 3000

CMD ["node", "server.js"]
