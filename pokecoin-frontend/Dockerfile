# ----- builder -----
FROM node:18-alpine AS builder
WORKDIR /app
# copy package files first for caching
COPY package*.json ./
# if using pnpm/yarn, adjust accordingly
RUN npm ci
COPY . .
RUN npm run build

FROM nginx:stable-alpine AS runner
# remove default nginx html and copy built files
RUN rm -rf /usr/share/nginx/html/*
COPY --from=builder /app/dist /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]