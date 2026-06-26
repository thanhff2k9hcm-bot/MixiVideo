# Bước 1: Build file WAR bằng Maven và OpenJDK 17
FROM maven:3.8.6-openjdk-17 AS build
WORKDIR /app
COPY . .
RUN mvn clean package -DskipTests

# Bước 2: Chạy ứng dụng bằng Tomcat 10
FROM tomcat:10.1-jdk17
WORKDIR /usr/local/tomcat
# Xóa thư mục ROOT mặc định của Tomcat để tránh xung đột đường dẫn
RUN rm -rf webapps/ROOT
# Copy file .war vừa build vào làm trang chủ ROOT
COPY --from=build /app/target/*.war webapps/ROOT.war

EXPOSE 8080
CMD ["catalina.sh", "run"]
