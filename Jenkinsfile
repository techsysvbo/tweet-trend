def registry = 'https://techsysvbo.jfrog.io'
def version   = '1.0.0'
def imageName = 'techsysvbo.jfrog.io/artifactory/valaxy-docker/hello-world'
pipeline {
    agent {
        node {
            label 'maven'
        }
    }
environment {
    PATH = "/opt/apache-maven-3.9.5/bin:$PATH"
}
    stages {
        stage("build"){
            steps {
                 echo "----------- build started ----------"
                sh 'mvn clean deploy -Dmaven.test.skip=true'
                 echo "----------- build completed ----------"
            }
        }
        stage("test"){
            steps{
                echo "----------- unit test started ----------"
                sh 'mvn surefire-report:report'
                 echo "----------- unit test Completed ----------"
            }
        }

  //   stage('SonarQube analysis') {
  //   environment {
  //     scannerHome = tool 'valaxy1-sonar-scanner'
  //   }
  //   steps{
  //   withSonarQubeEnv('valaxy1-sonarqube-server') { // If you have configured more than one global server connection, you can specify its name
  //     sh "${scannerHome}/bin/sonar-scanner"
  //   }
  //   }
  // }
//   stage("Quality Gate"){
//     steps {
//         script {
//         timeout(time: 1, unit: 'HOURS') { // Just in case something goes wrong, pipeline will be killed after a timeout
//     def qg = waitForQualityGate() // Reuse taskId previously collected by withSonarQubeEnv
//     if (qg.status != 'OK') {
//       error "Pipeline aborted due to quality gate failure: ${qg.status}"
//     }
//   }
// }
//     }
//   }
         stage("Jar Publish") {
        steps {
            script {
                    echo '<--------------- Jar Publish Started --------------->'
                     def server = Artifactory.newServer url:registry+"/artifactory" ,  credentialsId:"artifactory-cred"
                     def properties = "buildid=${env.BUILD_ID},commitid=${GIT_COMMIT}";
                     def uploadSpec = """{
                          "files": [
                            {
                              "pattern": "jarstaging/(*)",
                              "target": "libs-release/{1}",
                              "flat": "false",
                              "props" : "${properties}",
                              "exclusions": [ "*.sha1", "*.md5"]
                            }
                         ]
                     }"""
                     def buildInfo = server.upload(uploadSpec)
                     buildInfo.env.collect()
                     server.publishBuildInfo(buildInfo)
                     echo '<--------------- Jar Publish Ended --------------->'  
            
            }
        }   
    }


    stage(" Docker Build ") {
      steps {
        script {
           echo '<--------------- Docker Build Started --------------->'
           app = docker.build(imageName+":"+version)
           echo '<--------------- Docker Build Ends --------------->'
        }
      }
    }

            stage (" Docker Publish "){
        steps {
            script {
               echo '<--------------- Docker Publish Started --------------->'  
                docker.withRegistry(registry, 'artifactory-cred'){
                    app.push()
                }    
               echo '<--------------- Docker Publish Ended --------------->'  
            }
        }
    }

stage(" Deploy ") {
       steps {
         script {
            echo '<--------------- Helm Deploy Started --------------->'
            sh 'helm install ttrend ttrend-1.0.1.tgz'
            echo '<--------------- Helm Deploy Ends Here --------------->'
         }
       }
     }  
}
}
