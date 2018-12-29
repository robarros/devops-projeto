podTemplate(
    label: 'devops', 
    cloud: 'minikube',
    containers: [
        containerTemplate(name: 'docker', image: 'docker:dind', args: 'cat', command: '/bin/sh -c', ttyEnabled: true)],
        volumes: [hostPathVolume(mountPath: '/var/run/docker.sock', hostPath: '/var/run/docker.sock')]
)

{
def IMAGE_NAME = "app"
def IMAGE_VERSION

node('devops') {

  stage('Checkout') {
    echo 'Checkout do repositorio do GitLab'
    checkout([$class: 'GitSCM', branches: [[name: '*/master']], userRemoteConfigs: [[url: 'https://gitlab.com/robarros/devops-projeto.git']]])
    IMAGE_VERSION = sh returnStdout: true, script: 'sh get-tag.sh'
    IMAGE_VERSION = IMAGE_VERSION.trim()
    sh "echo ${IMAGE_NAME}:${IMAGE_VERSION}"
    }

  stage('Package') {
    container('docker') {
      echo 'Iniciando empacotamento com Docker'
      withCredentials([usernamePassword(credentialsId: 'dockerhub', passwordVariable: 'DOCKER_HUB_PASSWORD', usernameVariable: 'DOCKER_HUB_USER')]) {
      sh "docker login -u ${DOCKER_HUB_USER} -p ${DOCKER_HUB_PASSWORD}"
      sh "docker build -t ${DOCKER_HUB_USER}/${IMAGE_NAME}:${IMAGE_VERSION} ."
      sh "docker push ${DOCKER_HUB_USER}/${IMAGE_NAME}:${IMAGE_VERSION}"}    
    }}

}}



