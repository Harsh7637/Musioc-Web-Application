<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page import="org.json.JSONObject, org.json.JSONArray" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Download Track</title>
</head>
 <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 0;
            background-color: #f9f9f9;
        }
        .container {
            max-width: 800px;
            margin: 0 auto;
            padding: 20px;
        }
        h1 {
            text-align: center;
            color: #333;
        }
        form {
            text-align: center;
            margin-bottom: 20px;
        }
        input[type="text"] {
            padding: 5px;
            font-size: 16px;
            width: 200px;
        }
        button {
            padding: 5px 10px;
            font-size: 16px;
            background-color: #007bff;
            color: white;
            border: none;
            cursor: pointer;
        }
        button:hover {
            background-color: #0056b3;
        }
        .download-response {
            margin-top: 20px;
            padding: 10px;
            background-color: #fff;
            border: 1px solid #ddd;
            border-radius: 5px;
        }
        .audio-item {
            margin-bottom: 20px;
            padding: 10px;
            background-color: #f3f3f3;
            border-radius: 5px;
        }
        .audio-link {
            display: inline-block;
            margin-right: 10px;
            padding: 5px 10px;
            font-size: 14px;
            color: #007bff;
            text-decoration: none;
            border: 1px solid #007bff;
            border-radius: 5px;
            cursor: pointer;
        }
        .audio-link:hover {
            background-color: #007bff;
            color: white;
            text-decoration: none;
        }
    </style>

<body>
    <h1>Download Track</h1>
    <form action="downloadTrackServlet" method="get">
        <label for="trackName">Track Name:</label>
        <input type="text" id="trackName" name="trackName">
        <button type="submit">Download</button>
    </form>
    <div>
        <%-- Display download response --%>
        <c:if test="${not empty requestScope.downloadResponse}">
            <% 
                String downloadResponse = (String)request.getAttribute("downloadResponse");
                JSONObject jsonResponse = new JSONObject(downloadResponse);
                JSONObject youtubeVideo = jsonResponse.getJSONObject("youtubeVideo");
                String searchTerm = youtubeVideo.getString("searchTerm");
                String videoId = youtubeVideo.getString("id");
                String title = youtubeVideo.getString("title");

                JSONArray audioArray = youtubeVideo.getJSONArray("audio");
                for (int i = 0; i < audioArray.length(); i++) {
                    JSONObject audioObj = audioArray.getJSONObject(i);
                    String audioUrl = audioObj.getString("url");
                    String durationText = audioObj.getString("durationText");
                    // Display parsed data
                    out.println("<div class=\"audio-item\">");
                    out.println("<a href=\"" + audioUrl + "\" download>Download</a>");
                    out.println("<a href=\"#\" class=\"audio-link\" data-audio=\"" + audioUrl + "\">Play</a>");
                    out.println("<span>Duration: " + durationText + "</span>");
                    out.println("<audio class=\"audio-player\" src=\"" + audioUrl + "\"></audio>");
                    out.println("</div>");
                }

                JSONObject spotifyTrack = jsonResponse.getJSONObject("spotifyTrack");
                String trackName = spotifyTrack.getString("name");
                String shareUrl = spotifyTrack.getString("shareUrl");
                // Display parsed data
                out.println("<p><a href=\"" + shareUrl + "\">Track Name: " + trackName + "</a></p>");
                out.println("<p>Spotify Share URL: " + shareUrl + "</p>");
            %>
        </c:if>
    </div>
    <script>
    document.addEventListener("DOMContentLoaded", function() {
        var audioLinks = document.querySelectorAll(".audio-link");
        audioLinks.forEach(function(link) {
            link.addEventListener("click", function(e) {
                e.preventDefault();
                var audioUrl = this.getAttribute("data-audio");
                var audioPlayers = document.querySelectorAll(".audio-player");
                audioPlayers.forEach(function(player) {
                    player.pause();
                    player.currentTime = 0;
                });
                var audioPlayer = this.parentElement.querySelector(".audio-player");
                audioPlayer.src = audioUrl;
                audioPlayer.play();
            });
        });
    });


    </script>
</body>
</html>
