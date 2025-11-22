-- Script để bỏ dấu Unicode trong tên file ảnh
-- Chạy script này để cập nhật tên ảnh trong database

USE cuahangden;

-- Cập nhật tên ảnh, bỏ dấu tiếng Việt
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
SELECT ma_den, ten_den, hinh_anh FROM den ORDER BY ma_den;

