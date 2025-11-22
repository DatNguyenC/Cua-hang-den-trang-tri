@echo off
chcp 65001 >nul
echo ========================================
echo Renaming image files: Remove Unicode
echo ========================================
echo.

cd /d "%~dp0web\assets\images\product"

if not exist "đèn_trần.png" (
    echo Warning: Some image files not found
    echo Please check the directory
    pause
    exit /b
)

echo Renaming files...
echo.

ren "đèn_trần.png" "den_tran.png" 2>nul && echo [OK] đèn_trần.png -^> den_tran.png || echo [SKIP] đèn_trần.png
ren "đèn_ốp_trần.png" "den_op_tran.png" 2>nul && echo [OK] đèn_ốp_trần.png -^> den_op_tran.png || echo [SKIP] đèn_ốp_trần.png
ren "đèn_âm_trần.png" "den_am_tran.png" 2>nul && echo [OK] đèn_âm_trần.png -^> den_am_tran.png || echo [SKIP] đèn_âm_trần.png
ren "đèn_đọc_sách.png" "den_doc_sach.png" 2>nul && echo [OK] đèn_đọc_sách.png -^> den_doc_sach.png || echo [SKIP] đèn_đọc_sách.png
ren "đèn_dây_led.png" "den_day_led.png" 2>nul && echo [OK] đèn_dây_led.png -^> den_day_led.png || echo [SKIP] đèn_dây_led.png
ren "đèn_lava.png" "den_lava.png" 2>nul && echo [OK] đèn_lava.png -^> den_lava.png || echo [SKIP] đèn_lava.png
ren "đèn_trang_trí_tường_nghệ_thuật.png" "den_trang_tri_tuong_nghe_thuat.png" 2>nul && echo [OK] đèn_trang_trí_tường_nghệ_thuật.png -^> den_trang_tri_tuong_nghe_thuat.png || echo [SKIP] đèn_trang_trí_tường_nghệ_thuật.png
ren "đèn_mây_tre_đan.png" "den_may_tre_dan.png" 2>nul && echo [OK] đèn_mây_tre_đan.png -^> den_may_tre_dan.png || echo [SKIP] đèn_mây_tre_đan.png
ren "đèn_nến_led.png" "den_nen_led.png" 2>nul && echo [OK] đèn_nến_led.png -^> den_nen_led.png || echo [SKIP] đèn_nến_led.png
ren "đèn_pha_lê.png" "den_pha_le.png" 2>nul && echo [OK] đèn_pha_lê.png -^> den_pha_le.png || echo [SKIP] đèn_pha_lê.png
ren "đèn_sân_vườn.png" "den_san_vuon.png" 2>nul && echo [OK] đèn_sân_vườn.png -^> den_san_vuon.png || echo [SKIP] đèn_sân_vườn.png
ren "đèn_trụ_cổng.png" "den_tru_cong.png" 2>nul && echo [OK] đèn_trụ_cổng.png -^> den_tru_cong.png || echo [SKIP] đèn_trụ_cổng.png
ren "đèn_năng_lượng_mặt_trời.png" "den_nang_luong_mat_troi.png" 2>nul && echo [OK] đèn_năng_lượng_mặt_trời.png -^> den_nang_luong_mat_troi.png || echo [SKIP] đèn_năng_lượng_mặt_trời.png
ren "đèn_trang_trí_ngoài_trời.png" "den_trang_tri_ngoai_troi.png" 2>nul && echo [OK] đèn_trang_trí_ngoài_trời.png -^> den_trang_tri_ngoai_troi.png || echo [SKIP] đèn_trang_trí_ngoài_trời.png
ren "đèn_đường.png" "den_duong.png" 2>nul && echo [OK] đèn_đường.png -^> den_duong.png || echo [SKIP] đèn_đường.png
ren "đèn_rọi_cây.png" "den_roi_cay.png" 2>nul && echo [OK] đèn_rọi_cây.png -^> den_roi_cay.png || echo [SKIP] đèn_rọi_cây.png
ren "đèn_hồ_bơi.png" "den_ho_boi.png" 2>nul && echo [OK] đèn_hồ_bơi.png -^> den_ho_boi.png || echo [SKIP] đèn_hồ_bơi.png
ren "đèn_rọi_ray.png" "den_roi_ray.png" 2>nul && echo [OK] đèn_rọi_ray.png -^> den_roi_ray.png || echo [SKIP] đèn_rọi_ray.png
ren "đèn_âm_sàn.png" "den_am_san.png" 2>nul && echo [OK] đèn_âm_sàn.png -^> den_am_san.png || echo [SKIP] đèn_âm_sàn.png
ren "đèn_khẩn_cấp.png" "den_khan_cap.png" 2>nul && echo [OK] đèn_khẩn_cấp.png -^> den_khan_cap.png || echo [SKIP] đèn_khẩn_cấp.png

echo.
echo ========================================
echo Renaming completed!
echo.
echo Next step: Run the SQL script 'update_image_names_no_unicode.sql' to update the database
echo ========================================
pause

