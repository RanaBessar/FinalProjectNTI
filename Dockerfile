# ============================================
# Multi-stage Dockerfile for NTI App
# ============================================

# Build stage
FROM node:18-alpine AS builder

WORKDIR /app

COPY app/package*.json ./

RUN npm ci --omit=dev

COPY app/ ./


# ============================================
# Production stage
# ============================================
FROM node:18-alpine AS production

LABEL maintainer="DevOps Team"
LABEL application="nti-app"
LABEL version="1.0.0"

# Install curl for healthcheck
RUN apk add --no-cache curl

# Create non-root user
RUN addgroup -g 1001 -S nodejs && \
    adduser -S nodejs -u 1001

WORKDIR /app

COPY --from=builder --chown=nodejs:nodejs /app/node_modules ./node_modules
COPY --from=builder --chown=nodejs:nodejs /app/server.js ./
COPY --from=builder --chown=nodejs:nodejs /app/package.json ./

ENV NODE_ENV=production
ENV PORT=3000

USER nodejs

EXPOSE 3000

HEALTHCHECK --interval=30s --timeout=5s --start-period=10s --retries=3 \
  CMD curl -f http://localhost:3000/health || exit 1

CMD ["node", "server.js"]
