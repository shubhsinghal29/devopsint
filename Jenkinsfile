pipeline{   
environment { // Global variables for the pipeline to be defined here
DOCKER_REG = "shubhsinghal29/devops"   
DOCKER_REG_CRED_ID = 'dockercred' //add docker hub credentials setup in jenkins global creds, here stored in a variable, to be used later in stages
image = ''    
}    
agent none      
stages {        
    stage('Build')    {          
        agent {
            node{                     
                label 'micro' // docker agent/slave name- change accordingly                      
                }              
                }
                 steps {
                     script{ env.buildname = input  message: 'Please input build name', parameters: [string(defaultValue:'', description: 'Enter a valid build name?', name: 'build name')], ok : 'Build Now',id :'choice_id'
                     }            
                     buildName env.buildname            
                     sh 'dotnet restore'          
                     sh 'dotnet build'        
                     archiveArtifacts artifacts: 'bin/Debug/net6.0/*.dll'             
                     stash includes: 'bin/Debug/net6.0/*.dll', name: 'build', useDefaultExcludes: false     
                     }
    }
                             stage('Unit Test') {      
                                 agent any       
                                 steps{         
                                     sh "echo 'success'"          
                                     
                                 }       
                                 }         
                                 stage("Building Docker Image"){          
                                     agent any        
                                     steps{         
                                         script {          
                                             unstash 'build'           
                                             sh 'ls -lrt'         
                                             def dockerImage = docker.build DOCKER_REG + ":$BUILD_NUMBER" + "-$env.buildname"           
                                             docker.withRegistry( '', DOCKER_REG_CRED_ID ) {            
                                                 dockerImage.push()      
                                                 }      
                                                 }        
                                                 }      
                                     
                                 }   
                                   
    
}
}
