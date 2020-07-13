# Build the Vue app
FROM node:latest as build-stage
WORKDIR /app
COPY package*.json ./

RUN npm install
COPY ./ .
RUN npm run build

# Put the built app in an NGINX contaier
FROM nginx as production-stage
RUN mkdir /app
COPY --from=build-stage /app/dist /app
COPY nginx.conf /etc/nginx/nginx.conf

# Loading environment variables at runtime
COPY ./entrypoint.sh /entrypoint.sh
# DOES NOT SEEM TO BE WORKING
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
