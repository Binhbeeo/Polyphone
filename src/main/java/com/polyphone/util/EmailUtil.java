package com.polyphone.util;

import jakarta.mail.*;
import jakarta.mail.internet.*;
import java.io.IOException;
import java.io.InputStream;
import java.util.Properties;

public class EmailUtil {

    private static String HOST, PORT, USERNAME, PASSWORD, FROM;

    static {
        try (InputStream is = EmailUtil.class.getClassLoader()
                .getResourceAsStream("config.properties")) {
            Properties props = new Properties();
            props.load(is);
            HOST     = props.getProperty("mail.host");
            PORT     = props.getProperty("mail.port");
            USERNAME = props.getProperty("mail.username");
            PASSWORD = props.getProperty("mail.password");
            FROM     = props.getProperty("mail.from");
        } catch (IOException e) {
            throw new RuntimeException("Không thể tải cấu hình Email", e);
        }
    }

    public static void sendOTP(String toEmail, String otp) throws MessagingException {
        Properties props = new Properties();
        props.put("mail.smtp.host", HOST);
        props.put("mail.smtp.port", PORT);
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");

        Session session = Session.getInstance(props, new Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(USERNAME, PASSWORD);
            }
        });

        Message message = new MimeMessage(session);
        message.setFrom(new InternetAddress(FROM));
        message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(toEmail));
        message.setSubject("[PolyPhone] Mã OTP Đặt Lại Mật Khẩu");
        message.setContent(
            "<div style='font-family:Arial,sans-serif;max-width:500px;margin:auto;'>" +
            "<h2 style='color:#e74c3c;'>PolyPhone</h2>" +
            "<p>Xin chào,</p>" +
            "<p>Mã OTP đặt lại mật khẩu của bạn là:</p>" +
            "<h1 style='color:#e74c3c;letter-spacing:8px;'>" + otp + "</h1>" +
            "<p>Mã có hiệu lực trong <strong>5 phút</strong>.</p>" +
            "<p>Nếu bạn không yêu cầu điều này, hãy bỏ qua email này.</p>" +
            "</div>", "text/html; charset=utf-8");

        Transport.send(message);
    }
}
