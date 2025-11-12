# Étape 1 : image de base Java
FROM openjdk:17-jdk-slim

# Étape 2 : définir le répertoire de travail
WORKDIR /app

# Étape 3 : copier le jar généré par Maven
COPY target/timesheet-devops-1.0.jar app.jar

# Étape 4 : exposer le port de l’application
EXPOSE 8089

# Étape 5 : démarrer l’application
ENTRYPOINT ["java", "-jar", "app.jar"]
