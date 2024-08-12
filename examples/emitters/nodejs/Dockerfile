FROM node

RUN npm install -g pnpm

WORKDIR /usr/src/app

COPY . .

RUN pnpm install

EXPOSE 8080

CMD ["npm","start"]
