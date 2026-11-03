FROM node:20-alpine AS builder
WORKDIR /app
ENV NODE_OPTIONS="--max-old-space-size=1536"
ARG VITE_API_URL=https://kokkhopoth.com
ARG VITE_BASE_URL=https://edu.kokkhopoth.com
ENV VITE_API_URL=${VITE_API_URL}
ENV VITE_BASE_URL=${VITE_BASE_URL}

COPY package*.json ./
RUN npm ci

COPY . .
RUN npm run build-only

FROM nginx:alpine
RUN apk add --no-cache curl
COPY --from=builder /app/dist /usr/share/nginx/html
COPY deploy/nginx.conf /etc/nginx/conf.d/default.conf
EXPOSE 80
HEALTHCHECK --interval=15s --timeout=5s --retries=3 CMD curl -fsS http://127.0.0.1/ >/dev/null || exit 1
CMD ["nginx", "-g", "daemon off;"]

