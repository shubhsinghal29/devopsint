pipeline {
  environment {
    registry = "pratush43/dock"
    registryCredential = 'dockerhub'
    image = '' 
  }
  agent none
    stages {
      stage('validate') {
        steps {
            timeout(30) {
                script {
                    CHOICES = ["Test environment", "Production environment", "Development environment"];    
                        env.yourChoice = input  message: 'Please validate, this job will automatically ABORTED after 30 minutes even if no user input provided', parameters: [choice(choices: CHOICES, description: 'What environment do you want to deploy to?', name: 'CHOICE')], ok : 'Proceed',id :'choice_id'
                                        
                        } 

                }
            }
        }
        stage('Build') {
          agent {
    node{
    label 'micro'
    } 
  }
            steps {
                sh 'dotnet build'
              sh ' ls -lrt && pwd'
              archiveArtifacts artifacts: 'bin/Debug/net6.0/*.dll'
              stash includes: 'bin/Debug/net6.0/*.dll', name: 'build', useDefaultExcludes: false
            }
        }
        stage("docker image"){
           agent any
      steps{
        script {
          unstash 'build'
         def dockerImage = docker.build registry + ":$BUILD_NUMBER"
          docker.withRegistry( '', registryCredential ) {
            dockerImage.push()
        }
      }

     
  }
    }
    stage('Deploy image on Development'){
      when {
            expression { env.yourChoice == 'Development environment' }
        }
      agent {
        node{
       label 'deployment' 
        }
      }
      
      steps{
        script{
                    
                   
        image = "$registry" + ":$BUILD_NUMBER"
            sh "docker run -d -p 8092:8081 '$image'"
      }
      }

    }
    stage('Deploy image on Production'){
      when {
            expression { env.yourChoice == 'Production environment' }
        }
      agent {
        node{
       label 'deployment' 
        }
      }
      
      
      steps{
        script{
                    
                   
        image = "$registry" + ":$BUILD_NUMBER"
            sh "docker run -d -p 8093:8081 '$image'"
      }
      }

    }
    stage('Deploy image on Test'){
      when {
            expression { env.yourChoice == 'Test environment' }
        }
      agent {
        node{
       label 'deployment' 
        }
      }
      
      steps{
        script{
          sh "chmod +x docker-registry-list.py"
            sh "ls -lrt"        
            sh "./docker-registry-list.py pratush43/dock"       
        image = "$registry" + ":$BUILD_NUMBER"
            sh "docker run -d -p 8094:8081 '$image'"
      }
      }

    }
    }
    }
