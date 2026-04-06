<<<<<<< HEAD
# PolyPhone - Hệ Thống Quản Lý Cửa Hàng Điện Thoại

## Giới thiệu
Dự án web MVC Servlet + JDBC quản lý cửa hàng điện thoại PolyPhone.
Triển khai **64 yêu cầu (RQ01–RQ64)** theo Product Backlog đã định nghĩa.

## Công nghệ
- **Java 11** + **Jakarta Servlet 5.0**
- **JDBC** với SQL Server (mssql-jdbc 12.4)
- **JSP + JSTL** (Jakarta EE)
- **BCrypt** (jbcrypt 0.4) – mã hóa mật khẩu
- **JavaMail** – gửi OTP qua email
- **Bootstrap 5.3** – giao diện
- **Maven** – build tool

## Cấu trúc dự án
```
PolyPhone/
├── src/main/java/com/polyphone/
│   ├── model/          # User, SanPham, DonHang, ChiTietDonHang, ...
│   ├── dao/            # UserDAO, SanPhamDAO, DonHangDAO, GioHangDAO, ...
│   ├── servlet/        # HomeServlet, AuthServlet, ProductServlet, ...
│   ├── filter/         # AuthFilter, EncodingFilter
│   └── util/           # DatabaseConnection, PasswordUtil, EmailUtil
├── src/main/resources/
│   └── config.properties   # Cấu hình DB + Email
└── src/main/webapp/
    ├── WEB-INF/
    │   ├── web.xml
    │   └── views/
    │       ├── common/     # header, footer, login, register, forgot-password, ...
    │       ├── customer/   # home, products, product-detail, cart, checkout, orders, ...
    │       ├── admin/      # dashboard, products, categories, users, staff, vouchers, orders, ...
    │       └── staff/      # orders, complaints, profile
    └── index.jsp
```

## Cài đặt & Chạy

### 1. Cấu hình Database
```
1. Chạy file DuAnBanDienTHoai.sql trên SQL Server
2. Mở src/main/resources/config.properties
3. Sửa: db.url, db.username, db.password
```

### 2. Cấu hình Email (Gửi OTP)
```
Sửa mail.username và mail.password trong config.properties
Dùng Gmail App Password (không phải mật khẩu Gmail thường)
```

### 3. Build & Deploy
```bash
mvn clean package
# Copy target/PolyPhone-1.0-SNAPSHOT.war vào Tomcat/webapps/
# Hoặc dùng IDE (IntelliJ/Eclipse) với Tomcat 10.x
```

### 4. Tài khoản mặc định
- **Admin**: admin@polyphone.vn / (xem DB, mật khẩu cần hash lại)
- Chạy SQL sau để tạo admin với mật khẩu `Admin@123`:
```sql
UPDATE Users SET mat_khau_hash='$2a$12$...' WHERE email='admin@polyphone.vn';
-- Hoặc dùng PasswordUtil.hashPassword("Admin@123") trong code để lấy hash
```

## Mapping URL

### Public (không cần đăng nhập)
| URL | Chức năng |
|-----|-----------|
| `/` | Trang chủ |
| `/products` | Danh sách sản phẩm + lọc (RQ02/03) |
| `/products/search?q=` | Tìm kiếm (RQ01) |
| `/products/detail?id=` | Chi tiết sản phẩm (RQ05) |
| `/auth/login` | Đăng nhập (RQ20/40/44) |
| `/auth/register` | Đăng ký (RQ19) |
| `/auth/forgot-password` | Quên mật khẩu (RQ21/41/45) |

### Customer (yêu cầu đăng nhập)
| URL | Chức năng |
|-----|-----------|
| `/customer/cart` | Giỏ hàng (RQ10/11/12/13) |
| `/customer/checkout` | Thanh toán (RQ14/15/16/28) |
| `/customer/orders` | Lịch sử đơn hàng (RQ23) |
| `/customer/orders/detail?id=` | Chi tiết + theo dõi đơn (RQ17) |
| `/customer/wishlist` | Yêu thích (RQ06/09) |
| `/customer/profile` | Tài khoản (RQ18/22) |
| `/customer/complaints` | Khiếu nại (RQ25/27) |

### Staff
| URL | Chức năng |
|-----|-----------|
| `/staff/orders` | Xem đơn hàng (RQ36) |
| `/staff/orders/detail?id=` | Cập nhật trạng thái (RQ37) |
| `/staff/complaints` | Xử lý khiếu nại (RQ38) |

### Admin
| URL | Chức năng |
|-----|-----------|
| `/admin/dashboard` | Tổng quan |
| `/admin/products` | Quản lý sản phẩm (RQ47/48/49) |
| `/admin/categories` | Quản lý danh mục (RQ50/51/52) |
| `/admin/users` | Quản lý khách hàng (RQ53/54/59/60) |
| `/admin/staff` | Quản lý nhân viên (RQ53/63) |
| `/admin/vouchers` | Quản lý voucher (RQ61) |
| `/admin/orders` | Quản lý đơn hàng (RQ56/57) |
| `/admin/complaints` | Xử lý khiếu nại (RQ58) |
| `/admin/reviews` | Quản lý đánh giá (RQ64) |
| `/admin/trade-in` | Xem Trade-in/Lịch sử mua (RQ62) |

## Lưu ý quan trọng
- **Trade-in (RQ62)**: Theo yêu cầu, đây thực chất là xem lịch sử đơn hàng online đã hoàn thành
- **Điểm tích lũy**: 1 điểm = 100đ khi đổi. Mỗi 1.000đ mua hàng = 1 điểm
- **Voucher**: Hỗ trợ phần trăm và cố định, kiểm tra đơn tối thiểu
- **BCrypt**: Tất cả mật khẩu được hash bằng BCrypt (salt rounds = 12)
=======
# Polyphone
Don't Move
>>>>>>> 9db4d6b4c721a4d033c224ca542abc6c2a9eab26
