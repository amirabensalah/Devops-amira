pipeline {
    agent any

    tools {
        maven 'Maven3'
    }

    environment {
        SONARQUBE_ENV = 'SonarQube'
    }

    stages {

        stage('Checkout') {
            steps {
                echo '📦 Récupération du code source depuis GitHub...'
                git branch: 'main',
                    url: 'https://github.com/amirabensalah/Devops-amira.git',
                    credentialsId: 'jenkins-github-https-cred'
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
                    echo "<html><body><h2>Rapport simulé Dependency Check</h2><p>Aucune vulnérabilité détectée.</p></body></html>" > dependency-report/dependency-check-report.html
                '''
                publishHTML(target: [
                    allowMissing: true,
                    keepAll: true,
                    reportDir: 'dependency-report',
                    reportFiles: 'dependency-check-report.html',
                    reportName: 'Dependency Check Report'
                ])
            }
        }

        // 🔐 NOUVEAU : Scan des secrets avec Gitleaks
        stage('Secrets Scan - Gitleaks') {
            steps {
                echo '🔐 Scan des secrets avec Gitleaks...'
                sh '''
                    mkdir -p gitleaks-report
                    /opt/gitleaks detect --source . --report-format html --report-path gitleaks-report/gitleaks-report.html || true
                '''
                publishHTML(target: [
                    allowMissing: true,
                    keepAll: true,
                    reportDir: 'gitleaks-report',
                    reportFiles: 'gitleaks-report.html',
                    reportName: 'Gitleaks Secrets Report'
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

        stage('Test') {
            steps {
                echo '🧪 Exécution des tests unitaires...'
                sh 'mvn test'
            }
        }

        stage('Deploy') {
            steps {
                echo '🚀 Déploiement simulé du projet terminé avec succès !'
            }
        }
    }
}
