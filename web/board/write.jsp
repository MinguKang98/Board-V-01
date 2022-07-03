<%--
  Created by IntelliJ IDEA.
  User: alsrn
  Date: 2022-07-03
  Time: 오후 10:58
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>

<%
    Connection con = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;
    String sql = null;

    Class.forName("org.mariadb.jdbc.Driver");
    con = DriverManager.getConnection("jdbc:mariadb://localhost:3306/board_v1", "mingu", "1234");
%>
<html>
<head>
    <title>게시판 등록</title>
</head>
<body>
    <form method="post">
        <table>
            <tr>
                <th>카테고리</th>
                <td>
                    <select>
                        <option value="0" selected>카테고리 선택</option>
                        <%
                            sql = "select * from category";
                            pstmt = con.prepareStatement(sql);
                            rs = pstmt.executeQuery();

                            while (rs.next()) {
                                int id = rs.getInt("category_id");
                                String name = rs.getString("name");
                        %>
                        <option value="<%=id%>"><%=name%></option>
                        <%
                            }
                        %>
                    </select>
                </td>
            </tr>
            <tr>
                <th>작성자</th>
                <td>
                    <input type="text">
                </td>
            </tr>
            <tr>
                <th>비밀번호</th>
                <td>
                    <input type="text" placeholder="비밀번호">
                    <input type="text" placeholder="비밀번호 확인">
                </td>
            </tr>
            <tr>
                <th>제목</th>
                <td>
                    <input type="text">
                </td>
            </tr>
            <tr>
                <th>내용</th>
                <td>
                    <input type="text">
                </td>
            </tr>
            <tr>
                <th>파일첨부</th>
                <td>
                    <input type="file" placeholder="">
                    <input type="file">
                    <input type="file">
                </td>
            </tr>
        </table>
        <button type="button" onclick="location.href='/_V_01_war_exploded/board/list.jsp'">취소</button>
        <button type="submit">저장</button>
    </form>

</body>
</html>