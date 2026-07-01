package dao;

import entity.User;
import utils.JpaUtils;
import jakarta.persistence.EntityManager;
import jakarta.persistence.TypedQuery;
import java.util.List;

public class UserDAO {

    // SỬA ĐỔI: Sử dụng JPQL để tìm kiếm và đăng nhập bằng Email thay vì ID (Khóa chính)
    public User login(String email, String password) {
        EntityManager em = JpaUtils.getEntityManager();
        try {
            String jpql = "SELECT u FROM User u WHERE u.email = :email AND u.password = :password";
            TypedQuery<User> query = em.createQuery(jpql, User.class);
            query.setParameter("email", email);
            query.setParameter("password", password);
            
            return query.getSingleResult();
        } catch (Exception e) {
            // Trả về null nếu không tìm thấy tài khoản (NoResultException) hoặc sai mật khẩu
            return null;
        } finally {
            em.close();
        }
    }

    public void insert(User user) {
        EntityManager em = JpaUtils.getEntityManager();
        try {
            em.getTransaction().begin();
            em.persist(user);
            em.getTransaction().commit();
        } catch (Exception e) {
            em.getTransaction().rollback();
            e.printStackTrace();
        } finally {
            em.close();
        }
    }

    public List<User> findAll() {
        EntityManager em = JpaUtils.getEntityManager();
        try {
            return em.createQuery("SELECT u FROM User u", User.class)
                     .getResultList();
        } finally {
            em.close();
        }
    }

    // SỬA ĐỔI: Chuyển sang JPQL vì email không phải khóa chính, không dùng em.find() được
    public User findByEmail(String email) {
        EntityManager em = JpaUtils.getEntityManager();
        try {
            String jpql = "SELECT u FROM User u WHERE u.email = :email";
            TypedQuery<User> query = em.createQuery(jpql, User.class);
            query.setParameter("email", email);
            
            return query.getSingleResult();
        } catch (Exception e) {
            return null;
        } finally {
            em.close();
        }
    }

    // BỔ SUNG THÊM (Nếu cần): Tìm kiếm theo đúng Khóa chính ID của bảng User
    public User findById(String id) {
        EntityManager em = JpaUtils.getEntityManager();
        try {
            return em.find(User.class, id);
        } finally {
            em.close();
        }
    }

    public void update(User user) {
        EntityManager em = JpaUtils.getEntityManager();
        try {
            em.getTransaction().begin();
            em.merge(user);
            em.getTransaction().commit();
        } catch (Exception e) {
            em.getTransaction().rollback();
        } finally {
            em.close();
        }
    }

    // SỬA ĐỔI: Tìm user theo đúng ID khóa chính trước khi xóa để tránh lỗi logic
    public void delete(String id) {
        EntityManager em = JpaUtils.getEntityManager();
        try {
            em.getTransaction().begin();
            User user = em.find(User.class, id);
            if (user != null) {
                em.remove(user);
            }
            em.getTransaction().commit();
        } catch (Exception e) {
            em.getTransaction().rollback();
        } finally {
            em.close();
        }
    }
}