#!/bin/bash
# PHOLX CYBER SECURITY - MAIN SWITCHBOARD

while true; do
    clear
    echo "===================================================="
    echo "         PHOLX CYBER SECURITY MASTER SUITE         "
    echo "===================================================="
    echo " [1] SOC Module (Monitoring & Threat Hunting)"
    echo " [2] VAPT Module (Vulnerability & Penetration Test)"
    echo " [3] Exit"
    echo "===================================================="
    read -p "Select Mode [1-3]: " main_opt

    case $main_opt in
        1)
            # เรียกสคริปต์ SOC ถ้าทำงานเสร็จมันจะเด้งกลับมาหน้านี้
            bash ~/Documents/soc_toot.sh
            ;;
        2)
            # เรียกสคริปต์ VAPT (ตัวในรูปภาพใหม่)
            bash ~/Documents/soc_vapt.sh
            ;;
        3)
            echo "Exiting Master Suite..."
            exit 0
            ;;
        *)
            echo "Invalid option"
            sleep 1
            ;;
    esac
done

