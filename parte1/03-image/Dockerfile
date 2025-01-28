FROM node:22-alpine
USER root
COPY . / app /
COPY package*.json ./
WORKDIR /app/src
RUN mkdir -p node_modules && chown -R node:node /app/src
RUN apk add curl
RUN npm install \
    npm install express \
    npm install --save-dev @types/express \
    npm install --save-dev ts-node \
    npm install ts-node typescript --save-dev \
    npm install @aws-sdk/client-cloudwatch-logs \
    npm install express prom-client \
    npm init -y
COPY --chown=node:node . .
USER node
EXPOSE 9090
CMD ["npm", "start"]



