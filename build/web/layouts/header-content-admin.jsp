<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="Model.NguoiDung"%>

<%
    NguoiDung currentUser = null;
    String userName = "Admin";
    String userInitial = "A";
    String userEmail = "admin@lightshop.vn";
    String userRole = "Administrator";

    if (request.getAttribute("user") != null) {
        currentUser = (NguoiDung) request.getAttribute("user");
    } else if (session != null && session.getAttribute("user") != null) {
        currentUser = (NguoiDung) session.getAttribute("user");
    }

    if (currentUser != null) {
        if (currentUser.getTenDangNhap() != null && !currentUser.getTenDangNhap().isEmpty()) {
            userName = currentUser.getTenDangNhap();
            userInitial = userName.substring(0, 1).toUpperCase();
        }
        if (currentUser.getEmail() != null && !currentUser.getEmail().isEmpty()) {
            userEmail = currentUser.getEmail();
        }
        if (currentUser.getVaiTro() != null && !currentUser.getVaiTro().isEmpty()) {
            userRole = currentUser.getVaiTro();
        }
    }
%>

<header class="admin-topbar">
    <button class="topbar-btn" id="sidebarToggle" aria-label="Đóng/Mở menu">
        <i class="fas fa-bars"></i>
    </button>

    <div class="topbar-spacer"></div>

    <div class="user-menu">
        <button class="user-chip" id="userMenuBtn" aria-haspopup="true" aria-expanded="false">
            <span class="user-chip__avatar"><%= userInitial %></span>
            <span class="user-chip__name"><%= userName %></span>
            <i class="fas fa-chevron-down"></i>
        </button>

        <div class="user-dropdown" id="userDropdown">
            <div class="user-dropdown__header">
                <div class="user-avatar-lg"><%= userInitial %></div>
                <div>
                    <strong><%= userName %></strong>
                    <p><%= userEmail %></p>
                    <span class="user-role"><%= userRole %></span>
                </div>
            </div>
            <a href="../elements/AccountInfo.jsp"><i class="fas fa-user"></i> Thông tin tài khoản</a>
            <a href="../elements/statistics.jsp"><i class="fas fa-chart-line"></i> Thống kê</a>
            <form action="<%=request.getContextPath()%>/LogoutServlet" method="post">
                <button type="submit" onclick="return confirm('Đăng xuất khỏi hệ thống?')">
                    <i class="fas fa-sign-out-alt"></i> Đăng xuất
                </button>
            </form>
        </div>
    </div>
</header>

<style>
.admin-topbar {
    position: fixed;
    top: 0;
    left: var(--sidebar-width, 250px);
    right: 0;
    height: 64px;
    background: rgba(255, 255, 255, 0.9);
    backdrop-filter: blur(10px);
    border-bottom: 1px solid rgba(226, 232, 240, 0.6);
    display: flex;
    align-items: center;
    padding: 0 24px;
    z-index: 900;
    transition: left 0.25s ease;
}

body.sidebar-collapsed .admin-topbar {
    left: 0;
}

.topbar-btn {
    width: 42px;
    height: 42px;
    border: 1px solid rgba(15, 23, 42, 0.08);
    border-radius: 12px;
    background: #fff;
    color: #0f172a;
    display: inline-flex;
    align-items: center;
    justify-content: center;
    font-size: 17px;
    cursor: pointer;
    transition: all 0.2s ease;
}

.topbar-btn:hover {
    border-color: rgba(56, 189, 248, 0.6);
    color: #0ea5e9;
    box-shadow: 0 8px 20px rgba(15, 23, 42, 0.1);
}

.topbar-spacer {
    flex: 1;
}

.user-menu {
    position: relative;
}

.user-chip {
    display: inline-flex;
    align-items: center;
    gap: 10px;
    padding: 6px 12px;
    border-radius: 999px;
    border: 1px solid rgba(148, 163, 184, 0.35);
    background: #fff;
    color: #0f172a;
    cursor: pointer;
    transition: all 0.2s ease;
}

.user-chip:hover {
    border-color: rgba(56, 189, 248, 0.6);
    box-shadow: 0 6px 18px rgba(15, 23, 42, 0.1);
}

.user-chip__avatar {
    width: 32px;
    height: 32px;
    border-radius: 50%;
    background: linear-gradient(135deg, #38bdf8, #2563eb);
    color: #fff;
    display: flex;
    align-items: center;
    justify-content: center;
    font-weight: 600;
    letter-spacing: 0.5px;
}

.user-chip__name {
    font-size: 14px;
    font-weight: 600;
}

.user-dropdown {
    position: absolute;
    top: calc(100% + 12px);
    right: 0;
    width: 280px;
    background: #fff;
    border-radius: 18px;
    box-shadow: 0 20px 40px rgba(15, 23, 42, 0.12);
    border: 1px solid rgba(226, 232, 240, 0.7);
    padding: 16px;
    opacity: 0;
    pointer-events: none;
    transform: translateY(-8px);
    transition: all 0.2s ease;
}

.user-dropdown.show {
    opacity: 1;
    pointer-events: auto;
    transform: translateY(0);
}

.user-dropdown__header {
    display: flex;
    gap: 14px;
    margin-bottom: 16px;
    padding-bottom: 14px;
    border-bottom: 1px solid rgba(226, 232, 240, 0.8);
}

.user-avatar-lg {
    width: 48px;
    height: 48px;
    border-radius: 14px;
    background: linear-gradient(135deg, #0ea5e9, #2563eb);
    color: #fff;
    display: flex;
    align-items: center;
    justify-content: center;
    font-size: 18px;
    font-weight: 700;
}

.user-dropdown__header strong {
    display: block;
    font-size: 16px;
}

.user-dropdown__header p {
    margin: 2px 0;
    font-size: 13px;
    color: #64748b;
}

.user-role {
    display: inline-block;
    padding: 2px 8px;
    border-radius: 999px;
    background: rgba(56, 189, 248, 0.15);
    color: #0369a1;
    font-size: 11px;
    font-weight: 600;
    text-transform: uppercase;
}

.user-dropdown a,
.user-dropdown button {
    width: 100%;
    border: none;
    background: transparent;
    text-align: left;
    padding: 10px;
    border-radius: 12px;
    color: #0f172a;
    font-size: 14px;
    display: flex;
    align-items: center;
    gap: 10px;
    cursor: pointer;
    transition: background 0.2s ease;
}

.user-dropdown a:hover,
.user-dropdown button:hover {
    background: rgba(148, 163, 184, 0.15);
    text-decoration: none;
}

@media (max-width: 1024px) {
    .admin-topbar {
        left: 0;
        padding: 0 16px;
    }

    .user-chip__name {
        display: none;
    }
}
</style>

<script>
document.addEventListener('DOMContentLoaded', () => {
    const body = document.body;
    const sidebarToggle = document.getElementById('sidebarToggle');
    const userMenuBtn = document.getElementById('userMenuBtn');
    const userDropdown = document.getElementById('userDropdown');

    if (sidebarToggle) {
        sidebarToggle.addEventListener('click', () => {
            if (window.innerWidth <= 1024) {
                body.classList.toggle('sidebar-open');
            } else {
                body.classList.toggle('sidebar-collapsed');
            }
        });
    }

    if (userMenuBtn && userDropdown) {
        userMenuBtn.addEventListener('click', () => {
            const expanded = userMenuBtn.getAttribute('aria-expanded') === 'true';
            userMenuBtn.setAttribute('aria-expanded', String(!expanded));
            userDropdown.classList.toggle('show');
        });

        document.addEventListener('click', (event) => {
            if (!userMenuBtn.contains(event.target) && !userDropdown.contains(event.target)) {
                userMenuBtn.setAttribute('aria-expanded', 'false');
                userDropdown.classList.remove('show');
            }
        });
    }
});
</script>

