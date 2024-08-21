<%@ page import="java.io.*, java.net.URI, java.net.http.HttpClient, java.net.http.HttpRequest, java.net.http.HttpResponse, com.google.gson.Gson, com.google.gson.JsonObject, com.google.gson.JsonArray, com.google.gson.JsonElement" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>IPL News</title>
    <style>
        body { font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; margin: 0; padding: 0; background: #f9f9f9; }
        .container { max-width: 800px; margin: 20px auto; padding: 20px; background: #fff; border-radius: 10px; box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1); }
        .header { text-align: center; margin-bottom: 20px; padding-top: 20px; color: #333; font-size: 36px; font-weight: bold; font-family: 'Arial Black', sans-serif; text-transform: uppercase; letter-spacing: 2px; }
        .news-item { background: #f0f0f0; padding: 15px; margin-bottom: 15px; border-radius: 5px; box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1); }
        .news-item a { color: #007bff; text-decoration: none; font-weight: bold; }
        .news-item a:hover { text-decoration: underline; }
        @keyframes fadeIn { from { opacity: 0; } to { opacity: 1; } }
        .animated { animation: fadeIn 0.5s ease-out; }
    </style>
</head>
<body>
<div class='container'>
    <h1 class='header'>IPL News</h1>

    <%
        try {
            HttpRequest httpRequest = HttpRequest.newBuilder()
                    .uri(URI.create("https://latest-ipl-news.p.rapidapi.com/news"))
                    .header("X-RapidAPI-Key", "9e14d58d10mshfd48202ed63cb45p1fb76ejsn9d316db8e329")
                    .header("X-RapidAPI-Host", "latest-ipl-news.p.rapidapi.com")
                    .GET()
                    .build();

            HttpClient httpClient = HttpClient.newHttpClient();
            HttpResponse<String> apiResponse = httpClient.send(httpRequest, HttpResponse.BodyHandlers.ofString());

            if (apiResponse.statusCode() == 200) {
                String news = apiResponse.body();
                Gson gson = new Gson();
                JsonObject responseObject = gson.fromJson(news, JsonObject.class);

                JsonArray newsArray = responseObject.getAsJsonArray("thehindu");

                // Reverse the loop to display latest news on top
                for (int i = newsArray.size() - 1; i >= 0; i--) {
                    JsonObject newsItem = newsArray.get(i).getAsJsonObject();
                    String title = newsItem.get("title").getAsString();
                    String link = newsItem.get("url").getAsString();

                    out.println("<div class='news-item animated'><a href='" + link + "' target='_blank'>" + title + "</a></div>");
                }
            } else {
                out.println("<div class='news-item animated'>Error: Unexpected status code from API - " + apiResponse.statusCode() + "</div>");
            }
        } catch (IOException e) {
            out.println("<div class='news-item animated'>Error: " + e.getMessage() + "</div>");
        } catch (Exception e) {
            out.println("<div class='news-item animated'>Error: " + e.getMessage() + "</div>");
        }
    %>

</div>
</body>
</html>
