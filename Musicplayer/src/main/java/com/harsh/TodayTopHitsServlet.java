package com.harsh;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/today_top_hits")
public class TodayTopHitsServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<Song> songs = new ArrayList<>();

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

        // Set the 'songs' attribute in the request
        request.setAttribute("songs", songs);

        // Forward the request to the JSP page
        request.getRequestDispatcher("today_top_hits.jsp").forward(request, response);
    }
}
