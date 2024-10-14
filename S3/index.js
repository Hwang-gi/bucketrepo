const AWS = require('aws-sdk');
const fs = require('fs');
const path = require('path');

// AWS S3 설정
AWS.config.update({
  region: 'ap-northeast-2', // 사용할 AWS 리전
  accessKeyId: process.env.AWS_ACCESS_KEY_ID,
  secretAccessKey: process.env.AWS_SECRET_ACCESS_KEY
});

const s3 = new AWS.S3();

// 디렉토리 내의 모든 파일을 S3에 업로드하는 함수
const uploadDirectory = async (bucketName, dirPath, s3Path = '') => {
  const files = fs.readdirSync(dirPath);

  for (const file of files) {
    const localFilePath = path.join(dirPath, file);
    const s3FilePath = path.join(s3Path, file).replace(/\\/g, '/'); // Windows 경로를 UNIX 스타일로 변경

    if (fs.lstatSync(localFilePath).isDirectory()) {
      // 디렉토리인 경우 재귀 호출
      await uploadDirectory(bucketName, localFilePath, s3FilePath);
    } else {
      // 파일인 경우 S3에 업로드
      const fileContent = fs.readFileSync(localFilePath);
      const params = {
        Bucket: bucketName,
        Key: s3FilePath,
        Body: fileContent
      };

      try {
        await s3.upload(params).promise();
        console.log(`Uploaded: ${s3FilePath}`);
      } catch (error) {
        console.error(`Error uploading ${s3FilePath}: ${error.message}`);
      }
    }
  }
};

// JSP 디렉토리 경로 설정
const jspDirectoryPath = path.join(__dirname, 'jsp');

// 업로드 실행
uploadDirectory('gichangtest', jspDirectoryPath)
  .then(() => console.log('Upload completed successfully!'))
  .catch(error => console.error(`Upload failed: ${error.message}`));
