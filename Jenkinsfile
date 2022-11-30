pipeline {
  environment {
    registry = "pratush43/dock"
    registryCredential = 'dockerhub'
    image = '' 
  }
      
  agent none
    stages {
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
          
      }

     
  }
    }
      stage('validate') {
        steps {
            timeout(30) {
                script {
                    CHOICES = ["deploy", "rollback"];    
                        env.yourChoice = input  message: 'Please validate, this job will automatically ABORTED after 30 minutes even if no user input provided', ok : 'Proceed',id :'choice_id',
                                        parameters: [choice(choices: CHOICES, description: 'Do you want to deploy or to rollback?', name: 'CHOICE'),
                                            string(defaultValue: 'rollback', description: '', name: 'rollback value')]
                        } 

                }
            }
        }
    stage('Deploy image'){
      agent {
        node{
       label 'deployment' 
        }
      }
      
      steps{
        script{
                    
                   
        image = "$registry" + ":$BUILD_NUMBER"
            sh "docker run -d -p 8082:8081 '$image'"
      }
      }

    }
    }
    }
