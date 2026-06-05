package com.example.asmnews.util;

import javax.imageio.ImageIO;
import java.awt.*;
import java.awt.image.BufferedImage;
import java.io.File;
import java.io.InputStream;

public class ImageUtils {

    /**
     * Tự động thay đổi kích thước và cắt (crop) ảnh theo chuẩn kích thước được cung cấp
     * để không bị méo (distorted) hình.
     */
    public static void resizeAndCrop(InputStream input, File destFile, int targetWidth, int targetHeight) throws Exception {
        BufferedImage originalImage = ImageIO.read(input);
        if (originalImage == null) throw new Exception("Không thể đọc được file ảnh, định dạng không được hỗ trợ.");

        int originalWidth = originalImage.getWidth();
        int originalHeight = originalImage.getHeight();

        // Tính toán tỷ lệ khung hình
        double originalRatio = (double) originalWidth / originalHeight;
        double targetRatio = (double) targetWidth / targetHeight;

        int cropWidth = originalWidth;
        int cropHeight = originalHeight;
        int cropX = 0;
        int cropY = 0;

        // Quyết định hướng cắt để khớp với tỷ lệ mong muốn
        if (originalRatio > targetRatio) {
            // Ảnh gốc rộng hơn tỷ lệ chuẩn -> Cắt bớt 2 bên chiều ngang
            cropWidth = (int) (originalHeight * targetRatio);
            cropX = (originalWidth - cropWidth) / 2;
        } else {
            // Ảnh gốc cao hơn tỷ lệ chuẩn -> Cắt bớt chiều dọc
            cropHeight = (int) (originalWidth / targetRatio);
            cropY = (originalHeight - cropHeight) / 2;
        }

        // Cắt ảnh gốc theo tỷ lệ chuẩn
        BufferedImage croppedImage = originalImage.getSubimage(cropX, cropY, cropWidth, cropHeight);

        // Tạo ảnh mới với kích thước chuẩn đã yêu cầu
        BufferedImage finalImage = new BufferedImage(targetWidth, targetHeight, BufferedImage.TYPE_INT_RGB);
        Graphics2D g2d = finalImage.createGraphics();
        
        // Cấu hình chất lượng render tốt nhất
        g2d.setRenderingHint(RenderingHints.KEY_INTERPOLATION, RenderingHints.VALUE_INTERPOLATION_BILINEAR);
        g2d.setRenderingHint(RenderingHints.KEY_RENDERING, RenderingHints.VALUE_RENDER_QUALITY);
        g2d.setRenderingHint(RenderingHints.KEY_ANTIALIASING, RenderingHints.VALUE_ANTIALIAS_ON);

        // Vẽ ảnh đã crop lên canvas kích thước chuẩn
        g2d.drawImage(croppedImage, 0, 0, targetWidth, targetHeight, null);
        g2d.dispose();

        // Xác định đuôi file (mặc định xuất JPG nếu không phải PNG để nén tốt nhất)
        String ext = "jpg";
        if (destFile.getName().toLowerCase().endsWith(".png")) {
            ext = "png";
        } else if (destFile.getName().toLowerCase().endsWith(".gif")) {
            ext = "gif";
        }

        ImageIO.write(finalImage, ext, destFile);
    }
}
