<%--
  Created by IntelliJ IDEA.
  User: alsrn
  Date: 2022-07-05
  Time: 오후 10:47
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<%@ page import="encryption.SHA256" %>

<%
    request.setCharacterEncoding("UTF-8");
    String boardId = request.getParameter("board_id");
    String type = request.getParameter("type");
    String inputPassword = request.getParameter("password");

    // 이전 검색 조건
    String searchCreatedDateFrom = request.getParameter("searchCreatedDateFrom");
    String searchCreatedDateTo = request.getParameter("searchCreatedDateTo");
    String searchCategoryId = request.getParameter("searchCategory");
    String searchText = request.getParameter("searchText");

    Connection con = null;
    try {
        Class.forName("org.mariadb.jdbc.Driver");
    } catch (ClassNotFoundException e) {
        e.printStackTrace();
    }
    con = DriverManager.getConnection("jdbc:mariadb://localhost:3306/board_v1", "mingu", "1234");

    PreparedStatement pstmt = null;
    ResultSet rs = null;
    String sql = null;

    String salt = null;
    String originPassword = null;
    String encryptPassword = null;
    try {
        sql = "select password, salt from board where board.board_id = "+boardId;
        pstmt = con.prepareStatement(sql);
        rs = pstmt.executeQuery();
        if (rs.next()) {
            salt = rs.getString("salt");
            originPassword = rs.getString("password"); // DB 저장 비밀번호
            encryptPassword = SHA256.encryptSHA256(inputPassword, salt); // 암호화한 입력 비밀번호
        }
    } catch (SQLException e){
        e.printStackTrace();
    } finally {
        try {
            if (rs != null) {
                rs.close();
            }
            if (pstmt != null) {
                pstmt.close();
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    if (encryptPassword.equals(originPassword)) {
        // 같으면 type 에 따라 다음 프로세스로
        if (type.equals("modify")) {
            response.sendRedirect("modify.jsp?board_id=" + boardId
                    + "&searchCreatedDateFrom=" + searchCreatedDateFrom + "&searchCreatedDateTo=" + searchCreatedDateTo
                    + "&searchCategory=" + searchCategoryId + "&searchText=" + searchText);
        }

        if (type.equals("delete")) {
            response.sendRedirect("deleteProcess.jsp?board_id=" + boardId
                    + "&searchCreatedDateFrom=" + searchCreatedDateFrom + "&searchCreatedDateTo=" + searchCreatedDateTo
                    + "&searchCategory=" + searchCategoryId + "&searchText=" + searchText);
        }
    }
    else{
        // 다르면 passwordConfirm 으로
        response.sendRedirect("passwordConfirm.jsp?board_id=" + boardId + "&type=" + type
                + "&confirm=fail&searchCreatedDateFrom=" + searchCreatedDateFrom + "&searchCreatedDateTo=" + searchCreatedDateTo
                + "&searchCategory=" + searchCategoryId + "&searchText=" + searchText);

    }


    try {
        if (con != null) {
            con.close();
        }
    } catch (SQLException e) {
        e.printStackTrace();
    }
%>
