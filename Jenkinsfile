podTemplate(
    label: 'devops1', 
    cloud: 'minikube',
    containers: [
        containerTemplate(name: 'docker', image: 'docker:dind', args: 'cat', command: '/bin/sh -c', ttyEnabled: true),
        containerTemplate(name: 'bash', image: 'bash', args: 'cat', command: '/bin/sh -c', ttyEnabled: true),
        containerTemplate(name: 'k8s-kubectl', image: 'robarros/k8s-kubectl', args: 'cat', command: '/bin/sh -c', ttyEnabled: true)],
        volumes: [hostPathVolume(mountPath: '/var/run/docker.sock', hostPath: '/var/run/docker.sock')]
)

{
def IMAGE_USER = "robarros/"
def IMAGE_NAME = "app"
def IMAGE_VERSION
def IMAGE_FULL


node('devops1') {

  stage('Checkout') {
    echo 'Checkout do repositorio do GitLab'
    checkout([$class: 'GitSCM', branches: [[name: '*/master']], userRemoteConfigs: [[url: 'https://gitlab.com/robarros/devops-projeto.git']]])
    IMAGE_VERSION = sh returnStdout: true, script: "git describe --tags `git rev-list --tags --max-count=1`"    
    IMAGE_VERSION = IMAGE_VERSION.trim()
    IMAGE_FULL = "${IMAGE_USER}${IMAGE_NAME}:${IMAGE_VERSION}"
    sh "echo ${IMAGE_FULL} > IMAGE_FULL.tag "
    }

  stage('Configs') {
    container('bash') {
      echo 'Alterado as Configuraçoes dos Arquivos do Deploy'
      sh returnStdout: true, script: 'sh deploy.sh' 
      sh 'cat Deployment.yaml'
      }}
  
  stage('Package') {
    container('docker') {
      echo 'Iniciando empacotamento com Docker'
      withCredentials([usernamePassword(credentialsId: 'dockerhub', passwordVariable: 'DOCKER_HUB_PASSWORD', usernameVariable: 'DOCKER_HUB_USER')]) {
      sh "docker login -u ${DOCKER_HUB_USER} -p ${DOCKER_HUB_PASSWORD}"
      sh "docker build -t ${DOCKER_HUB_USER}/${IMAGE_NAME}:${IMAGE_VERSION} ."
      sh "docker push ${DOCKER_HUB_USER}/${IMAGE_NAME}:${IMAGE_VERSION}"}    
    }}

  
  stage('Deploy') {
    container('k8s-kubectl') {
      echo 'Executando o Deploy'
      withKubeConfig(clusterName: 'minikube', contextName: 'minikube', credentialsId: 'minikube', serverUrl: 'https://10.0.0.150:8443') {      
      try {
        sh "kubectl set image deployment app app=${IMAGE_FULL} --record"}
      catch(Exception e) {
        sh "kubectl create -f Deployment.yaml --record"
        sh "kubectl create -f Service.yaml --record"}
    }}}

 }}
