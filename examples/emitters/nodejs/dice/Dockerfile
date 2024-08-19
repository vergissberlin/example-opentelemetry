FROM node:20-alpine

# Install PNPM globally
RUN npm install -g pnpm

# Create and set the working directory
WORKDIR /app


# Copy the package.json and pnpm-lock.yaml files
COPY package.json pnpm-lock.yaml ./

# Install the dependencies with PNPM
RUN pnpm install --frozen-lockfile

# Copy the rest of the source code
COPY . .

EXPOSE 8030

HEALTHCHECK --interval=30s --timeout=30s --start-period=5s --retries=3 CMD curl -f http://localhost:8030/health || exit 1

CMD ["pnpm","start"]
