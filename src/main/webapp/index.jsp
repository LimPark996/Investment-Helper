<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List, java.util.Random, java.util.ArrayList, java.util.Collections, java.util.stream.Collectors,org.example.investment_guides.model.FAQ, org.example.investment_guides.model.YouTubeVideo" %>

<%
    List<FAQ> faqs = (List<FAQ>) application.getAttribute("faqs");
    if (faqs == null) {
        faqs = new ArrayList<>();
    }

    String selectedJob = request.getParameter("jobRole");

    List<FAQ> filteredFAQs;
    if (selectedJob != null && !selectedJob.isEmpty() && !"ALL".equals(selectedJob)) {
        filteredFAQs = faqs.stream()
                .filter(faq -> faq.getCategory().equalsIgnoreCase(selectedJob))
                .collect(Collectors.toList());
    } else {
        filteredFAQs = new ArrayList<>(faqs);
    }

    Random rand = new Random();
    Collections.shuffle(filteredFAQs, rand);
    int maxDisplay = Math.min(3, filteredFAQs.size());

    List<YouTubeVideo> recommendedVideos = (List<YouTubeVideo>) application.getAttribute("youtubeVideos");
    if (recommendedVideos == null || recommendedVideos.isEmpty()) {
        recommendedVideos = new ArrayList<>();
    } else {
        Collections.shuffle(recommendedVideos);
        recommendedVideos = recommendedVideos.subList(0, Math.min(2, recommendedVideos.size()));
    }

    String userQuestion = (String) session.getAttribute("question");
    String aiAnswer = (String) session.getAttribute("answer");
    boolean hasAnswer = (userQuestion != null && aiAnswer != null);
%>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>📈 해외 주식 투자 가이드</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.0/css/bootstrap.min.css" rel="stylesheet">
    <link href="<%=request.getContextPath()%>/assets/style.css" rel="stylesheet">
    <meta property="og:title" content="해외 주식 투자 가이드" />
    <meta property="og:description" content="미국 주식, ETF, 글로벌 투자 학습을 위한 가이드 제공." />
    <meta property="og:image" content="<%=request.getContextPath()%>/assets/stock_investment.png" />
    <meta property="og:url" content="<%=request.getContextPath()%>" />
</head>
<body>

<div class="container app-container">
    <div class="card intro-card text-center mb-4">
        <h1 class="display-5 fw-bold mb-3">📈 해외 주식 투자 가이드</h1>
        <p class="lead">글로벌 주식 시장을 쉽게 이해하고 현명하게 투자하세요.</p>
        <div class="text-center">
            <img id="main-image" src="<%=request.getContextPath()%>/images/stock_investment.webp">
        </div>
        <div class="rotating-text mt-3">
            <h5 id="rotatingText">"처음 시작하는 해외 주식? 지금 바로 가이드를 받아보세요!"</h5>
        </div>
    </div>

    <div class="container app-container">
        <div class="card question-form-card mb-4">
            <h3 class="mb-4 text-center">💡 해외 주식 관련 질문을 해보세요</h3>
            <form id="questionForm" action="<%=request.getContextPath()%>/answer" method="post">
                <div class="mb-3">
                    <input type="text" class="form-control" id="questionInput" name="question"
                           placeholder="예: 미국 ETF 초보자에게 추천할 상품은?" required>
                </div>

                <div class="mb-3">
                    <label for="jobRole">관심 분야 선택:</label>
                    <select class="form-select" id="jobRole" name="jobRole">
                        <option value="ALL" selected>모든 분야</option>
                        <option value="Growth Investor">성장주 투자자</option>
                        <option value="Dividend Investor">배당주 투자자</option>
                        <option value="ETF Trader">ETF 투자자</option>
                        <option value="Tech Analyst">기술 분석가</option>
                        <option value="Fundamental Analyst">기초 분석가</option>
                    </select>
                </div>

                <div class="mb-3">
                    <label for="modelType">모델 선택:</label>
                    <select class="form-select" id="modelType" name="modelType">
                        <option value="BASE" selected>기본 모델</option>
                        <option value="REASONING">추론 모델</option>
                    </select>
                </div>

                <div class="text-center">
                    <button id="submitButton" type="submit" class="btn btn-gradient">질문하기</button>
                </div>
                <div id="loadingSpinner" class="text-center mt-3 d-none">
                    <div class="spinner-border text-primary" role="status">
                        <span class="visually-hidden">Loading...</span>
                    </div>
                    <p class="mt-2">AI가 답변을 생성하는 중입니다...</p>
                </div>
            </form>
        </div>

        <div class="card response-card <%=(session.getAttribute("answer") != null) ? "show" : "d-none"%>">
            <h4 class="mb-3">📢 AI 해외 주식 가이드 답변:</h4>
            <% if (hasAnswer) { %>
            <p class="question-text"><strong>질문:</strong> <%= userQuestion %></p>
            <p id="answerText"><strong>답변:</strong> <%= aiAnswer.replace("\n", "<br>") %></p>
            <% } else { %>
            <p class="text-center">❌ AI가 답변을 생성하지 못했습니다. 다시 질문해 주세요.</p>
            <% } %>

            <% if (recommendedVideos != null && !recommendedVideos.isEmpty()) { %>
            <div class="youtube-section mt-4">
                <h4 class="mb-3 text-center">🎥 해외 주식 관련 유튜브 랜덤 영상</h4>
                <h6>검색된 키워드를 기반으로 추천된 영상입니다.</h6>
                <h6>알고리즘 오류로 잘못된 영상이 나올 수 있습니다. 주의!</h6>
                <div class="row">
                    <% for (YouTubeVideo video : recommendedVideos) { %>
                    <div class="col-md-6">
                        <div class="card p-3 text-center">
                            <h5>📌 <%= video.getTitle() %></h5>
                            <a href="<%= video.getUrl() %>" class="btn btn-outline-primary mt-2" target="_blank">영상 보기</a>
                        </div>
                    </div>
                    <% } %>
                </div>
            </div>
            <% } else { %>
            <div class="text-center mt-3">
                <p>❌ 추천할 유튜브 영상이 없습니다.</p>
            </div>
            <% } %>

            <div class="text-center mt-4">
                <button id="newQuestionBtn" class="btn btn-outline-primary">새로운 질문하기</button>
            </div>
        </div>

        <div class="faq-section mt-5">
            <h4 class="mb-3 text-center">📢 랜덤 해외 주식 FAQ</h4>
            <div class="row">
                <% if (!filteredFAQs.isEmpty()) { %>
                <% for (int i = 0; i < maxDisplay; i++) { %>
                <div class="col-md-4">
                    <div class="card p-3 text-center">
                        <h5>💡 <%= filteredFAQs.get(i).getQuestion() %></h5>
                        <a href="faq.jsp?id=<%= i %>" class="btn btn-outline-primary mt-2">자세히 보기</a>
                    </div>
                </div>
                <% } %>
                <% } else { %>
                <div class="text-center">
                    <p>❌ 선택한 분야에 대한 FAQ가 없습니다.</p>
                </div>
                <% } %>
            </div>
        </div>
    </div>
</div>
<script>
    const rotatingTexts = [
        "처음 시작하는 해외 주식? 지금 바로 가이드를 받아보세요!",
        "AI에게 질문하고, ETF부터 분석까지 쉽게 알아보세요!",
        "글로벌 투자, 이제 어렵지 않아요! 🌎",
        "미국 배당주, ETF 투자 전략이 궁금하다면 지금 확인하세요!"
    ];

    let currentTextIndex = 0;
    const rotatingTextElement = document.getElementById('rotatingText');

    setInterval(() => {
        currentTextIndex = (currentTextIndex + 1) % rotatingTexts.length;
        rotatingTextElement.style.opacity = 0;
        setTimeout(() => {
            rotatingTextElement.textContent = rotatingTexts[currentTextIndex];
            rotatingTextElement.style.opacity = 1;
        }, 500);
    }, 4000);

    document.getElementById("questionForm").addEventListener("submit", function (event) {
        document.getElementById("loadingSpinner").classList.remove("d-none");
        document.getElementById("submitButton").disabled = true;
    });

    document.getElementById('newQuestionBtn').addEventListener('click', function() {
        document.querySelector('.response-card').classList.add('d-none');
    });
</script>
</body>
</html>
