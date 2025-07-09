import java.net.*;
import java.io.*;
import org.json.*;

public class QuantoraClient {
    private String baseUrl;
    public QuantoraClient(String baseUrl) { this.baseUrl = baseUrl; }

    public JSONObject getBlock(String blockHash) throws Exception {
        URL url = new URL(baseUrl + "/block/" + blockHash);
        HttpURLConnection conn = (HttpURLConnection) url.openConnection();
        conn.setRequestMethod("GET");
        return new JSONObject(new BufferedReader(new InputStreamReader(conn.getInputStream())).readLine());
    }

    public JSONObject search(String q) throws Exception {
        URL url = new URL(baseUrl + "/search?q=" + URLEncoder.encode(q, "UTF-8"));
        HttpURLConnection conn = (HttpURLConnection) url.openConnection();
        conn.setRequestMethod("GET");
        return new JSONObject(new BufferedReader(new InputStreamReader(conn.getInputStream())).readLine());
    }

    public JSONObject newOrder(String token, String pair, String orderType, double size, Double price) throws Exception {
        URL url = new URL(baseUrl + "/order");
        HttpURLConnection conn = (HttpURLConnection) url.openConnection();
        conn.setRequestMethod("POST");
        conn.setRequestProperty("Authorization", "Bearer " + token);
        conn.setDoOutput(true);
        JSONObject order = new JSONObject();
        order.put("pair", pair);
        order.put("type", orderType);
        order.put("size", size);
        if (price != null) order.put("price", price);
        try (OutputStream os = conn.getOutputStream()) {
            os.write(order.toString().getBytes("UTF-8"));
        }
        return new JSONObject(new BufferedReader(new InputStreamReader(conn.getInputStream())).readLine());
    }
}