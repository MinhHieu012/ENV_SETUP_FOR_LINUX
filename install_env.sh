# Hàm hiển thị tiêu đề với màu sắc
function print_title {
    echo -e "\033[1;34m$1\033[0m"
}

# Hàm hiển thị thông báo với màu sắc
function print_info {
    echo -e "\033[1;32m$1\033[0m"
}

# Hàm hiển thị lỗi
function print_error {
    echo -e "\033[1;31m$1\033[0m"
}

# Hàm hiển thị thông tin tác giả
function print_author {
    echo -e "\033[1;36mMade by: Lê Minh Hiếu\033[0m"
}

# Hàm đếm ngược
function countdown {
    local environment=$1
    for i in {5..1}; do
        echo -ne "\rSẽ cài đặt môi trường $environment sau $i giây... Nhấn 'q' để quay lại menu! "
        read -t 1 -n 1 input
        if [[ $input == "q" ]]; then
            print_title "\n=== Chọn môi trường cài đặt ==="
            return 1
        fi
    done
    echo ""
    return 0
}

# Hàm đếm ngược 3 giây cho mỗi tiêu đề
function countdown_title {
    local title=$1
    echo ""  # Thêm một dòng trống trước tiêu đề
    for i in {3..1}; do
        echo -ne "\r\033[1;33m$title (${i}s)... Nhấn 's' để dừng chạy và quay lại menu! \033[0m"
        read -t 1 -n 1 input
        if [[ $input == "s" ]]; then
            echo -e "\n\033[1;33mĐã dừng cài đặt môi trường! Quay lại menu chính! \033[0m"
            return 1
        fi
    done
    echo -e "\r\033[1;33m$title\033[0m"
    echo ""
    return 0
}

# Hiển thị thông tin tác giả
print_author

while true; do
    # Chỉ hiển thị menu một lần trước khi vào vòng lặp
    if [[ -z "$choice" ]]; then
        print_title "=== Chọn môi trường cài đặt ==="
        echo "1. Cài đặt môi trường airdrop"
        echo "2. Cài đặt môi trường docker"
        echo "3. Cài đặt Git"
        echo "4. Cài đặt unikey (ibus-bamboo)"
        echo "5. Cài đặt MySQL (MySQL Workbench)"
        echo "6. Thoát"
    fi
    
    read -p "$(print_info 'Nhập lựa chọn của bạn (1, 2, 3 hoặc 4): ')" choice

    if [[ "$choice" == "1" ]]; then
        countdown "airdrop" || continue
        echo ""
        print_title "--------------- Bắt đầu cài đặt môi trường airdrop! ---------------"
        
        # Thiết lập biến môi trường để cài đặt không yêu cầu tương tác
        export DEBIAN_FRONTEND=noninteractive

        countdown_title "Cập nhật và nâng cấp hệ thống trong" || continue
        sudo apt-get update && sudo apt-get upgrade -y

        countdown_title "Cài đặt các gói cần thiết" || continue
        sudo apt-get install -y software-properties-common curl screen

        countdown_title "Thêm PPA cho Python 3.11 và cài đặt Python 3.11" || continue
        sudo add-apt-repository ppa:deadsnakes/ppa -y
        sudo apt-get update
        sudo apt-get install -y python3.11 python3.11-dev python3.11-venv python3.11-distutils python3.11-gdbm python3.11-tk python3.11-lib2to3

        countdown_title "Cài đặt pip cho Python 3.11" || continue
        curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py
        sudo python3.11 get-pip.py

        countdown_title "Cài đặt các gói Python cần thiết" || continue
        sudo python3.11 -m pip install requests colorama aiocfscrape brotli aiohttp cloudscraper fake_useragent hydrogram tgcrypto smart-airdrop-claimer pycryptodome

        countdown_title "Cài đặt Node.js và các gói liên quan" || continue
        curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash
        export NVM_DIR="$HOME/.nvm"
        source "$NVM_DIR/nvm.sh"
        nvm install v20.15.1
        nvm use v20.15.1
        npm install -g axios https-proxy-agent fs colors luxon querystring yargs minimist ws

        countdown_title "Cập nhật và nâng cấp cuối cùng" || continue
        sudo apt-get update

        echo ""
        print_info "--------------- Kết quả cài đặt môi trường airdrop! ---------------"
        echo "Phiên bản Node.js: $(node --version)"
        echo "Phiên bản Python: $(python3.11 --version)"
        echo "-----------------------------------------------------------------"

        # Thông báo hoàn tất
        print_info "--------------- Cài đặt môi trường airdrop hoàn tất! --------------"
        break

    elif [[ "$choice" == "2" ]]; then
        countdown "docker" || continue

        print_title "--------------- Bắt đầu cài đặt môi trường docker! ---------------"
        
        # Thiết lập biến môi trường để cài đặt không yêu cầu tương tác
        export DEBIAN_FRONTEND=noninteractive

        countdown_title "Cập nhật và nâng cấp hệ thống" || continue
        sudo apt-get update && sudo apt-get upgrade -y

        countdown_title "Cài đặt các gói cần thiết" || continue
        sudo apt-get install -y software-properties-common curl screen

        countdown_title "Cài đặt môi trường docker" || continue
        sudo apt-get install ca-certificates curl
        sudo install -m 0755 -d /etc/apt/keyrings
        sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
        sudo chmod a+r /etc/apt/keyrings/docker.asc
        echo \
        "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
        $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
        sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
        sudo apt-get update
        sudo apt-get install \
         ca-certificates \
         curl \
         gnupg \
         lsb-release
        curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
        echo \
        "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
        $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
        sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y

        countdown_title "Cài đặt docker-compose" || continue
        sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
        sudo chmod 777 /usr/local/bin/docker-compose

        countdown_title "Cấu hình tường lửa" || continue
        sudo ufw allow 80/tcp
        sudo ufw allow 443/tcp
        sudo ufw allow 8080/tcp
        sudo ufw allow 3333/tcp
        sudo ufw allow 3306/tcp

        countdown_title "Cập nhật và nâng cấp cuối cùng" || continue
        sudo apt-get update

        echo ""
        print_info "--------------- Kết quả cài đặt môi trường docker! ---------------"
        echo "Phiên bản Docker: $(docker --version)"
        echo "Phiên bản Docker-compose: $(docker-compose --version)"
        echo "----------------------------------------------------------------"

        # Thông báo hoàn tất
        print_info "--------------- Cài đặt môi trường docker hoàn tất! ---------------"
        break

    elif [[ "$choice" == "3" ]]; then
        countdown "git" || continue

        print_title "--------------- Bắt đầu cài đặt Git! ---------------"
        
        # Cài đặt Git
        countdown_title "Thêm PPA cho Git và cập nhật hệ thống" || continue
        sudo add-apt-repository ppa:git-core/ppa -y
        sudo apt update

        countdown_title "Cài đặt Git" || continue
        sudo apt install git -y

        echo ""
        print_info "--------------- Kết quả cài đặt Git! ---------------"
        echo "Phiên bản Git: $(git --version)"
        echo "----------------------------------------------------------------"

        # Thông báo hoàn tất
        print_info "--------------- Cài đặt Git hoàn tất! ---------------"
        break

    elif [[ "$choice" == "4" ]]; then
        countdown "unikey" || continue

        print_title "--------------- Bắt đầu cài đặt unikey (ibus-bamboo)! ---------------"
        
        # Cài đặt unikey (ibus-bamboo)
        countdown_title "Cài đặt ibus-bamboo" || continue
        sudo apt install ibus-unikey
        ibus restart

        echo ""
        print_info "--------------- Kết quả cài đặt unikey (ibus-bamboo)! ---------------"
        echo "Phiên bản ibus-bamboo: $(ibus version)"
        echo "----------------------------------------------------------------"

        # Thông báo hoàn tất
        print_info "--------------- Cài đặt unikey (ibus-bamboo) hoàn tất! ---------------"

        # Note
        echo ""
        print_info "NOTE"
        print_info "1. Vào setting của keyboard phần Input Sources -> Add Input Sources... -> Chọn Vietnamese (Unikey)"
        print_info "2. Nếu không có hoặc không hoạt động! Vui lòng logout và login lại! Hoặc restart lại máy!"
        break  

    elif [[ "$choice" == "5" ]]; then
        countdown "MySQL" || continue

        print_title "--------------- Bắt đầu cài đặt MySQL (MySQL Workbench)! ---------------"

        countdown_title "Cài đặt MySQL" || continue
        sudo apt install mysql-server -y

        countdown_title "Khởi chạy MySQL service" || continue
        sudo systemctl status mysql.service
        sudo systemctl start mysql.service

        # Note
        echo ""
        print_info "NOTE"
        print_info "1. Script chỉ chạy được đến đây do setup đằng sau khá phức tạp cần người dùng thao tác theo ý muốn cá nhân!"
        print_info "2. Vui lòng qua video này: https://youtu.be/zRfI79BHf3k?si=TTDW4O1AbgKxbdpD để tiếp tục!"

        echo ""
        print_info "--------------- Kết quả cài đặt MySQL (MySQL Workbench)! ---------------"
        echo "Phiên bản MySQL (MySQL Workbench): $(mysql --version)"
        echo "----------------------------------------------------------------"

        # Thông báo hoàn tất
        print_info "--------------- Cài đặt MySQL (MySQL Workbench) hoàn tất! ---------------"
        break      

    elif [[ "$choice" == "6" ]]; then
        print_info "Không có thay đổi nào được thực hiện!"
        exit 0

    else
        print_error "Lựa chọn không hợp lệ! Vui lòng chọn lại!"
    fi
done