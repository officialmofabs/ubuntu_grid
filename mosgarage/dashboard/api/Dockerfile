FROM node:18-alpine
WORKDIR /app
COPY server.js .
RUN npm init -y && npm install express dockerode cors
CMD ["node", "server.js"]
