pipeline{
    agent {label 'master'}
    stages{
        stage('TF Init'){
            steps{
                sh '''
                cd /data/projects/terraform/libvirt-cinit
                terraform init
                '''
            }
        }
        stage('TF Plan'){
            steps{
                sh '''
                cd /data/projects/terraform/libvirt-cinit
                terraform plan -out deploy
                '''
            }
        }

        stage('Approval') {
            steps {
                script {
                    def userInput = input(id: 'Deploy', message: 'Do you want to deploy?', parameters: [ [$class: 'BooleanParameterDefinition', defaultValue: false, description: 'Apply terraform', name: 'confirm'] ])
                }
           }
        }
        stage('TF Apply'){
            steps{
                sh '''
                cd /data/projects/terraform/libvirt-cinit
                terraform apply deploy
                '''
            }
        }
    }
}




