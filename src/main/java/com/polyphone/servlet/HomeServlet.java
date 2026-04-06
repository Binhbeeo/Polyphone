package com.polyphone.servlet;

import com.polyphone.dao.DanhMucDAO;
import com.polyphone.dao.SanPhamDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;

@WebServlet("/")
public class HomeServlet extends HttpServlet {

    private final SanPhamDAO spDAO = new SanPhamDAO();
    private final DanhMucDAO dmDAO = new DanhMucDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.setAttribute("featuredProducts", spDAO.findAll().stream().limit(8).toList());
        req.setAttribute("danhMucs", dmDAO.findDangHien());
        req.getRequestDispatcher("/WEB-INF/views/customer/home.jsp").forward(req, resp);
    }
}
