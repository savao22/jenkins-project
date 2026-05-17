pipeline {
    agent any
    
    parameters {
        choice(name: 'ACTION', choices: ['apply', 'destroy'], description: 'בחר האם להקים או למחוק את התשתית')
    }

    environment {
        AWS_DEFAULT_REGION = 'us-east-1'
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }
        
        stage('Terraform Init') {
            steps {
                sh 'terraform init'
            }
        }

        stage('Terraform Action') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'aws-credentials-global', 
                                                 passwordVariable: 'AWS_SECRET_ACCESS_KEY', 
                                                 usernameVariable: 'AWS_ACCESS_KEY_ID')]) {
                    script {
                        if (params.ACTION == 'apply') {
                            sh 'terraform apply -auto-approve'
                        } else {
                            sh 'terraform destroy -auto-approve'
                        }
                    }
                }
            }
        }

        stage('Run Ansible Playbook') {
            when { expression { params.ACTION == 'apply' } }
            steps {
                script {
                    def instanceIp = sh(script: "terraform output -raw instance_ip", returnStdout: true).trim()
                    writeFile file: 'inventory_fixed.ini', text: "[all]\n${instanceIp}"
                    
                    withCredentials([sshUserPrivateKey(credentialsId: 'aws-ssh-key', 
                                                       keyFileVariable: 'SSH_KEY', 
                                                       usernameVariable: 'SSH_USER')]) {
                        sh """
                            export ANSIBLE_CONFIG=./ansible.cfg
                            export ANSIBLE_HOST_KEY_CHECKING=False
                            ansible-playbook -i inventory_fixed.ini instance.yml --user "${SSH_USER}" --private-key "${SSH_KEY}"
                        """
                    }
                }
            }
        }
    }

    post {
        success {
            script {
                if (params.ACTION == 'apply') {
                    def finalIp = sh(script: "terraform output -raw instance_ip", returnStdout: true).trim()
                    echo "-----------------------------------------------------------"
                    echo "DEPLOYMENT SUCCESSFUL!"
                    echo "New VM IP Address: ${finalIp}"
                    echo "Web URL: http://${finalIp}/web/index.php"
                    echo "-----------------------------------------------------------"
                } else {
                    echo "-----------------------------------------------------------"
                    echo "INFRASTRUCTURE DESTROYED SUCCESSFULLY"
                    echo "-----------------------------------------------------------"
                }
            }
        }
        always {
            sh 'rm -f inventory_fixed.ini'
        }
    }
}
