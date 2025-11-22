-- Script để thêm AUTO_INCREMENT cho các bảng
-- Chạy script này nếu các bảng chưa có AUTO_INCREMENT

-- Thêm AUTO_INCREMENT cho bảng hoa_don
ALTER TABLE `hoa_don` 
  MODIFY `ma_hd` int(11) NOT NULL AUTO_INCREMENT;

-- Thêm AUTO_INCREMENT cho bảng chi_tiet_hoa_don
ALTER TABLE `chi_tiet_hoa_don` 
  MODIFY `ma_cthd` int(11) NOT NULL AUTO_INCREMENT;

-- Nếu cần set giá trị bắt đầu (tùy chọn)
-- ALTER TABLE `hoa_don` AUTO_INCREMENT = 1;
-- ALTER TABLE `chi_tiet_hoa_don` AUTO_INCREMENT = 1;

