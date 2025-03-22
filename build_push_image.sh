# create docker image dari dockerfile dengan nama image "item-app" dan tag v1
# melihat daftar image di lokal "docker images"
# mengubah nama image agar sesau idengan format github packages
# upload image ke docker hub

#!/bin/bash

# Hentikan skrip jika ada error
set -e

# Definisikan variabel
IMAGE_NAME="item-app"
IMAGE_TAG="v1"
GITHUB_USER="USERNAME"  # Ganti dengan GitHub username Anda
GITHUB_REPO="REPO_NAME" # Ganti dengan nama repository GitHub Anda
GITHUB_TOKEN="YOUR_GITHUB_TOKEN" # Gunakan Personal Access Token (PAT)
GITHUB_PACKAGE="ghcr.io/$GITHUB_USER/$IMAGE_NAME:$IMAGE_TAG"

# 1. Build Docker Image
echo "Membangun Docker image..."
docker build -t "$IMAGE_NAME:$IMAGE_TAG" .

# 2. Tampilkan daftar image yang sudah dibuat
echo "Daftar Docker image di lokal:"
docker images | grep "$IMAGE_NAME"

# 3. Tag image agar sesuai dengan GitHub Packages
echo "Menandai image dengan nama GitHub Packages..."
docker tag "$IMAGE_NAME:$IMAGE_TAG" "$GITHUB_PACKAGE"

# 4. Login ke GitHub Packages
echo "Login ke GitHub Container Registry..."
echo "$GITHUB_TOKEN" | docker login ghcr.io -u "$GITHUB_USER" --password-stdin

# 5. Push image ke GitHub Packages
echo "Mengunggah image ke GitHub Packages..."
docker push "$GITHUB_PACKAGE"

# 6. Konfirmasi keberhasilan
echo "Image berhasil di-push ke GitHub Packages: $GITHUB_PACKAGE"