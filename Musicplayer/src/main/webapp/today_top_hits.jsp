<%@ page import="java.sql.*, java.util.List, com.harsh.Song, java.util.ArrayList" %>
<%
    String songId = request.getParameter("songId");
    List<Song> songs = new ArrayList<>();

    if (songId == null || songId.isEmpty()) {
        // Fetch all songs from the database
        try {
            // Load the MySQL JDBC driver
            Class.forName("com.mysql.cj.jdbc.Driver");

            // Connect to the database
            String url = "jdbc:mysql://localhost:3306/musicplayer";
            String username = "root";
            String password = "root";
            Connection connection = DriverManager.getConnection(url, username, password);

            // Query the database to fetch all songs
            String query = "SELECT * FROM songs";
            PreparedStatement statement = connection.prepareStatement(query);
            ResultSet resultSet = statement.executeQuery();

            // Process the result set
            while (resultSet.next()) {
                String id = resultSet.getString("id");
                String backgroundImage = resultSet.getString("backgroundImage");
                String posterUrl = resultSet.getString("posterUrl");
                String title = resultSet.getString("title");
                String album = resultSet.getString("album");
                int year = resultSet.getInt("year");
                String artist = resultSet.getString("artist");
                String musicPath = resultSet.getString("musicPath");
                Song song = new Song(id, backgroundImage, posterUrl, title, album, year, artist, musicPath);
                songs.add(song);
            }

            // Close the connection
            connection.close();
        } catch (ClassNotFoundException | SQLException e) {
            e.printStackTrace();
        }
    } else {
        // Fetch song by id
        // Your existing code to fetch a single song based on songId
    }

    request.setAttribute("songs", songs);
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Song Details</title>
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.4.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Custom CSS -->
    <link rel="stylesheet" href="css/index-styles.css">
</head>
<body>

<div class="container">
    <h1>Song Details</h1>
    <div class="song-details">
        <% 
        if (!songs.isEmpty()) {
            for (Song song : songs) {
        %>
            <h2><%= song.getTitle() %></h2>
            <p>Artist: <%= song.getArtist() %></p>
            <p>Album: <%= song.getAlbum() %></p>
            <p>Year: <%= song.getYear() %></p>
            <p>Music Path: <%= song.getMusicPath() %></p>
            <img src="<%= song.getPosterUrl() %>" alt="<%= song.getTitle() %>">
            <div style="background-image: url('<%= song.getBackgroundImage() %>');">
                <!-- Background Image -->
            </div>
        <% 
            }
        } else {
            out.println("No songs found.");
        }
        %>
    </div>
</div>

<!-- Bootstrap JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.4.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
