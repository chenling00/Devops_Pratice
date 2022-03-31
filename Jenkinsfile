pipeline {
    agent any


    environment {
        Version = '0.0.1'  
    }
    parameters {

        booleanParam(defaultValue: false,   description:  'Stop   Services',  name: 'Services')

    }    

    stages {
     


        stage("Run") {
            
            steps{

                script{

                    echo "Current version:${env.Version}"

                    sh'''
                    echo "Hello world!!!"
                    '''
                    sh 'echo "hello world 2"'

                    sh 'sh test.sh'

                }
            }
        }        

    }
   
}