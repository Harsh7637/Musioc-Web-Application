<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Song Search</title>
</head>
<body>
    <h1>Song Search</h1>
    <form action="SongSearchServlet" method="get">
        <label for="title">Enter Song Title:</label>
        <input type="text" id="title" name="title">
        <br>
        <label for="artist">Enter Artist Name:</label>
        <input type="text" id="artist" name="artist">
        <br>
        <input type="submit" value="Search">
    </form>

    <%
        // Retrieve data from request attributes
        String songTitle = (String) request.getAttribute("songTitle");
        String releaseDate = (String) request.getAttribute("releaseDate");
        String artists = (String) request.getAttribute("artists");
        String url = (String) request.getAttribute("url");
        String pageviews = (String) request.getAttribute("pageviews");
    
        // Display song details if available
        if (songTitle != null) {
    %>
            <h2><%= songTitle %></h2>
            <p>Release Date: <%= releaseDate %></p>
            <p>Artists: <%= artists %></p>
            <p>URL: <a href="<%= url %>"><%= songTitle %> by <%= artists %></a></p>
            <p>Pageviews: <%= pageviews %></p>
    <%
        }
    %>
</body>
</html>s
