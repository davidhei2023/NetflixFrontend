FROM node:14-alpine AS build

WORKDIR /app
COPY . .
RUN npm install
RUN npm run build

CMD ["npm", "start"]