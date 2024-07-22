pipeline {
    agent {
        label 'general'
    }

    triggers {
        githubPush()   // trigger the pipeline upon push event in github
    }

    options {
        timeout(time: 10, unit: 'MINUTES')  // discard the build after 10 minutes of running
        timestamps()  // display timestamp in console output
    }

    environment {
        IMAGE_TAG = "v1.0.$BUILD_NUMBER"
        IMAGE_BASE_NAME = "netflix-frontend-app"

        DOCKER_CREDS = credentials('dockerhub')
        DOCKER_USERNAME = "${DOCKER_CREDS_USR}"  // The _USR suffix added to access the username value
        DOCKER_PASS = "${DOCKER_CREDS_PSW}"      // The _PSW suffix added to access the password value
    }

    stages {
        stage('Docker setup') {
            steps {
                sh '''
                  docker login -u $DOCKER_USERNAME -p $DOCKER_PASS
                '''
            }
        }

        stage('Build & Push') {
            steps {
                script {
                    def IMAGE_FULL_NAME = "${DOCKER_USERNAME}/${IMAGE_BASE_NAME}:${IMAGE_TAG}"
                    sh '''
                      docker build -t ${IMAGE_FULL_NAME} .
                      docker push ${IMAGE_FULL_NAME}
                    '''
                    env.IMAGE_FULL_NAME = IMAGE_FULL_NAME // set IMAGE_FULL_NAME to the environment variable for the next stage
                }
            }
        }

        stage('Trigger Deploy') {
            steps {
                build job: 'netflixDeploy', wait: false, parameters: [
                    string(name: 'SERVICE_NAME', value: "NetflixFrontend"),
                    string(name: 'IMAGE_FULL_NAME_PARAM', value: "${env.IMAGE_FULL_NAME}")
                ]
            }
        }
    }
}
