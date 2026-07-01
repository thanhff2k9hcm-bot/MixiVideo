package dao;

import entity.Video;
import utils.JpaUtils;
import jakarta.persistence.EntityManager;
import java.util.List;

public class VideoDAO {

    /**
     * Hàm làm sạch ID: Xử lý cả dạng link dài (watch?v=) và link rút gọn (youtu.be/)
     */
    private String extractVideoId(String url) {
        if (url == null || url.trim().isEmpty()) return null;
        String trimmedUrl = url.trim();

        // Xử lý link rút gọn: https://youtu.be/M6FPvmqHGU4?list=...
        if (trimmedUrl.contains("youtu.be/")) {
            String idPart = trimmedUrl.split("youtu.be/")[1];
            return idPart.split("[?&]")[0]; // Lấy phần trước dấu ? hoặc &
        }

        // Xử lý link đầy đủ: https://www.youtube.com/watch?v=KtMeCi4WpTI&list=...
        if (trimmedUrl.contains("v=")) {
            String idPart = trimmedUrl.split("v=")[1];
            return idPart.split("&")[0]; // Lấy phần trước dấu &
        }

        // Nếu đã là ID thuần túy
        return trimmedUrl;
    }

    public Video findById(String id) {
        if (id == null) return null;
        EntityManager em = JpaUtils.getEntityManager();
        try {
            // Lưu ý: ID trong DB phải là dạng đã sạch
            return em.find(Video.class, extractVideoId(id));
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        } finally {
            em.close();
        }
    }

    public List<Video> findAll() {
        EntityManager em = JpaUtils.getEntityManager();
        try {
            return em.createQuery("SELECT v FROM Video v", Video.class).getResultList();
        } finally {
            em.close();
        }
    }
    
    public List<Video> searchByTitle(String keyword) {
        EntityManager em = JpaUtils.getEntityManager();
        try {
            return em.createQuery("SELECT v FROM Video v WHERE v.title LIKE :keyword", Video.class)
                     .setParameter("keyword", "%" + keyword + "%")
                     .getResultList();
        } finally {
            em.close();
        }
    }

    public void insert(Video video) {
        video.setId(extractVideoId(video.getId()));
        EntityManager em = JpaUtils.getEntityManager();
        try {
            em.getTransaction().begin();
            em.persist(video);
            em.getTransaction().commit();
        } catch (Exception e) {
            em.getTransaction().rollback();
            throw e; // Ném ngoại lệ để Controller xử lý thông báo lỗi
        } finally {
            em.close();
        }
    }

    public void update(Video video) {
        video.setId(extractVideoId(video.getId()));
        EntityManager em = JpaUtils.getEntityManager();
        try {
            em.getTransaction().begin();
            em.merge(video);
            em.getTransaction().commit();
        } catch (Exception e) {
            em.getTransaction().rollback();
            throw e;
        } finally {
            em.close();
        }
    }

    public void delete(String id) {
        EntityManager em = JpaUtils.getEntityManager();
        try {
            em.getTransaction().begin();
            Video video = em.find(Video.class, extractVideoId(id));
            if (video != null) {
                em.remove(video);
            }
            em.getTransaction().commit();
        } catch (Exception e) {
            em.getTransaction().rollback();
            throw e;
        } finally {
            em.close();
        }
    }
}