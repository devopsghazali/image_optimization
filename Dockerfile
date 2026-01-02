# ---------- Builder ----------
FROM node:18 AS builder
WORKDIR /app

COPY package.json package-lock.json ./
RUN npm ci

COPY . .
RUN npm run build

# ---------- Runtime ----------
FROM node:18-slim
WORKDIR /app

RUN addgroup --system app && adduser --system --ingroup app app
USER app

COPY --from=builder /app/dist ./dist

CMD ["node", "dist/index.js"]
