# ==========================================
# ETAPA 1: Build (Compilação do TypeScript)
# ==========================================
FROM node:20-alpine AS builder

WORKDIR /usr/src/app

# Copia apenas os arquivos de dependências primeiro (aproveita o cache do Docker)
COPY package*.json ./

# Instala TODAS as dependências (incluindo as de desenvolvimento para o build)
RUN npm ci

# Copia o restante dos arquivos do seu projeto NestJS
COPY . .

# Compila o TypeScript para JavaScript (gera a pasta /dist)
RUN npm run build

# Remove as dependências de desenvolvimento, deixando apenas o necessário para produção
RUN npm prune --production

# ==========================================
# ETAPA 2: Runtime (O que vai de verdade para a AWS)
# ==========================================
FROM node:20-alpine AS runner

WORKDIR /usr/src/app

# Variável de ambiente informando que estamos em produção
ENV NODE_ENV=production

# Copia apenas as dependências de produção da etapa anterior
COPY --from=builder /usr/src/app/node_modules ./node_modules

# Copia apenas a pasta de código compilado (dist) da etapa anterior
COPY --from=builder /usr/src/app/dist ./dist
COPY --from=builder /usr/src/app/package*.json ./

# Expõe a porta que o NestJS usa (geralmente 3000)
EXPOSE 3000

# Comando para iniciar a API direto pelo JavaScript compilado
CMD ["node", "dist/main.js"]