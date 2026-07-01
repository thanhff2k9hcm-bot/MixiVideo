	package controller;
	
	import java.io.IOException;
	import java.util.List;
	import java.util.stream.Collectors;
	
	import dao.UserDAO;
	import dao.VideoDAO;
	import entity.User;
	import entity.Video;
	import jakarta.servlet.ServletException;
	import jakarta.servlet.annotation.WebServlet;
	import jakarta.servlet.http.HttpServlet;
	import jakarta.servlet.http.HttpServletRequest;
	import jakarta.servlet.http.HttpServletResponse;
	
	@WebServlet({
	"/",
	"/home",
	"/login",
	"/registration",
	"/logout",
	"/video/detail",
	"/admin",
	"/admin/video/edit",
	"/admin/video/create",
	"/admin/video/update",
	"/admin/video/delete"
	})
	public class MainController extends HttpServlet {
	
	private static final long serialVersionUID = 1L;
	
	private final UserDAO uDao = new UserDAO();
	private final VideoDAO vDao = new VideoDAO();
	
	private void loadAdminData(HttpServletRequest req, User currentUser) {
	
	    List<Video> allVideos = vDao.findAll();
	
	    boolean isAdmin =
	            currentUser.getAdmin() != null
	            && currentUser.getAdmin();
	
	    if (isAdmin) {
	        req.setAttribute("videos", allVideos);
	    } else {
	
	        List<Video> myVideos =
	                allVideos.stream()
	                .filter(v ->
	                        v.getUser() != null
	                        && v.getUser().getId()
	                        .equals(currentUser.getId()))
	                .collect(Collectors.toList());
	
	        req.setAttribute("videos", myVideos);
	    }
	
	    req.setAttribute("users", uDao.findAll());
	}
	
	@Override
	protected void doGet(
	        HttpServletRequest req,
	        HttpServletResponse resp)
	        throws ServletException, IOException {
	
	    req.setCharacterEncoding("UTF-8");
	    resp.setCharacterEncoding("UTF-8");
	    resp.setContentType("text/html;charset=UTF-8");
	
	    String path = req.getServletPath();
	
	    switch (path) {
	
	    case "/":
	    case "/home":
	
	        String keyword = req.getParameter("keyword");
	
	        List<Video> videos;
	
	        if (keyword != null && !keyword.trim().isEmpty()) {
	            videos = vDao.searchByTitle(keyword.trim());
	        } else {
	            videos = vDao.findAll();
	        }
	
	        videos = videos.stream()
	                .filter(v ->
	                        v.getActive() != null
	                        && v.getActive())
	                .collect(Collectors.toList());
	
	        req.setAttribute("videos", videos);
	
	        req.getRequestDispatcher("/views/home.jsp")
	                .forward(req, resp);
	
	        break;
	
	    case "/login":
	
	        req.getRequestDispatcher("/views/login.jsp")
	                .forward(req, resp);
	
	        break;
	
	    case "/registration":
	
	        req.getRequestDispatcher("/views/registration.jsp")
	                .forward(req, resp);
	
	        break;
	
	    case "/logout":
	
	        req.getSession().invalidate();
	
	        resp.sendRedirect(
	                req.getContextPath() + "/home");
	
	        break;
	
	    case "/video/detail":
	
	        String videoId = req.getParameter("id");
	
	        if (videoId != null
	                && !videoId.trim().isEmpty()) {
	
	            Video video =
	                    vDao.findById(videoId.trim());
	
	            if (video != null) {
	
	                Integer views =
	                        video.getViews() == null
	                        ? 0
	                        : video.getViews();
	
	                video.setViews(views + 1);
	
	                vDao.update(video);
	
	                req.setAttribute("video", video);
	            }
	        }
	
	        req.getRequestDispatcher("/views/detail.jsp")
	                .forward(req, resp);
	
	        break;
	
	    case "/admin":
	    case "/admin/video/edit":
	
	        User currentUser =
	                (User) req.getSession()
	                .getAttribute("currentUser");
	
	        if (currentUser == null) {
	
	            resp.sendRedirect(
	                    req.getContextPath()
	                    + "/login");
	
	            return;
	        }
	
	        String editId =
	                req.getParameter("id");
	
	        if (editId != null
	                && !editId.trim().isEmpty()) {
	
	            Video editVideo =
	                    vDao.findById(editId.trim());
	
	            if (editVideo != null) {
	
	                boolean isAdmin =
	                        currentUser.getAdmin() != null
	                        && currentUser.getAdmin();
	
	                boolean isOwner =
	                        editVideo.getUser() != null
	                        && editVideo.getUser()
	                        .getId()
	                        .equals(currentUser.getId());
	
	                if (isAdmin || isOwner) {
	                    req.setAttribute(
	                            "videoForm",
	                            editVideo);
	                } else {
	                    req.setAttribute(
	                            "message",
	                            "Bạn không có quyền sửa video này!");
	                }
	            }
	        }
	
	        loadAdminData(req, currentUser);
	
	        req.getRequestDispatcher("/views/admin.jsp")
	                .forward(req, resp);
	
	        break;
	    }
	}
	
	@Override
	protected void doPost(
	        HttpServletRequest req,
	        HttpServletResponse resp)
	        throws ServletException, IOException {
	
	    req.setCharacterEncoding("UTF-8");
	    resp.setCharacterEncoding("UTF-8");
	    resp.setContentType("text/html;charset=UTF-8");
	
	    String path = req.getServletPath();
	
	    switch (path) {
	
	    case "/login":
	
	        User user =
	                uDao.login(
	                        req.getParameter("email"),
	                        req.getParameter("password"));
	
	        if (user != null) {
	
	            req.getSession()
	                    .setAttribute(
	                            "currentUser",
	                            user);
	
	            resp.sendRedirect(
	                    req.getContextPath()
	                    + "/admin");
	
	        } else {
	
	            req.setAttribute(
	                    "message",
	                    "Sai email hoặc mật khẩu!");
	
	            req.getRequestDispatcher(
	                    "/views/login.jsp")
	                    .forward(req, resp);
	        }
	
	        break;
	
	    case "/registration":
	
	        User newUser = new User();
	
	        newUser.setId(
	                req.getParameter("email"));
	
	        newUser.setEmail(
	                req.getParameter("email"));
	
	        newUser.setFullname(
	                req.getParameter("fullname"));
	
	        newUser.setPassword(
	                req.getParameter("password"));
	
	        newUser.setAdmin(false);
	
	        uDao.insert(newUser);
	
	        resp.sendRedirect(
	                req.getContextPath()
	                + "/login?success=true");
	
	        break;
	
	    case "/admin/video/create":
	
	        User creator =
	                (User) req.getSession()
	                .getAttribute("currentUser");
	
	        if (creator == null) {
	            resp.sendRedirect(
	                    req.getContextPath()
	                    + "/login");
	            return;
	        }
	
	        Video videoCreate =
	                new Video();
	
	        videoCreate.setId(
	                req.getParameter("id"));
	
	        videoCreate.setTitle(
	                req.getParameter("title"));
	
	        videoCreate.setPoster(
	                req.getParameter("poster"));
	
	        videoCreate.setVideoUrl(
	                req.getParameter("videoUrl"));
	
	        videoCreate.setDescription(
	                req.getParameter("description"));
	
	        try {
	
	            videoCreate.setViews(
	                    Integer.parseInt(
	                            req.getParameter("views")));
	
	        } catch (Exception e) {
	
	            videoCreate.setViews(0);
	        }
	
	        videoCreate.setActive(
	                req.getParameter("active")
	                != null);
	
	        videoCreate.setUser(creator);
	
	        vDao.insert(videoCreate);
	
	        resp.sendRedirect(
	                req.getContextPath()
	                + "/admin");
	
	        break;
	
	    case "/admin/video/update":
	
	        User updateUser =
	                (User) req.getSession()
	                .getAttribute("currentUser");
	
	        if (updateUser == null) {
	            resp.sendRedirect(
	                    req.getContextPath()
	                    + "/login");
	            return;
	        }
	
	        String updateId =
	                req.getParameter("id");
	
	        Video updateVideo =
	                vDao.findById(updateId);
	
	        if (updateVideo != null) {
	
	            updateVideo.setTitle(
	                    req.getParameter("title"));
	
	            updateVideo.setPoster(
	                    req.getParameter("poster"));
	
	            updateVideo.setVideoUrl(
	                    req.getParameter("videoUrl"));
	
	            updateVideo.setDescription(
	                    req.getParameter("description"));
	
	            try {
	
	                updateVideo.setViews(
	                        Integer.parseInt(
	                                req.getParameter("views")));
	
	            } catch (Exception e) {
	
	                updateVideo.setViews(0);
	            }
	
	            updateVideo.setActive(
	                    req.getParameter("active")
	                    != null);
	
	            vDao.update(updateVideo);
	        }
	
	        resp.sendRedirect(
	                req.getContextPath()
	                + "/admin");
	
	        break;
	
	    case "/admin/video/delete":
	
	        User deleteUser =
	                (User) req.getSession()
	                .getAttribute("currentUser");
	
	        if (deleteUser == null) {
	            resp.sendRedirect(
	                    req.getContextPath()
	                    + "/login");
	            return;
	        }
	
	        String deleteId =
	                req.getParameter("id");
	
	        Video deleteVideo =
	                vDao.findById(deleteId);
	
	        if (deleteVideo != null) {
	
	            boolean isAdmin =
	                    deleteUser.getAdmin() != null
	                    && deleteUser.getAdmin();
	
	            boolean isOwner =
	                    deleteVideo.getUser() != null
	                    && deleteVideo.getUser()
	                    .getId()
	                    .equals(deleteUser.getId());
	
	            if (isAdmin || isOwner) {
	                vDao.delete(deleteId);
	            }
	        }
	
	        resp.sendRedirect(
	                req.getContextPath()
	                + "/admin");
	
	        break;
	    }
	}
	
	
	}
