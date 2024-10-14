const AWS = require('aws-sdk');

// AWS S3 설정
AWS.config.update({
    region: 'ap-northeast-2', // 사용하려는 AWS 리전
    accessKeyId: process.env.AWS_ACCESS_KEY_ID,
    secretAccessKey: process.env.AWS_SECRET_ACCESS_KEY
});

const s3 = new AWS.S3();

// S3 버킷에서 파일 목록 가져오기
const listFiles = async (bucketName) => {
    const params = {
        Bucket: bucketName
    };

    try {
        const data = await s3.listObjectsV2(params).promise();
        console.log('Files in bucket:', data.Contents);
    } catch (error) {
        console.error(`Error fetching files: ${error.message}`);
    }
};

// S3에서 파일 다운로드
const downloadFile = async (bucketName, keyName) => {
    const params = {
        Bucket: bucketName,
        Key: keyName
    };

    try {
        const data = await s3.getObject(params).promise();
        const fileContent = data.Body.toString('utf-8'); // 파일 내용을 문자열로 변환
        console.log(`File content of ${keyName}:`, fileContent);
    } catch (error) {
        console.error(`Error downloading file: ${error.message}`);
    }
};