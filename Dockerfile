# Sử dụng image của OpenJDK
FROM openjdk:21-jdk-slim AS build

# Đặt thư mục làm việc
WORKDIR /app

# Sao chép file Gradle và cấu hình
COPY build.gradle settings.gradle ./
COPY gradle gradle

# Sao chép toàn bộ mã nguồn vào image
COPY . .

# Cấp quyền thực thi cho gradlew
RUN chmod +x gradlew

# Build ứng dụng Spring Boot
RUN ./gradlew bootJar --no-daemon

# Tạo một image mới để chạy ứng dụng
FROM openjdk:21-jdk-slim

# Đặt thư mục làm việc
WORKDIR /app

# Sao chép file JAR đã build từ image trước đó
COPY --from=build /app/build/libs/*.jar app.jar

# Đặt các biến môi trường cho MinIO (có thể tùy chỉnh theo nhu cầu)
ENV MINIO_ACCESS_KEY=minio
ENV MINIO_SECRET_KEY=minio123
ENV MINIO_BUCKET_NAME=mybucket

# Mở cổng cho ứng dụng
EXPOSE 8080

# Chạy ứng dụng
ENTRYPOINT ["java", "-jar", "app.jar"]
