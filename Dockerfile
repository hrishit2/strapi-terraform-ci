# Use Node.js 18 as the base image
FROM node:18

# Set working directory inside the container
WORKDIR /app

# Copy everything from current directory to container
COPY . .

# Install dependencies
RUN npm install

# Build the Strapi admin panel
RUN npm run build

# Expose Strapi port
EXPOSE 1337

# Start the app
CMD ["npm", "start"]
