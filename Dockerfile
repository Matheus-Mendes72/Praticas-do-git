# Estágio 1: Build (Utiliza a imagem do Maven para compilar a aplicação)
FROM maven:3.8.4-openjdk-17 AS build [1]
WORKDIR /app [5]

# Copia as dependências (pom.xml) e o código-fonte para dentro do contêiner
COPY pom.xml /app/ [5]
COPY src /app/src/ [5]

# Executa a compilação e gera o arquivo .jar executável
RUN mvn clean install -DskipTests [6]

# Estágio 2: Runtime (Gera a imagem final de execução ultra leve)
FROM openjdk:17-jdk-alpine [2, 7]
WORKDIR /app [2]

# Copia apenas o arquivo .jar gerado no primeiro estágio (build) para este novo contêiner
COPY --from=build /app/target/*.jar /app/app.jar [2, 6]

# Declara a porta que o contêiner expõe (porta padrão da aplicação Spring/Java)
EXPOSE 8080 [2, 8]

# Comando que inicia a aplicação ao rodar o contêiner
CMD ["java", "-jar", "app.jar"] [8, 9]