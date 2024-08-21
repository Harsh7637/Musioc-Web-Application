package com.radio;

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

@WebServlet("/TopRadioStationsServlet")
public class TopRadioStationsServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html");
        PrintWriter out = response.getWriter();

        try {
            HttpRequest httpRequest = HttpRequest.newBuilder()
                    .uri(new URI("https://radio-world-75-000-worldwide-fm-radio-stations.p.rapidapi.com/all_radios.php?limit=10&order=ASC&page=1&random=false"))
                    .header("X-RapidAPI-Key", "9e14d58d10mshfd48202ed63cb45p1fb76ejsn9d316db8e329")
                    .header("X-RapidAPI-Host", "radio-world-75-000-worldwide-fm-radio-stations.p.rapidapi.com")
                    .method("GET", HttpRequest.BodyPublishers.noBody())
                    .build();

            HttpResponse<String> apiResponse = HttpClient.newHttpClient().send(httpRequest, HttpResponse.BodyHandlers.ofString());

            out.println("<html><head><title>Top Radio Stations</title></head><body>");
            out.println("<h1>Top Radio Stations</h1>");
            out.println("<pre>" + apiResponse.body() + "</pre>");
            out.println("</body></html>");
        } catch (Exception e) {
            out.println("An error occurred: " + e.getMessage());
        }
    }
}
