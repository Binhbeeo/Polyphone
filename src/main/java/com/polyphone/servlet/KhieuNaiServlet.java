package com.polyphone.servlet;

import com.polyphone.dao.KhieuNaiDAO;
import com.polyphone.model.KhieuNai;
import com.polyphone.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.List;

@WebServlet(urlPatterns = {"/customer/complaints", "/customer/complaints/submit"})
public class KhieuNaiServlet extends HttpServlet {

    private final KhieuNaiDAO knDAO = new KhieuNaiDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        User user = (User) req.getSession().getAttribute("loggedInUser");
        List<KhieuNai> list = knDAO.findByUserId(user.getUserId());
        req.setAttribute("complaints", list);
        req.getRequestDispatcher("/WEB-INF/views/customer/complaints.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {
        User user = (User) req.getSession().getAttribute("loggedInUser");
        String tieuDe  = req.getParameter("tieuDe");
        String noiDung = req.getParameter("noiDung");
        String dhIdStr = req.getParameter("donHangId");

        KhieuNai kn = new KhieuNai();
        kn.setUserId(user.getUserId());
        kn.setTieuDe(tieuDe);
        kn.setNoiDung(noiDung);
        if (dhIdStr != null && !dhIdStr.isBlank()) {
            try { kn.setDonHangId(Integer.parseInt(dhIdStr)); } catch (NumberFormatException ignored) {}
        }
        knDAO.them(kn);
        resp.sendRedirect(req.getContextPath() + "/customer/complaints?success=1");
    }
}
