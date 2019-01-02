podTemplate(
    label: 'devops2', 
    cloud: 'minikube',
    containers: [
        containerTemplate(name: 'docker', image: 'docker:dind', alwaysPullImage: true, args: 'cat', command: '/bin/sh -c', ttyEnabled: true),
        containerTemplate(name: 'bash', image: 'bash', alwaysPullImage: true, args: 'cat', command: '/bin/sh -c', ttyEnabled: true),
        containerTemplate(name: 'ansible', image: 'willhallonline/ansible', alwaysPullImage: true, args: 'cat', command: '/bin/sh -c', ttyEnabled: true),
        containerTemplate(name: 'k8s-kubectl', image: 'robarros/k8s-kubectl', alwaysPullImage: true, args: 'cat', command: '/bin/sh -c', ttyEnabled: true)],
        volumes: [hostPathVolume(mountPath: '/var/run/docker.sock', hostPath: '/var/run/docker.sock')]
)

{
def IMAGE_USER = "10.0.0.222:5000/"
def IMAGE_NAME = "app"
def IMAGE_VERSION
def IMAGE_FULL

node('devops2') {

  stage('Checkout') {
    echo 'Checkout do repositorio do GitLab'
    checkout([$class: 'GitSCM', branches: [[name: '*/master']], userRemoteConfigs: [[url: 'https://gitlab.com/robarros/devops-projeto.git']]])
    IMAGE_VERSION = sh returnStdout: true, script: "sh $WORKSPACE/scripts/get-tag.sh"    
    IMAGE_VERSION = IMAGE_VERSION.trim()
    IMAGE_FULL = "${IMAGE_USER}${IMAGE_NAME}:${IMAGE_VERSION}"
    }

  stage('Configs') {
    container('bash') {
      echo 'Alterado as Configuraçoes dos Arquivos do Deploy'      
      sh "echo ${IMAGE_FULL} > IMAGE_FULL.tag "
      sh returnStdout: true, script: 'sh $WORKSPACE/scripts/deploy.sh' 
      }}
  
  stage('Package') {
    container('docker') {
      echo 'Iniciando empacotamento com Docker'    
      sh "docker build -t ${IMAGE_FULL} ."
      sh "docker push ${IMAGE_FULL}"    
    }}

    stage('Ansible') {
      container('ansible') {
        echo 'Criar Pasta'    
        ansiblePlaybook become: true, credentialsId: 'docker-host', disableHostKeyChecking: true, inventory: '$WORKSPACE/ansible/hosts', playbook: '$WORKSPACE/ansible/playbook.yaml'
        sh "echo ${IMAGE_FULL}"
    }}

  
  stage('Deploy') {
    container('k8s-kubectl') {
      echo 'Executando o Deploy'
      withKubeConfig(clusterName: 'minikube', contextName: 'minikube', credentialsId: 'minikube', serverUrl: 'https://10.0.0.150:8443') {      
      try {
        sh "kubectl set image deployment app app=${IMAGE_FULL} --record=true"}
      catch(Exception e) {
        sh "kubectl create -f $WORKSPACE/kubernetes/Deployment.yaml --record=true"
        sh "kubectl create -f $WORKSPACE/kubernetes/Service.yaml --record=true"}
    }}}

 }}
