pipeline {
    agent any
    
    // מאפשר לבחור בין הקמה למחיקה בהרצה ידנית (Build with Parameters)
    parameters {
        choice(name: 'ACTION', choices: ['apply', 'destroy'], description: 'בחר האם להקים או למחוק את התשתית')
    }

    environment {
        AWS_DEFAULT_REGION = 'us-east-1'
    }

    stages {
        stage('Checkout') {
            steps {
                // מוריד את הקוד מה-Repository
                checkout scm
            }
        }
        
        stage('Terraform Init') {
            steps {
                bat 'terraform init'
            }
        }

        stage('Terraform Action') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'aws-credentials-global', 
                                                 passwordVariable: 'AWS_SECRET_ACCESS_KEY', 
                                                 usernameVariable: 'AWS_ACCESS_KEY_ID')]) {
                    script {
                        if (params.ACTION == 'apply') {
                            bat 'terraform apply -auto-approve'
                        } else {
                            bat 'terraform destroy -auto-approve'
                        }
                    }
                }
            }
        }

        stage('Run Ansible Playbook') {
            // השלב הזה ירוץ רק אם בחרנו להקים את המכונה (apply)
            when { expression { params.ACTION == 'apply' } }
            steps {
                script {
                    // שליפת ה-IP מ-Terraform בסביבת Windows
                    def instanceIp = bat(script: "terraform output -raw instance_ip", returnStdout: true).trim()
                    
                    // הסרת שורות מיותרות ש-bat עלול להחזיר כדי לקבל רק את ה-IP נקי
                    def ipLines = instanceIp.readLines()
                    def cleanIp = ipLines[ipLines.size() - 1].trim()

                    // יצירת קובץ ה-Inventory הדינמי
                    writeFile file: 'inventory_fixed.ini', text: "[all]\n${cleanIp}"
                    
                    // הרצת ה-Playbook עם ה-Credentials של ה-SSH
                    withCredentials([sshUserPrivateKey(credentialsId: 'aws-ssh-key', 
                                                     keyFileVariable: 'SSH_KEY', 
                                                     usernameVariable: 'SSH_USER')]) {
                        bat """
                            set ANSIBLE_CONFIG=./ansible.cfg
                            set ANSIBLE_HOST_KEY_CHECKING=False
                            ansible-playbook -i inventory_fixed.ini instance.yml --user %SSH_USER% --private-key %SSH_KEY%
                        """
                    }
                }
            }
        }
    }

    post {
        success {
            script {
                // הצגת הכתובת רק אם המכונה הוקמה בהצלחה
                if (params.ACTION == 'apply') {
                    def instanceIp = bat(script: "terraform output -raw instance_ip", returnStdout: true).trim()
                    def ipLines = instanceIp.readLines()
                    def finalIp = ipLines[ipLines.size() - 1].trim()
                    
                    echo "-----------------------------------------------------------"
                    echo "DEPLOYMENT SUCCESSFUL!"
                    echo "New VM IP Address: ${finalIp}"
                    echo "Web URL: http://${finalIp}/web/index.html"
                    echo "-----------------------------------------------------------"
                } else {
                    echo "-----------------------------------------------------------"
                    echo "INFRASTRUCTURE DESTROYED SUCCESSFULLY"
                    echo "-----------------------------------------------------------"
                }
            }
        }
        always {
            script {
                // ניקוי קבצים זמניים בסגנון Windows (בדיקה אם הקובץ קיים לפני מחיקה)
                if (fileExists('inventory_fixed.ini')) {
                    bat 'del /f /q inventory_fixed.ini'
                }
            }
        }
    }
}
