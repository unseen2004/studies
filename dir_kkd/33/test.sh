#!/bin/bash

# Kolory dla czytelności
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo "=========================================="
echo "  Test automatyczny dla programu LZW"
echo "=========================================="
echo

# Kompilacja
echo -e "${YELLOW}[1/5] Kompilacja programu...${NC}"
g++ -std=c++17 -O2 -o lzw lzw.cpp
if [ $? -ne 0 ]; then
    echo -e "${RED}✗ Błąd kompilacji${NC}"
    exit 1
fi
echo -e "${GREEN}✓ Kompilacja zakończona sukcesem${NC}"
echo

# Test 1: Prosty tekst
echo -e "${YELLOW}[2/5] Test 1: Prosty tekst powtarzalny${NC}"
echo "a-bar-array-by-barrayar-bay" > test1.txt
./lzw encode test1.txt test1.lzw
./lzw decode test1.lzw test1_decoded.txt

if cmp -s test1.txt test1_decoded.txt; then
    echo -e "${GREEN}✓ Test 1 ZALICZONY - plik poprawnie zdekodowany${NC}"
else
    echo -e "${RED}✗ Test 1 NIEZALICZONY - plik różni się od oryginału${NC}"
fi
echo

# Test 2: Tekst z dużą powtarzalnością
echo -e "${YELLOW}[3/5] Test 2: Tekst z wysoką kompresją${NC}"
echo "AAAAAAAAAA BBBBBBBBBB CCCCCCCCCC AAAAAAAAAA BBBBBBBBBB CCCCCCCCCC" > test2.txt
./lzw encode test2.txt test2.lzw
./lzw decode test2.lzw test2_decoded.txt

if cmp -s test2.txt test2_decoded.txt; then
    echo -e "${GREEN}✓ Test 2 ZALICZONY - wysoka kompresja działa${NC}"
else
    echo -e "${RED}✗ Test 2 NIEZALICZONY - plik różni się od oryginału${NC}"
fi
echo

# Test 3: Dane binarne (losowe)
echo -e "${YELLOW}[4/5] Test 3: Dane binarne${NC}"
dd if=/dev/urandom of=test3.bin bs=1024 count=10 2>/dev/null
./lzw encode test3.bin test3.lzw > /dev/null 2>&1
./lzw decode test3.lzw test3_decoded.bin

if cmp -s test3.bin test3_decoded.bin; then
    echo -e "${GREEN}✓ Test 3 ZALICZONY - dane binarne poprawnie obsłużone${NC}"
else
    echo -e "${RED}✗ Test 3 NIEZALICZONY - dane binarne różnią się${NC}"
fi
echo

# Test 4: Plik tekstowy większy
echo -e "${YELLOW}[5/5] Test 4: Większy plik tekstowy${NC}"
cat << 'EOF' > test4.txt
Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor
incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis
nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.
Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor
incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis
nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.
Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor
incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis
nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.
EOF

./lzw encode test4.txt test4.lzw
./lzw decode test4.lzw test4_decoded.txt

if cmp -s test4.txt test4_decoded.txt; then
    echo -e "${GREEN}✓ Test 4 ZALICZONY - większy plik tekstowy OK${NC}"
else
    echo -e "${RED}✗ Test 4 NIEZALICZONY - większy plik różni się${NC}"
fi
echo

# Podsumowanie
echo "=========================================="
echo -e "${GREEN}  Wszystkie testy zakończone!${NC}"
echo "=========================================="
echo

# Pokaz statystyk dla przykładowego pliku
echo -e "${YELLOW}Przykładowe statystyki kompresji (test4.txt):${NC}"
./lzw encode test4.txt test4_final.lzw
echo

# Sprzątanie
echo "Czyszczenie plików tymczasowych..."
rm -f test1.txt test1.lzw test1_decoded.txt
rm -f test2.txt test2.lzw test2_decoded.txt
rm -f test3.bin test3.lzw test3_decoded.bin
rm -f test4.txt test4.lzw test4_decoded.txt test4_final.lzw
rm -f lzw

echo -e "${GREEN}✓ Gotowe!${NC}"