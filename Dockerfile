# 1. Use Node.js 18 LTS as base image
FROM node:18

# 2. Set working directory
WORKDIR /app

# 3. Copy package.json and lock file first for caching
COPY package*.json ./

# 4. Install app dependencies
RUN npm install

# 5. Copy the rest of the application code
COPY . .

# 5.1. Copy environment file
COPY .env .env

# 6. Build the Strapi admin panel
RUN npm run build

# 7. Ensure correct permissions (especially for .tmp & public)
RUN chown -R node:node /app

# 8. Set non-root user (recommended for ECS)
USER node

# 9. Expose the default Strapi port
EXPOSE 1337

# 10. Start the app
CMD ["npm", "start"]

