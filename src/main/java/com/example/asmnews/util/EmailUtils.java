package com.example.asmnews.util;






import java.util.Properties;

import jakarta.mail.Authenticator;
import jakarta.mail.Message;
import jakarta.mail.MessagingException;
import jakarta.mail.PasswordAuthentication;
import jakarta.mail.Session;
import jakarta.mail.Transport;
import jakarta.mail.internet.InternetAddress;
import jakarta.mail.internet.MimeMessage;

public class EmailUtils {

    
    private static final String EMAIL = "phatntts01906@gmail.com"; 
    
    private static final String PASSWORD = "rmqlmhrgjrnbzvuh"; 

    public static boolean sendOTP(String toEmail, String otpCode) {
        // Cài đặt thông số kết nối đến server SMTP của Google
        Properties props = new Properties();
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");
        props.put("mail.smtp.host", "smtp.gmail.com");
        props.put("mail.smtp.port", "587");

        // Đăng nhập vào Gmail
        Session session = Session.getInstance(props, new Authenticator() {
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(EMAIL, PASSWORD);
            }
        });

        try {
            // Tạo nội dung bức thư
            Message message = new MimeMessage(session);
            message.setFrom(new InternetAddress(EMAIL));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(toEmail));
            message.setSubject("Mã xác thực khôi phục mật khẩu - XYZ News");

            String content = "Chào bạn,\n\n"
                    + "Bạn vừa yêu cầu khôi phục mật khẩu tại XYZ News.\n"
                    + "Mã xác thực (OTP) của bạn là: " + otpCode + "\n\n"
                    + "Vui lòng không chia sẻ mã này cho bất kỳ ai. Mã có hiệu lực trong 5 phút.";
            message.setText(content);

            // Bấm gửi
            Transport.send(message);
            return true;
        } catch (MessagingException e) {
            e.printStackTrace(); // In lỗi ra console để dễ debug
            return false;
        }
    }
}
