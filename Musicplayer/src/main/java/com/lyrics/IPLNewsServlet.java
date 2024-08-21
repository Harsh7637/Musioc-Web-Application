package com.lyrics;

import java.io.IOException;
import java.io.PrintWriter;
import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.google.gson.Gson;
import com.google.gson.JsonArray;
import com.google.gson.JsonElement;
import com.google.gson.JsonObject;

@WebServlet("/iplnews")
public class IPLNewsServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("text/html");
        PrintWriter out = response.getWriter();

        out.println("<html><head><title>IPL News</title>");
        out.println("<style>");
        out.println("body { font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; margin: 0; padding: 0; background: #f9f9f9; }");
        out.println(".container { max-width: 800px; margin: 20px auto; padding: 20px; background: #fff; border-radius: 10px; box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1); }");
        out.println(".header { text-align: center; margin-bottom: 20px; padding-top: 20px; color: #333; font-size: 36px; font-weight: bold; font-family: 'Arial Black', sans-serif; text-transform: uppercase; letter-spacing: 2px; }");
        out.println(".news-item { background: #f0f0f0; padding: 15px; margin-bottom: 15px; border-radius: 5px; box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1); }");
        out.println(".news-item a { color: #007bff; text-decoration: none; font-weight: bold; }");
        out.println(".news-item a:hover { text-decoration: underline; }");
        out.println("@keyframes fadeIn { from { opacity: 0; } to { opacity: 1; } }");
        out.println(".animated { animation: fadeIn 0.5s ease-out; }");
        out.println("</style>");
        out.println("</head><body>");
        out.println("<div class='container'>");
        out.println("<h1 class='header'>IPL News</h1>");

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
                JsonArray newsArray = gson.fromJson(news, JsonArray.class);

                for (JsonElement element : newsArray) {
                    JsonObject newsItem = element.getAsJsonObject();
                    String title = newsItem.get("title").getAsString();
                    String link = newsItem.get("url").getAsString();

                    out.println("<div class='news-item animated'><a href='" + link + "' target='_blank'>" + title + "</a></div>");
                }
            } else {
                out.println("<div class='news-item animated'>Error: Unexpected status code from API - " + apiResponse.statusCode() + "</div>");
            }
        } catch (Exception e) {
            out.println("<div class='news-item animated'>Error: " + e.getMessage() + "</div>");
        }

        out.println("</div></body></html>");
    }
}
