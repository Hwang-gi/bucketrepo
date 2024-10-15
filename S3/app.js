const express = require('express');
const axios = require('axios');
const app = express();
const port = process.env.PORT || 3000;

// Tomcat 서버 URL
const tomcatBaseUrl = 'http://localhost:8080'; // Tomcat이 사용하는 기본 포트는 8080입니다.

// JSP 파일 제공을 위한 라우트
app.get('/jsp/:filename', async (req, res) => {
    const filename = req.params.filename;
    const fileUrl = `${tomcatBaseUrl}/yourApp/${filename}`; // Tomcat 애플리케이션의 경로를 설정

    try {
        // Tomcat에서 JSP 파일 가져오기
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
