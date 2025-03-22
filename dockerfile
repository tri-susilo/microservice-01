# Build stage
FROM node:14 AS builder

# Set working directory for the build stage
WORKDIR /app

# Copy package files for dependency installation
COPY package*.json ./

# Install all dependencies (including dev dependencies)
RUN npm install

# Copy all source code
COPY . .

# Build the application
RUN npm run build

# Production stage
FROM node:14-slim

# Set working directory for the production stage
WORKDIR /app

# Set environment variables
ENV NODE_ENV=production DB_HOST=item-db

# Copy package files
COPY package*.json ./

# Install only production dependencies
RUN npm install --production --unsafe-perm

# Copy built application from the builder stage
COPY --from=builder /app/bin ./bin
COPY --from=builder /app/public ./public
COPY --from=builder /app/views ./views
COPY --from=builder /app/app.js ./

# If your build process generates other necessary files/folders, copy them as well
# For example, if the build creates a 'dist' folder:
# COPY --from=builder /app/dist ./dist

# Expose port 8080
EXPOSE 8080

# Start the application
CMD ["npm", "start"]