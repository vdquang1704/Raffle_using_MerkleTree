Đề bài: Smart contract phát tiền. Trong n người ngẫu nhiên, chọn 1 người trúng thưởng.

Requirements:

1. Thay vì lưu danh sách n người lên contract thì dùng merkle tree.
2. Những ai trúng thì lấy địa chỉ hash thành 1 tree. Trên contract chỉ lưu gốc. Trong database thì lưu lá và cành.
3. Lúc user vào thì lấy lá với cành tương ứng để verify lại trên blockchain.
4. Ai claim rồi thì không được claim nữa.
