# ---------- Build stage ----------
FROM node:20-alpine as build

WORKDIR /app

RUN corepack enable && corepack prepare pnpm@latest --activate

ENV CI=true
ENV NODE_ENV=development

COPY . .

RUN pnpm install
RUN pnpm run build

# ---------- Serve stage ----------
FROM nginx:alpine

COPY --from=build /app/dist /usr/share/nginx/html

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]