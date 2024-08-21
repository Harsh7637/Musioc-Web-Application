package com.lyrics;
import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import javax.servlet.annotation.WebServlet;

import javax.servlet.*;
import javax.servlet.http.*;
import java.io.*;
import java.net.*;
import java.net.http.*;
import java.net.http.HttpResponse.BodyHandlers;
import org.json.*;


@WebServlet("/SongSearchServlet")
public class SongLyricsServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Retrieve user input from the request parameters
        String title = request.getParameter("title");
        String artist = request.getParameter("artist");

        try {
            // Construct the search query URL
            String searchQuery = URLEncoder.encode(title, "UTF-8");
            String url = "https://genius-song-lyrics1.p.rapidapi.com/search/?q=" + searchQuery + "&per_page=10&page=1";

            // Set up the HTTP request with required headers
            HttpClient httpClient = HttpClient.newHttpClient();
            HttpRequest httpRequest = HttpRequest.newBuilder()
                    .uri(URI.create(url))
                    .header("X-RapidAPI-Key", "9e14d58d10mshfd48202ed63cb45p1fb76ejsn9d316db8e329")
                    .header("X-RapidAPI-Host", "genius-song-lyrics1.p.rapidapi.com")
                    .method("GET", HttpRequest.BodyPublishers.noBody())
                    .build();

            // Send the HTTP request and get the response
            HttpResponse<String> apiResponse = httpClient.send(httpRequest, BodyHandlers.ofString());

            // Parse the JSON response
            JSONObject jsonResponse = new JSONObject(apiResponse.body());
            JSONArray hits = jsonResponse.getJSONArray("hits");

            // Find the song matching the artist and title
            String songTitle = null;
            String releaseDate = null;
            String artists = null;
            String urlLink = null;
            String pageviews = null;

            for (int i = 0; i < hits.length(); i++) {
                JSONObject hit = hits.getJSONObject(i);
                JSONObject result = hit.getJSONObject("result");

                // Check if the song matches the artist and title
                if (result.getString("title").equalsIgnoreCase(title) && result.getJSONArray("primary_artist").getJSONObject(0).getString("name").equalsIgnoreCase(artist)) {
                    songTitle = result.getString("title");
                    releaseDate = result.getString("release_date");
                    JSONArray artistsArray = result.getJSONArray("primary_artist");
                    StringBuilder artistsBuilder = new StringBuilder();
                    for (int j = 0; j < artistsArray.length(); j++) {
                        JSONObject artistObj = artistsArray.getJSONObject(j);
                        if (j > 0) {
                            artistsBuilder.append(", ");
                        }
                        artistsBuilder.append(artistObj.getString("name"));
                    }
                    artists = artistsBuilder.toString();
                    urlLink = result.getString("url");
                    pageviews = result.getJSONObject("stats").getString("pageviews");
                    break;
                }
            }

            // Set the song details as request attributes
            String songDetails = songTitle + " by " + artists + ":\n" +
                    "Release Date: " + releaseDate + "\n" +
                    "Artists: " + artists + "\n" +
                    "URL: " + urlLink + "\n" +
                    "Pageviews: " + pageviews;

            request.setAttribute("songDetails", songDetails);

            // Forward the request to the JSP for displaying the results
            RequestDispatcher dispatcher = request.getRequestDispatcher("songlyrics.jsp");
            dispatcher.forward(request, response);
        } catch (InterruptedException | JSONException e) {
            e.printStackTrace();
            response.getWriter().println("Error occurred: " + e.getMessage());
        }
    }
    }