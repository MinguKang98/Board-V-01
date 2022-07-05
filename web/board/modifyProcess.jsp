<%--
  Created by IntelliJ IDEA.
  User: alsrn
  Date: 2022-07-05
  Time: 오전 1:42
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.text.SimpleDateFormat" %>

<%
    request.setCharacterEncoding("UTF-8");
    String boardId = request.getParameter("board_id");

    Connection con = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;
    String sql = null;

    Class.forName("org.mariadb.jdbc.Driver");
    con = DriverManager.getConnection("jdbc:mariadb://localhost:3306/board_v1", "mingu", "1234");

    // modify.jsp에서 받아온 parameter
    String user = request.getParameter("user");
    String password = request.getParameter("password");
    String title = request.getParameter("title");
    String content = request.getParameter("content");
    String file1 = request.getParameter("file1");
    String file2 = request.getParameter("file2");
    String file3 = request.getParameter("file3");

    // 기존 data
    sql = "select * from board where board.board_id = "+boardId;
    pstmt = con.prepareStatement(sql);
    rs = pstmt.executeQuery();
    rs.next();

    boolean fileExist = rs.getBoolean("file_exist");
    String originUser = rs.getString("user");
    String originPassword = rs.getString("password");
    String originTitle = rs.getString("title");
    String originContent = rs.getString("content");

    //유효성 검사

    //정보 비교해서 다른 것만 update
    boolean userChanged = (!user.equals(originUser));
    boolean titleChanged = (!title.equals(originTitle));
    boolean contentChanged = (!content.equals(originContent));

    String userUpdateQuery = (userChanged) ? ("user = \"" + user + "\", ") : "";
    String titleUpdateQuery = (titleChanged) ? ("title = \"" + title + "\", ") : "";
    String contentUpdateQuery = (contentChanged) ? ("content = \"" + content + "\", ") : "";

    //board update
    sql = "update board set " + userUpdateQuery + titleUpdateQuery + contentUpdateQuery + "updated_date = now() " +
            "where board_id = " + boardId;

    pstmt = con.prepareStatement(sql);

    pstmt.executeUpdate();

    //file update

    // redirect
    response.sendRedirect("/_V_01_war_exploded/board/view.jsp?board_id="+boardId);
%>
