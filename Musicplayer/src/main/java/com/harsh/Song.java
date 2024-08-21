package com.harsh;

public class Song {
    private String id;
    private String backgroundImage;
    private String posterUrl;
    private String title;
    private String album;
    private int year;
    private String artist;
    private String musicPath;

    public Song(String id, String backgroundImage, String posterUrl, String title, String album, int year, String artist, String musicPath) {
        this.id = id;
        this.backgroundImage = backgroundImage;
        this.posterUrl = posterUrl;
        this.title = title;
        this.album = album;
        this.year = year;
        this.artist = artist;
        this.musicPath = musicPath;
    }

    public String getId() {
        return id;
    }

    public String getBackgroundImage() {
        return backgroundImage;
    }

    public String getPosterUrl() {
        return posterUrl;
    }

    public String getTitle() {
        return title;
    }

    public String getAlbum() {
        return album;
    }

    public int getYear() {
        return year;
    }

    public String getArtist() {
        return artist;
    }

    public String getMusicPath() {
        return musicPath;
    }
}
