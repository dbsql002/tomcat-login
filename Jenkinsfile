//젠킨스 NHN NCR
pipeline {
    agent any  // 어떤 에이전트에서 실행할 지 지정, 여기서는 모든 에이전트에서 실행 가능

    environment {
        NHN_DEFAULT_REGION = 'kr1'  // NCR 지역
        NHN_REGISTRY_URL = '0a522ceb-kr1-registry.container.nhncloud.com/tomcat-login'  // NCR 레지스트리 퍼블릭 URL
        NCR_IMAGE_NAME = '${BUILD_NUMBER}'  // NCR 이미지 이름, 빌드 번호로 설정
        IMAGE_TAG = "${BUILD_NUMBER}"  // 이미지 태그, 빌드 번호로 설정
        DOCKERFILE_PATH = 'Dockerfile'  // Dockerfile 경로
        DOCKER_IMAGE_NAME = 'tomcat-login'  // Docker 이미지 이름
        NHN_ACCESS_KEY = '"${{ secrets.NCR_ACCESS_KEY }}"' // NHN Cloud Access Key, NHN 계정의 Access Key
        NHN_SECRET_KEY = '"${{ secrets.NCR_SECRET_KEY }}"' // NHN Cloud Secret Key, NHN 계정의 Secret Key
    }

    stages {
        stage('Build') {  // 빌드 단계 정의
            steps {
                script {
                    // Docker 이미지 빌드 with --no-cache=true 옵션
                    def customImage = docker.build("${DOCKER_IMAGE_NAME}:${IMAGE_TAG}", "--no-cache=true -f ${DOCKERFILE_PATH} .")

                    // NHN Cloud NCR에 로그인 및 이미지 푸시
                    sh "docker login ${NHN_REGISTRY_URL} -u ${NHN_ACCESS_KEY} -p ${NHN_SECRET_KEY}"
                    sh "docker tag ${DOCKER_IMAGE_NAME}:${IMAGE_TAG} ${NHN_REGISTRY_URL}/${NCR_IMAGE_NAME}:${IMAGE_TAG}"
                    sh "docker push ${NHN_REGISTRY_URL}/${NCR_IMAGE_NAME}:${IMAGE_TAG}"
                }
            }
        }
    }

    post {
        success {
            echo "빌드 및 NCR 푸시 성공, 이미지 버전: ${IMAGE_TAG}"  // 성공 시 메시지 출력
        }
        failure {
            echo '빌드 또는 NCR 푸시 실패'  // 실패 시 메시지 출력
        }
    }
}
