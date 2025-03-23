# menggunakan base image node:14 sebagai builder stage
FROM node:14 AS builder                         

# setting working directory pada /app
WORKDIR /app 

# copy file package untuk isntalasi library/dependency
COPY package*.json ./

# install semua dependencies termasuk development depencencies
RUN npm install

# salin semua source code ke dalam working directory
COPY . .

# build aplikasi
RUN npm run build

# menggunakan base image node:14-slim sebagai production stage
FROM node:14-slim

# setting working directory di /app 
WORKDIR /app

# memastikan aplikasi berjalan pada environment production dan menentukan nama host database
ENV NODE_ENV=production DB_HOST=item-db

# copy package-lock.json dan package.json ke container
COPY package*.json ./

# install dependensi untuk production
RUN npm install --production --unsafe-perm

# mengcopy semua file yang dibutuhkan dari stage builder ke stage production
COPY --from=builder /app/bin ./bin
COPY --from=builder /app/public ./public
COPY --from=builder /app/routes ./routes
COPY --from=builder /app/views ./views
COPY --from=builder /app/app.js ./

# expose conatainer ke port 8080
EXPOSE 8080

# menjalakan perintah npm start saat container dijalankan
CMD ["npm", "start"]