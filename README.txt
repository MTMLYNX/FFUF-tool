
ffuf -w {dosya yolu} -u {kurban URL} -H {header} -c -mc200

örnek kullanımı: -w(wordlist) -u(fuzz ın deneneceği yerdir.) -H(eklemek istenilen başlık) -c(çıktıyı renkli yapar) -mc 200(sadece OK yanıtlarını göster)

ffuf -w /home/kali/Downloads/subdomains-top1million-5000.txt -u http://editorial.htb -H "Host:FUZZ.editorial.htb" -c -mc 200

chmod +x domainfuzz.sh
./domainfuzz.sh TestEdilecekDomainler.txt fuzzlist.txt
