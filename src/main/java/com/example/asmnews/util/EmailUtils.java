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

/**
 * Lớp tiện ích gửi email thông báo
 * Hỗ trợ định dạng HTML sang trọng theo triết lý W3Schools
 */
public class EmailUtils {

    private static final String EMAIL = "phatntts01906@gmail.com"; 
    private static final String PASSWORD = "rmqlmhrgjrnbzvuh"; 

    /**
     * Gửi mã OTP xác thực khôi phục mật khẩu dạng HTML
     */
    public static boolean sendOTP(String toEmail, String otpCode) {
        Properties props = new Properties();
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");
        props.put("mail.smtp.host", "smtp.gmail.com");
        props.put("mail.smtp.port", "587");

        Session session = Session.getInstance(props, new Authenticator() {
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(EMAIL, PASSWORD);
            }
        });

        try {
            Message message = new MimeMessage(session);
            message.setFrom(new InternetAddress(EMAIL));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(toEmail));
            message.setSubject("Mã xác thực khôi phục mật khẩu - Dòng Chảy Tin Tức");

            String htmlContent = "<div style=\"font-family: 'Inter', 'Helvetica Neue', Helvetica, Arial, sans-serif; max-width: 600px; margin: 0 auto; border: 1px solid #e1e8ed; border-radius: 12px; overflow: hidden; box-shadow: 0 4px 10px rgba(0,0,0,0.05);\">"
                    + "    <div style=\"background-color: #006389; padding: 24px; text-align: center; color: white;\">"
                    + "        <h2 style=\"margin: 0; font-size: 24px; font-weight: bold; letter-spacing: 1px;\">DÒNG CHẢY TIN TỨC</h2>"
                    + "    </div>"
                    + "    <div style=\"padding: 30px; background-color: #ffffff; color: #333333; line-height: 1.6;\">"
                    + "        <h3 style=\"margin-top: 0; color: #006389; font-size: 18px;\">Chào bạn,</h3>"
                    + "        <p style=\"font-size: 15px; margin-bottom: 24px;\">Bạn vừa yêu cầu khôi phục mật khẩu tại Dòng Chảy Tin Tức. Mã xác thực (OTP) của bạn là:</p>"
                    + "        <div style=\"background-color: #f5f8fa; border-left: 4px solid #006389; padding: 15px; border-radius: 6px; margin-bottom: 24px; text-align: center;\">"
                    + "            <span style=\"font-size: 24px; font-weight: bold; letter-spacing: 4px; color: #e11d48;\">" + otpCode + "</span>"
                    + "        </div>"
                    + "        <p style=\"font-size: 14px; color: #777777; font-style: italic;\">Mã có hiệu lực trong 5 phút. Vui lòng không chia sẻ mã này cho bất kỳ ai.</p>"
                    + "    </div>"
                    + "    <div style=\"background-color: #f5f8fa; padding: 15px; text-align: center; font-size: 12px; color: #999999; border-top: 1px solid #e1e8ed;\">"
                    + "        Đây là email tự động từ hệ thống Dòng Chảy Tin Tức. Vui lòng không phản hồi email này."
                    + "    </div>"
                    + "</div>";

            message.setContent(htmlContent, "text/html; charset=UTF-8");
            Transport.send(message);
            return true;
        } catch (MessagingException e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Gửi mail thông báo khi bình luận được phản hồi (dạng HTML)
     */
    public static boolean sendCommentReplyNotification(String toEmail, String parentAuthorName, String replyAuthorName, String articleTitle, String replyContent) { 
        Properties props = new Properties(); 
        props.put("mail.smtp.auth", "true"); 
        props.put("mail.smtp.starttls.enable", "true"); 
        props.put("mail.smtp.host", "smtp.gmail.com"); 
        props.put("mail.smtp.port", "587"); 

        Session session = Session.getInstance(props, new Authenticator() { 
            protected PasswordAuthentication getPasswordAuthentication() { 
                return new PasswordAuthentication(EMAIL, PASSWORD); 
            } 
        }); 

        try { 
            Message message = new MimeMessage(session); 
            message.setFrom(new InternetAddress(EMAIL)); 
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(toEmail)); 
            message.setSubject("Bình luận của bạn có phản hồi mới - Dòng Chảy Tin Tức"); 

            String htmlContent = "<div style=\"font-family: 'Inter', 'Helvetica Neue', Helvetica, Arial, sans-serif; max-width: 600px; margin: 0 auto; border: 1px solid #e1e8ed; border-radius: 12px; overflow: hidden; box-shadow: 0 4px 10px rgba(0,0,0,0.05);\">"
                    + "    <div style=\"background-color: #006389; padding: 24px; text-align: center; color: white;\">"
                    + "        <h2 style=\"margin: 0; font-size: 24px; font-weight: bold; letter-spacing: 1px;\">DÒNG CHẢY TIN TỨC</h2>"
                    + "    </div>"
                    + "    <div style=\"padding: 30px; background-color: #ffffff; color: #333333; line-height: 1.6;\">"
                    + "        <h3 style=\"margin-top: 0; color: #006389; font-size: 18px;\">Chào " + parentAuthorName + ",</h3>"
                    + "        <p style=\"font-size: 15px; margin-bottom: 20px;\"><strong>" + replyAuthorName + "</strong> vừa phản hồi bình luận của bạn trong bài viết <strong>\"" + articleTitle + "\"</strong>:</p>"
                    + "        <div style=\"background-color: #f5f8fa; border-left: 4px solid #006389; padding: 15px; border-radius: 6px; margin-bottom: 20px; font-style: italic; font-size: 15px; color: #555555;\">"
                    + "            \"" + replyContent + "\""
                    + "        </div>"
                    + "        <p style=\"font-size: 14px; color: #777777;\">Cảm ơn bạn đã tham gia thảo luận tại Dòng Chảy Tin Tức.</p>"
                    + "    </div>"
                    + "    <div style=\"background-color: #f5f8fa; padding: 15px; text-align: center; font-size: 12px; color: #999999; border-top: 1px solid #e1e8ed;\">"
                    + "        Đây là email tự động từ hệ thống Dòng Chảy Tin Tức. Vui lòng không phản hồi email này."
                    + "    </div>"
                    + "</div>";

            message.setContent(htmlContent, "text/html; charset=UTF-8");
            Transport.send(message); 
            return true; 
        } catch (MessagingException e) { 
            e.printStackTrace(); 
            return false; 
        } 
    } 

    /**
     * Gửi mail thông báo khi tác giả có bài viết mới (dạng HTML)
     */
    public static boolean sendNewArticleNotification(String toEmail, String authorName, String articleTitle, String articleLink) { 
        Properties props = new Properties(); 
        props.put("mail.smtp.auth", "true"); 
        props.put("mail.smtp.starttls.enable", "true"); 
        props.put("mail.smtp.host", "smtp.gmail.com"); 
        props.put("mail.smtp.port", "587"); 

        Session session = Session.getInstance(props, new Authenticator() { 
            protected PasswordAuthentication getPasswordAuthentication() { 
                return new PasswordAuthentication(EMAIL, PASSWORD); 
            } 
        }); 

        try { 
            Message message = new MimeMessage(session); 
            message.setFrom(new InternetAddress(EMAIL)); 
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(toEmail)); 
            message.setSubject("Tác giả bạn theo dõi vừa đăng bài viết mới - Dòng Chảy Tin Tức"); 

            String htmlContent = "<div style=\"font-family: 'Inter', 'Helvetica Neue', Helvetica, Arial, sans-serif; max-width: 600px; margin: 0 auto; border: 1px solid #e1e8ed; border-radius: 12px; overflow: hidden; box-shadow: 0 4px 10px rgba(0,0,0,0.05);\">"
                    + "    <div style=\"background-color: #006389; padding: 24px; text-align: center; color: white;\">"
                    + "        <h2 style=\"margin: 0; font-size: 24px; font-weight: bold; letter-spacing: 1px;\">DÒNG CHẢY TIN TỨC</h2>"
                    + "    </div>"
                    + "    <div style=\"padding: 30px; background-color: #ffffff; color: #333333; line-height: 1.6;\">"
                    + "        <h3 style=\"margin-top: 0; color: #006389; font-size: 18px;\">Chào bạn,</h3>"
                    + "        <p style=\"font-size: 15px; margin-bottom: 20px;\">Tác giả <strong>" + authorName + "</strong> mà bạn đang theo dõi vừa xuất bản bài viết mới:</p>"
                    + "        <div style=\"background-color: #f5f8fa; border-left: 4px solid #006389; padding: 15px; border-radius: 6px; margin-bottom: 24px; font-size: 16px; font-weight: bold; color: #333333;\">"
                    + "            " + articleTitle
                    + "        </div>"
                    + "        <div style=\"text-align: center; margin-bottom: 20px;\">"
                    + "            <a href=\"" + articleLink + "\" style=\"display: inline-block; background-color: #006389; color: white; padding: 12px 24px; border-radius: 6px; text-decoration: none; font-weight: bold; font-size: 15px;\">Đọc bài viết ngay</a>"
                    + "        </div>"
                    + "        <p style=\"font-size: 14px; color: #777777;\">Cảm ơn bạn đã đồng hành cùng Dòng Chảy Tin Tức.</p>"
                    + "    </div>"
                    + "    <div style=\"background-color: #f5f8fa; padding: 15px; text-align: center; font-size: 12px; color: #999999; border-top: 1px solid #e1e8ed;\">"
                    + "        Đây là email tự động từ hệ thống Dòng Chảy Tin Tức. Vui lòng không phản hồi email này."
                    + "    </div>"
                    + "</div>";

            message.setContent(htmlContent, "text/html; charset=UTF-8");
            Transport.send(message); 
            return true; 
        } catch (MessagingException e) { 
            e.printStackTrace(); 
            return false; 
        } 
    } 

    /**
     * Gửi mail thông báo cho tác giả khi bài viết của họ được duyệt (dạng HTML)
     */
    public static boolean sendArticleApprovedNotification(String toEmail, String authorName, String articleTitle, String articleLink) {
        Properties props = new Properties();
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");
        props.put("mail.smtp.host", "smtp.gmail.com");
        props.put("mail.smtp.port", "587");

        Session session = Session.getInstance(props, new Authenticator() {
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(EMAIL, PASSWORD);
            }
        });

        try {
            Message message = new MimeMessage(session);
            message.setFrom(new InternetAddress(EMAIL));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(toEmail));
            message.setSubject("Bài viết của bạn đã được duyệt thành công! - Dòng Chảy Tin Tức");

            String htmlContent = "<div style=\"font-family: 'Inter', 'Helvetica Neue', Helvetica, Arial, sans-serif; max-width: 600px; margin: 0 auto; border: 1px solid #e1e8ed; border-radius: 12px; overflow: hidden; box-shadow: 0 4px 10px rgba(0,0,0,0.05);\">"
                    + "    <div style=\"background-color: #006389; padding: 24px; text-align: center; color: white;\">"
                    + "        <h2 style=\"margin: 0; font-size: 24px; font-weight: bold; letter-spacing: 1px;\">DÒNG CHẢY TIN TỨC</h2>"
                    + "    </div>"
                    + "    <div style=\"padding: 30px; background-color: #ffffff; color: #333333; line-height: 1.6;\">"
                    + "        <h3 style=\"margin-top: 0; color: #006389; font-size: 18px;\">Chào " + authorName + ",</h3>"
                    + "        <p style=\"font-size: 15px; margin-bottom: 20px;\">Chúc mừng! Bài viết của bạn đã được ban quản trị phê duyệt và xuất bản chính thức:</p>"
                    + "        <div style=\"background-color: #f5f8fa; border-left: 4px solid #006389; padding: 15px; border-radius: 6px; margin-bottom: 24px; font-size: 16px; font-weight: bold; color: #333333;\">"
                    + "            " + articleTitle
                    + "        </div>"
                    + "        <div style=\"text-align: center; margin-bottom: 20px;\">"
                    + "            <a href=\"" + articleLink + "\" style=\"display: inline-block; background-color: #006389; color: white; padding: 12px 24px; border-radius: 6px; text-decoration: none; font-weight: bold; font-size: 15px;\">Xem bài viết trên trang chủ</a>"
                    + "        </div>"
                    + "        <p style=\"font-size: 14px; color: #777777;\">Cảm ơn bạn đã đóng góp nội dung chất lượng cho Dòng Chảy Tin Tức.</p>"
                    + "    </div>"
                    + "    <div style=\"background-color: #f5f8fa; padding: 15px; text-align: center; font-size: 12px; color: #999999; border-top: 1px solid #e1e8ed;\">"
                    + "        Đây là email tự động từ hệ thống Dòng Chảy Tin Tức. Vui lòng không phản hồi email này."
                    + "    </div>"
                    + "</div>";

            message.setContent(htmlContent, "text/html; charset=UTF-8");
            Transport.send(message);
            return true;
        } catch (MessagingException e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Gửi bản tin email thông báo bài viết mới cho người đăng ký nhận tin (Newsletter)
     */
    public static boolean sendNewsletterNotification(String toEmail, String articleTitle, String articleLink) {
        Properties props = new Properties();
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");
        props.put("mail.smtp.host", "smtp.gmail.com");
        props.put("mail.smtp.port", "587");

        Session session = Session.getInstance(props, new Authenticator() {
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(EMAIL, PASSWORD);
            }
        });

        try {
            Message message = new MimeMessage(session);
            message.setFrom(new InternetAddress(EMAIL));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(toEmail));
            message.setSubject("Bản tin Dòng Chảy Tin Tức - Bài viết mới nhất hôm nay");

            String htmlContent = "<div style=\"font-family: 'Inter', 'Helvetica Neue', Helvetica, Arial, sans-serif; max-width: 600px; margin: 0 auto; border: 1px solid #e1e8ed; border-radius: 12px; overflow: hidden; box-shadow: 0 4px 10px rgba(0,0,0,0.05);\">"
                    + "    <div style=\"background-color: #006389; padding: 24px; text-align: center; color: white;\">"
                    + "        <h2 style=\"margin: 0; font-size: 24px; font-weight: bold; letter-spacing: 1px;\">DÒNG CHẢY TIN TỨC</h2>"
                    + "    </div>"
                    + "    <div style=\"padding: 30px; background-color: #ffffff; color: #333333; line-height: 1.6;\">"
                    + "        <h3 style=\"margin-top: 0; color: #006389; font-size: 18px;\">Chào bạn đọc,</h3>"
                    + "        <p style=\"font-size: 15px; margin-bottom: 20px;\">Bản tin Dòng Chảy Tin Tức xin gửi tới bạn bài viết mới nhất vừa được phê duyệt và xuất bản hôm nay:</p>"
                    + "        <div style=\"background-color: #f5f8fa; border-left: 4px solid #006389; padding: 15px; border-radius: 6px; margin-bottom: 24px; font-size: 16px; font-weight: bold; color: #333333;\">"
                    + "            " + articleTitle
                    + "        </div>"
                    + "        <div style=\"text-align: center; margin-bottom: 20px;\">"
                    + "            <a href=\"" + articleLink + "\" style=\"display: inline-block; background-color: #006389; color: white; padding: 12px 24px; border-radius: 6px; text-decoration: none; font-weight: bold; font-size: 15px;\">Đọc bài viết ngay</a>"
                    + "        </div>"
                    + "        <p style=\"font-size: 14px; color: #777777;\">Cảm ơn bạn đã đăng ký theo dõi bản tin của Dòng Chảy Tin Tức.</p>"
                    + "    </div>"
                    + "    <div style=\"background-color: #f5f8fa; padding: 15px; text-align: center; font-size: 12px; color: #999999; border-top: 1px solid #e1e8ed;\">"
                    + "        Đây là email tự động từ hệ thống Dòng Chảy Tin Tức. Vui lòng không phản hồi email này."
                    + "    </div>"
                    + "</div>";

            message.setContent(htmlContent, "text/html; charset=UTF-8");
            Transport.send(message);
            return true;
        } catch (MessagingException e) {
            e.printStackTrace();
            return false;
        }
    }
}
