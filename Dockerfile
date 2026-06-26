# Bước 1: Build file WAR bằng Maven (sử dụng image eclipse-temurin gọn nhẹ)
FROM maven:3.9-eclipse-temurin-17 AS build
WORKDIR /app
COPY . .
RUN mvn clean package -DskipTests

# Bước 2: Chạy ứng dụng bằng Tomcat 10 bản tiêu chuẩn
FROM tomcat:10.1-jre17
WORKDIR /usr/local/tomcat
RUN rm -rf webapps/ROOT
COPY --from=build /app/target/*.war webapps/ROOT.war

EXPOSE 8080
CMD ["catalina.sh", "run"]
