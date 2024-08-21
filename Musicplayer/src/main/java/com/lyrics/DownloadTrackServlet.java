package com.lyrics;

import java.io.IOException;
import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/downloadTrackServlet")
public class DownloadTrackServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String trackName = request.getParameter("trackName");
        String apiKey = "9e14d58d10mshfd48202ed63cb45p1fb76ejsn9d316db8e329";
        String host = "spotify-scraper.p.rapidapi.com";
        String apiUrl = "https://spotify-scraper.p.rapidapi.com/v1/track/download?track=" + trackName;

        HttpRequest httpRequest = HttpRequest.newBuilder()
                .uri(URI.create(apiUrl))
                .header("X-RapidAPI-Key", apiKey)
                .header("X-RapidAPI-Host", host)
                .GET()
                .build();

        try {
            HttpResponse<String> httpResponse = HttpClient.newHttpClient()
                    .send(httpRequest, HttpResponse.BodyHandlers.ofString());
            request.setAttribute("downloadResponse", httpResponse.body());
        } catch (InterruptedException | IOException e) {
            e.printStackTrace(); // Handle the exception properly in your application
        }

        request.getRequestDispatcher("jsonnn.jsp").forward(request, response);
    }
}
