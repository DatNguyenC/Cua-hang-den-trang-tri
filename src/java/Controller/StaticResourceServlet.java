package Controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.OutputStream;

/**
 * Servlet để serve static resources (images, CSS, JS)
 * Đảm bảo các file trong assets/ có thể được truy cập trực tiếp
 */
@WebServlet(name = "StaticResourceServlet", urlPatterns = {"/assets/*"})
public class StaticResourceServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Lấy đường dẫn file từ request
        String pathInfo = request.getPathInfo();
        if (pathInfo == null || pathInfo.isEmpty()) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }
        
        // Lấy đường dẫn thực tế của file
        // pathInfo đã bao gồm "/" ở đầu, ví dụ: "/images/product/den_tran.png"
        String realPath = getServletContext().getRealPath("/assets" + pathInfo);
        
        // Fallback nếu getRealPath trả về null (trường hợp WAR file)
        if (realPath == null) {
            realPath = getServletContext().getRealPath("") + "/assets" + pathInfo;
        }
        File file = new File(realPath);
        
        // Kiểm tra file có tồn tại không
        if (!file.exists() || !file.isFile()) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }
        
        // Xác định content type
        String contentType = getServletContext().getMimeType(file.getName());
        if (contentType == null) {
            contentType = "application/octet-stream";
        }
        
        // Set headers
        response.setContentType(contentType);
        response.setContentLengthLong(file.length());
        response.setHeader("Cache-Control", "public, max-age=3600");
        
        // Đọc và ghi file
        try (FileInputStream fis = new FileInputStream(file);
             OutputStream os = response.getOutputStream()) {
            
            byte[] buffer = new byte[4096];
            int bytesRead;
            while ((bytesRead = fis.read(buffer)) != -1) {
                os.write(buffer, 0, bytesRead);
            }
            os.flush();
        }
    }
}

