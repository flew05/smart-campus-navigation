import com.sun.net.httpserver.HttpServer;
import com.sun.net.httpserver.HttpHandler;
import com.sun.net.httpserver.HttpExchange;
import java.io.IOException;
import java.io.OutputStream;
import java.net.InetSocketAddress;

public class SimpleServer {
    public static void main(String[] args) throws Exception {
        // Bind to 0.0.0.0 to accept external connections
        HttpServer server = HttpServer.create(new InetSocketAddress("0.0.0.0", 8888), 0);
        server.createContext("/", new RootHandler());
        server.setExecutor(null);
        server.start();
        System.out.println("Server started on 0.0.0.0:8888");
        System.out.println("Server is accessible from external IPs");
    }

    static class RootHandler implements HttpHandler {
        @Override
        public void handle(HttpExchange exchange) throws IOException {
            String response = "Application deployed successfully. Version: 1.0.0";
            exchange.getResponseHeaders().add("Content-Type", "text/plain");
            exchange.sendResponseHeaders(200, response.length());
            OutputStream os = exchange.getResponseBody();
            os.write(response.getBytes());
            os.close();
            System.out.println("Request served: " + exchange.getRequestURI());
        }
    }
}
