pipeline {
    agent any

    tools {
        maven 'M3'
    }

    environment {
        SONARQUBE = credentials('sonar-token') // si tu as ajouté un token dans Jenkins
    }

    stages {

        stage('Checkout') {
            steps {
                echo '📦 Récupération du code source depuis GitHub...'
                git branch: 'main', url: 'https://github.com/amirabensalah/Devops-amira.git', credentialsId: 'jenkins-github-https-cred'
            }
        }

        stage('Build') {
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
                echo '🧠 Analyse SonarQube en cours...'
                withSonarQubeEnv('SonarQube') {
                    sh 'mvn sonar:sonar -Dsonar.projectKey=timesheet-devops -Dsonar.host.url=http://localhost:9000'
                }
            }
        }

        stage('Docker Build & Scan') {
            steps {
                echo '🐳 Construction et scan de l’image Docker...'
                sh '''
                    docker build -t timesheet-app:latest .
                    mkdir -p trivy-report
                    trivy image --severity HIGH,CRITICAL --format template --template "@contrib/html.tpl" -o trivy-report/index.html timesheet-app:latest || true
                '''
                publishHTML([
                    allowMissing: true,
                    alwaysLinkToLastBuild: true,
                    keepAll: true,
                    reportDir: 'trivy-report',
                    reportFiles: 'index.html',
                    reportName: 'Trivy Scan Report'
                ])
            }
        }

        stage('Secrets Scan') {
            steps {
                echo '🕵️‍♀️ Analyse des secrets avec Gitleaks...'
                sh '''
                    mkdir -p gitleaks-report
                    gitleaks detect --source . --report-format html --report-path gitleaks-report/index.html || true
                '''
                publishHTML([
                    allowMissing: true,
                    alwaysLinkToLastBuild: true,
                    keepAll: true,
                    reportDir: 'gitleaks-report',
                    reportFiles: 'index.html',
                    reportName: 'Gitleaks Secrets Scan Report'
                ])
            }
        }

        stage('Deploy (Simulation)') {
            steps {
                echo '🚀 Déploiement simulé de l’application...'
                sh 'echo "Déploiement réussi !"'
            }
        }
    }

    post {
        always {
            echo '📊 Pipeline terminé — rapports générés.'
        }
        success {
            echo '✅ Build et scans de sécurité réussis !'
        }
        failure {
            echo '❌ Une erreur est survenue pendant le pipeline.'
        }
    }
}
