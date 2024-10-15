const express = require('express');
const axios = require('axios');
const app = express();
const port = process.env.PORT || 3000;

// S3 버킷 URL
const bucketName = 'gichangtest'; // 사용 중인 버킷 이름
const s3BaseUrl = `https://${bucketName}.s3.amazonaws.com`;

// JSP 파일 제공을 위한 라우트
app.get('/jsp/:filename', async (req, res) => {
    const filename = req.params.filename;
    const fileUrl = `${s3BaseUrl}/${filename}`;

    try {
        // S3에서 JSP 파일 가져오기
        const response = await axios.get(fileUrl, {
            responseType: 'text' // 응답을 텍스트로 받기
        });

        // JSP 파일 반환
        res.header('Content-Type', 'text/html'); // 적절한 MIME 타입 설정
        res.send(response.data);
    } catch (error) {
        console.error(`Error fetching JSP file: ${error.message}`);
        res.status(404).send('File not found');
    }
});

// 서버 시작
app.listen(port, () => {
    console.log(`Server is running on http://localhost:${port}`);
});
