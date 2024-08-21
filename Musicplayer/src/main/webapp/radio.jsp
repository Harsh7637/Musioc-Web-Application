<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Top Radio Stations</title>
    <link rel="stylesheet" href="./css/radio.css">
</head>
<body>
    <h1>Top Radio Stations</h1>
    <% 
        try {
            java.net.URI uri = new java.net.URI("http://localhost:8080/Musicplayer/TopRadioStationsServlet");
            java.net.HttpURLConnection connection = (java.net.HttpURLConnection) uri.toURL().openConnection();
            connection.setRequestMethod("GET");
            java.io.BufferedReader in = new java.io.BufferedReader(new java.io.InputStreamReader(connection.getInputStream()));
            String inputLine;
            StringBuffer radioResponse = new StringBuffer();
            while ((inputLine = in.readLine()) != null) {
                radioResponse.append(inputLine);
            }
            in.close();
            
            // Extract the JSON data from the response
            String jsonResponse = extractJsonFromResponse(radioResponse.toString());
            
            // Parse the JSON response
            org.json.JSONObject jsonObject = new org.json.JSONObject(jsonResponse);
            org.json.JSONArray stations = jsonObject.getJSONArray("stations");
            
            // Display the radio station names and images
            out.println("<ul>");
            for (int i = 0; i < stations.length(); i++) {
                org.json.JSONObject station = stations.getJSONObject(i);
                String radioName = station.getString("radio_name");
                String radioImage = station.getString("radio_image");
                String radioStreamUrl = station.getString("radio_url");
    %>
    <li>
        <img class="lazyload" data-src="<%= radioImage %>" alt="<%= radioName %>">
        <h3><%= radioName %></h3>
        <audio controls>
            <source src="<%= radioStreamUrl %>" type="audio/mpeg">
            Your browser does not support the audio element.
        </audio>
    </li>
    <% 
            }
            out.println("</ul>");
        } catch (Exception e) {
            out.println("An error occurred: " + e.getMessage());
        }
    %>
    <script src="./js/lazysizes.min.js"></script>
    <script src="./js/radio.js"></script>
</body>
</html>

<%!
    private String extractJsonFromResponse(String response) {
        // Find the first '{' character
        int startIndex = response.indexOf("{");
        if (startIndex >= 0) {
            // Extract the JSON data starting from the '{' character
            return response.substring(startIndex);
        }
        return "";
    }
%>