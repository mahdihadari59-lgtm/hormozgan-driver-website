# Base image
FROM node:18-alpine

# Set working directory
WORKDIR /app

# Copy package files
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy all project files
COPY . .

# Build the app (اختیاری برای پروژه‌هایی مثل React یا Next)
# RUN npm run build

# Expose port
EXPOSE 8080

# Run app
CMD ["npm", "start"]
