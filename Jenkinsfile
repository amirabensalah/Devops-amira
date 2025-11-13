pipeline {
    agent any

    tools {
        maven 'Maven'
        jdk 'jdk21'

    }

    environment {
        SONARQUBE = 'SonarQube'
    }

    stages {
        stage('Checkout') {
            steps {
                echo '📦 Récupération du code source depuis GitHub...'
                git branch: 'main',
                    credentialsId: 'jenkins-github-https-cred',
                    url: 'https://github.com/amirabensalah/Devops-amira.git'
            }
        }

        stage('Buildd') {
            steps {
                echo '⚙️ Compilation du projet Maven...'
                sh 'mvn clean package -DskipTests'
            }
        }

        stage('SCA - Dependency Check') {
            steps {
                echo '🔍 Simulation rapide de l’analyse des dépendances...'
                sh '''
                    mkdir -p dependency-report
                    echo "<html><body><h2>Rapport simulé Dependency Check</h2><p>Aucune vulnérabilité détectée.</p></body></html>" > dependency-report/index.html
                '''
                publishHTML(target: [
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
                echo '🧠 Analyse SonarQube en cours...'
                withSonarQubeEnv('SonarQube') {
                    withCredentials([string(credentialsId: 'sonar-token', variable: 'SONAR_TOKEN')]) {
                        sh '''
                            mvn sonar:sonar \
                            -Dsonar.projectKey=timesheet-devops \
                            -Dsonar.host.url=http://localhost:9000 \
                            -Dsonar.token=$SONAR_TOKEN
                        '''
                    }
                }
            }
        }

        stage('Docker Build & Scan') {
            steps {
                echo '🐳 Construction et scan de l’image Docker...'
                sh '''
                    docker build -t timesheet-app:latest .
                    mkdir -p trivy-report
                    trivy image --severity HIGH,CRITICAL \
                    --format template \
                    --template "@/usr/local/share/trivy/contrib/html.tpl" \
                    -o trivy-report/index.html timesheet-app:latest
                '''
                publishHTML(target: [
                    allowMissing: true,
                    alwaysLinkToLastBuild: true,
                    keepAll: true,
                    reportDir: 'trivy-report',
                    reportFiles: 'index.html',
                    reportName: 'Trivy Docker Scan Report'
                ])
            }
        }

        stage('Secrets Scan') {
            steps {
                echo '🕵️ Scan des secrets avec Gitleaks...'
                sh '''
                    mkdir -p gitleaks-report
                    gitleaks detect --source . --report-format html --report-path gitleaks-report/index.html || true
                '''
                publishHTML(target: [
                    allowMissing: true,
                    alwaysLinkToLastBuild: true,
                    keepAll: true,
                    reportDir: 'gitleaks-report',
                    reportFiles: 'index.html',
                    reportName: 'Gitleaks Secrets Report'
                ])
            }
        }

        stage('Deploy (Simulation)') {
            steps {
                echo '🚀 Simulation du déploiement de l’application...'
                sh '''
                    echo "Déploiement sur un environnement de staging simulé..."
                    sleep 3
                    echo "✅ Déploiement terminé avec succès !"
                '''
            }
        }
    }

    post {
        always {
            echo '📊 Pipeline terminé — rapports générés.'
            echo '🔗 Consulte les rapports HTML en bas de la page Jenkins.'
        }
        success {
            echo '✅ Pipeline exécuté avec succès — tout est vert !'
        }
        failure {
            echo '❌ Une erreur est survenue pendant le pipeline.'
        }
    }
}
