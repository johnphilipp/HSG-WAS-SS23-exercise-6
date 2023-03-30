package room;

import cartago.Artifact;
import cartago.OPERATION;

import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.io.IOException;

/**
 * A CArtAgO artifact that provides an operation for sending messages to agents
 * with KQML performatives using the dweet.io API
 */
public class DweetArtifact extends Artifact {

    private static final String BASE_URL = "https://dweet.io/dweet/for/";
    private static final String DWEET_NAME = "pj-artifact";

    @OPERATION
    public void sendDweet(String message) {
        String url = BASE_URL + DWEET_NAME + "?" + message;

        HttpClient client = HttpClient.newHttpClient();
        HttpRequest request = HttpRequest.newBuilder()
                .uri(URI.create(url))
                .GET()
                .build();
        try {
            HttpResponse<String> response = client.send(request, HttpResponse.BodyHandlers.ofString());
            log("Response status code: " + response.statusCode());
            log("Response headers: " + response.headers());
            log("Response body: " + response.body());
        } catch (IOException | InterruptedException e) {
            log("Error sending dweet: " + e.getMessage());
        }
    }
}
