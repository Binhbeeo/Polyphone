<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<script type="text/javascript">
    window.$crisp=[];
    window.CRISP_WEBSITE_ID="c3ea4475-ddb9-4e99-bf52-e8eb8fb1d220";
    (function(){
        d=document;
        s=d.createElement("script");
        s.src="https://client.crisp.chat/l.js";
        s.async=1;
        d.getElementsByTagName("head")[0].appendChild(s);
    })();

    <c:if test="${not empty sessionScope.loggedInUser}">
        // Định danh người dùng khi đã đăng nhập
        window.$crisp.push(["set", "user:email", ["${sessionScope.loggedInUser.email}"]]);
        window.$crisp.push(["set", "user:nickname", ["${sessionScope.loggedInUser.hoTen}"]]);
        
        <c:if test="${sessionScope.loggedInUser.role == 'admin' || sessionScope.loggedInUser.role == 'staff'}">
            // Thêm segment để phân biệt Admin/Staff trong Crisp Dashboard
            window.$crisp.push(["set", "session:segments", [["${sessionScope.loggedInUser.role}"] ]]);
            // Tự động mở chat khi Admin/Staff vào trang quản trị (tùy chọn)
            // window.$crisp.push(["do", "chat:open"]);
        </c:if>
    </c:if>
</script>
