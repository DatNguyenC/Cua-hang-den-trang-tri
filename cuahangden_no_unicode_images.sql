-- ============================================
-- Script SQL: Cập nhật dữ liệu với tên ảnh không có dấu Unicode
-- ============================================
-- File này cập nhật tên ảnh trong bảng den từ tên có dấu sang tên không dấu
-- Chạy script này sau khi đã đổi tên file ảnh trong thư mục assets/images/product/

USE cuahangden;

-- Bắt đầu transaction
START TRANSACTION;

-- Cập nhật tên ảnh: Bỏ dấu Unicode
UPDATE den SET hinh_anh = 'den_tran.png' WHERE hinh_anh = 'đèn_trần.png';
UPDATE den SET hinh_anh = 'den_op_tran.png' WHERE hinh_anh = 'đèn_ốp_trần.png';
UPDATE den SET hinh_anh = 'den_am_tran.png' WHERE hinh_anh = 'đèn_âm_trần.png';
UPDATE den SET hinh_anh = 'den_doc_sach.png' WHERE hinh_anh = 'đèn_đọc_sách.png';
UPDATE den SET hinh_anh = 'den_day_led.png' WHERE hinh_anh = 'đèn_dây_led.png';
UPDATE den SET hinh_anh = 'den_lava.png' WHERE hinh_anh = 'đèn_lava.png';
UPDATE den SET hinh_anh = 'den_trang_tri_tuong_nghe_thuat.png' WHERE hinh_anh = 'đèn_trang_trí_tường_nghệ_thuật.png';
UPDATE den SET hinh_anh = 'den_may_tre_dan.png' WHERE hinh_anh = 'đèn_mây_tre_đan.png';
UPDATE den SET hinh_anh = 'den_nen_led.png' WHERE hinh_anh = 'đèn_nến_led.png';
UPDATE den SET hinh_anh = 'den_pha_le.png' WHERE hinh_anh = 'đèn_pha_lê.png';
UPDATE den SET hinh_anh = 'den_san_vuon.png' WHERE hinh_anh = 'đèn_sân_vườn.png';
UPDATE den SET hinh_anh = 'den_tru_cong.png' WHERE hinh_anh = 'đèn_trụ_cổng.png';
UPDATE den SET hinh_anh = 'den_nang_luong_mat_troi.png' WHERE hinh_anh = 'đèn_năng_lượng_mặt_trời.png';
UPDATE den SET hinh_anh = 'den_trang_tri_ngoai_troi.png' WHERE hinh_anh = 'đèn_trang_trí_ngoài_trời.png';
UPDATE den SET hinh_anh = 'den_duong.png' WHERE hinh_anh = 'đèn_đường.png';
UPDATE den SET hinh_anh = 'den_roi_cay.png' WHERE hinh_anh = 'đèn_rọi_cây.png';
UPDATE den SET hinh_anh = 'den_ho_boi.png' WHERE hinh_anh = 'đèn_hồ_bơi.png';
UPDATE den SET hinh_anh = 'den_roi_ray.png' WHERE hinh_anh = 'đèn_rọi_ray.png';
UPDATE den SET hinh_anh = 'den_am_san.png' WHERE hinh_anh = 'đèn_âm_sàn.png';
UPDATE den SET hinh_anh = 'den_khan_cap.png' WHERE hinh_anh = 'đèn_khẩn_cấp.png';

-- Kiểm tra kết quả
SELECT 
    ma_den,
    ten_den,
    hinh_anh AS 'Tên ảnh mới (không dấu)'
FROM den 
WHERE hinh_anh IS NOT NULL
ORDER BY ma_den;

-- Commit transaction
COMMIT;

-- ============================================
-- HƯỚNG DẪN SỬ DỤNG:
-- ============================================
-- 1. Chạy script PowerShell rename_images.ps1 để đổi tên file ảnh trong thư mục
-- 2. Chạy script SQL này để cập nhật database
-- 3. Refresh trang web và kiểm tra lại
-- ============================================

