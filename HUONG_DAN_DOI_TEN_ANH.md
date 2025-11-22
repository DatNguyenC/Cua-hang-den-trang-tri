# Hướng dẫn bỏ dấu Unicode trong tên ảnh

## Vấn đề
Tên file ảnh trong database có dấu tiếng Việt (ví dụ: `đèn_trần.png`) gây lỗi khi hiển thị trên web.

## Giải pháp
Bỏ dấu Unicode trong tên file ảnh cả trong database và thư mục file.

## Các bước thực hiện

### Bước 1: Đổi tên file ảnh trong thư mục
Chạy file `rename_images.bat` để tự động đổi tên tất cả file ảnh:

```bash
rename_images.bat
```

Hoặc đổi tên thủ công từ:
- `đèn_trần.png` → `den_tran.png`
- `đèn_ốp_trần.png` → `den_op_tran.png`
- `đèn_âm_trần.png` → `den_am_tran.png`
- ... (xem file SQL để biết đầy đủ)

### Bước 2: Cập nhật database
Chạy file SQL `update_image_names_no_unicode.sql` trong MySQL/phpMyAdmin:

```sql
-- Mở file update_image_names_no_unicode.sql và chạy trong database
```

### Bước 3: Kiểm tra
Refresh trang web và kiểm tra xem ảnh đã hiển thị chưa.

## Mapping tên file

| Tên cũ (có dấu) | Tên mới (không dấu) |
|-----------------|---------------------|
| đèn_trần.png | den_tran.png |
| đèn_ốp_trần.png | den_op_tran.png |
| đèn_âm_trần.png | den_am_tran.png |
| đèn_đọc_sách.png | den_doc_sach.png |
| đèn_dây_led.png | den_day_led.png |
| đèn_lava.png | den_lava.png |
| đèn_trang_trí_tường_nghệ_thuật.png | den_trang_tri_tuong_nghe_thuat.png |
| đèn_mây_tre_đan.png | den_may_tre_dan.png |
| đèn_nến_led.png | den_nen_led.png |
| đèn_pha_lê.png | den_pha_le.png |
| đèn_sân_vườn.png | den_san_vuon.png |
| đèn_trụ_cổng.png | den_tru_cong.png |
| đèn_năng_lượng_mặt_trời.png | den_nang_luong_mat_troi.png |
| đèn_trang_trí_ngoài_trời.png | den_trang_tri_ngoai_troi.png |
| đèn_đường.png | den_duong.png |
| đèn_rọi_cây.png | den_roi_cay.png |
| đèn_hồ_bơi.png | den_ho_boi.png |
| đèn_rọi_ray.png | den_roi_ray.png |
| đèn_âm_sàn.png | den_am_san.png |
| đèn_khẩn_cấp.png | den_khan_cap.png |

## Lưu ý
- Đảm bảo đổi tên file trước khi chạy SQL
- Backup database trước khi chạy script SQL
- Kiểm tra kỹ tên file sau khi đổi tên

