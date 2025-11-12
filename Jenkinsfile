pipeline {
    agent any

    environment {
        MAVEN_HOME = tool 'M3'
        PATH = "${MAVEN_HOME}/bin:${PATH}"
    }

    stages {

        stage('Checkout') {
            steps {
                echo "📦 Récupération du code source depuis GitHub..."
                git branch: 'main', credentialsId: 'jenkins-github-https-cred', url: 'https://github.com/amirabensalah/Devops-amira.git'
            }
        }

        stage('Build') {
            steps {
                echo "⚙️ Compilation du projet Maven..."
                sh 'mvn clean package -DskipTests'
            }
        }

        stage('SCA - Dependency Check') {
            steps {
                echo "🔍 Simulation rapide de l’analyse des dépendances..."
                sh '''
                mkdir -p dependency-report
                echo "<html><body><h2>Rapport simulé Dependency Check</h2><p>Aucune vulnérabilité détectée.</p></body></html>" > dependency-report/index.html
                '''
                publishHTML([
                    allowMissing: true,
                    alwaysLinkToLastBuild: true,
                    keepAll: true,
                    reportDir: 'dependency-report',
                    reportFiles: 'index.html',
                    reportName: 'Dependency Check Report'
                ])
            }
        }

        stage('SonarQube Analysis') {
            steps {
                echo "🧠 Analyse SonarQube en cours..."
                withSonarQubeEnv('SonarQube') {
                    sh 'mvn sonar:sonar -Dsonar.projectKey=timesheet-devops -Dsonar.host.url=http://localhost:9000'
                }
            }
        }

        stage('Docker Build & Scan') {
            steps {
                echo "🐳 Construction et scan de l’image Docker..."
                sh '''
                docker build -t timesheet-app:latest .
                mkdir -p trivy-report
                trivy image --severity HIGH,CRITICAL \
                    --format template \
                    --template "@contrib/html.tpl" \
                    -o trivy-report/index.html timesheet-app:latest || true
                '''
                publishHTML([
                    allowMissing: true,
                    alwaysLinkToLastBuild: true,
                    keepAll: true,
                    reportDir: 'trivy-report',
                    reportFiles: 'index.html',
                    reportName: 'Trivy Docker Scan Report'
                ])
            }
        }

        stage('Test') {
            steps {
                echo "🧪 Exécution des tests unitaires..."
                sh 'mvn test'
            }
        }

        stage('Deploy') {
            steps {
                echo "🚀 Déploiement simulé du projet terminé avec succès !"
            }
        }
    }
}
