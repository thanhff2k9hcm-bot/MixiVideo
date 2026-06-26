# Bước 1: Build file WAR bằng Maven sử dụng OpenJDK 17 ổn định cao
FROM maven:3.9-eclipse-temurin-17 AS build
WORKDIR /app
COPY . .
RUN mvn clean package -DskipTests

# Bước 2: Chạy ứng dụng bằng máy chủ Tomcat 10 chuyên dụng
FROM tomcat:10.1-jre17
WORKDIR /usr/local/tomcat

# Dọn dẹp ứng dụng mặc định của Tomcat để tránh xung đột định tuyến
RUN rm -rf webapps/ROOT

# Copy file ROOT.war vừa build từ bước 1 vào thư mục webapps của Tomcat
COPY --from=build /app/target/ROOT.war webapps/ROOT.war

EXPOSE 8080
CMD ["catalina.sh", "run"]
