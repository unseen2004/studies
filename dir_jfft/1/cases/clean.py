import re
import base64
import os

def clean_test1(content):
    content = re.sub(r'\\', '', content)
    content = re.sub(r'\s+', '', content)

    try:
        missing_padding = len(content) % 4
        if missing_padding:
            content += '=' * (4 - missing_padding)

        decoded_bytes = base64.b64decode(content)
        return decoded_bytes.decode('utf-8', errors='ignore')
    except Exception as e:
        print(f"Blad dekodowania Base64 dla pliku test1.txt: {e}")
        return ""

def clean_test2(content):
    # <--- POPRAWKA
    # Po prostu usuwamy WSZYSTKIE białe znaki (spacje, tabulatory, nowe linie).
    # Nie próbujemy już usuwać komentarzy/docstringów, co powodowało błędy.
    content = re.sub(r'\s+', '', content)
    return content

def clean_test3(content):
    # <--- POPRAWKA
    # Po prostu usuwamy WSZYSTKIE białe znaki (spacje, tabulatory, nowe linie).
    content = re.sub(r'\s+', '', content)
    return content

def main():
    files_to_process = {
        "test1.txt": clean_test1,
        "test2.txt": clean_test2,
        "test3.txt": clean_test3,
    }

    print("--- Rozpoczynanie przetwarzania plików (pomijam test.txt) ---")

    for in_file, clean_function in files_to_process.items():
        out_file = f"{os.path.splitext(in_file)[0]}.processed.txt"

        try:
            with open(in_file, 'r', encoding='utf-8') as f:
                content = f.read()
        except FileNotFoundError:
            print(f"UWAGA: Plik {in_file} nie znaleziony. Pomijanie.")
            continue

        print(f"Przetwarzanie {in_file}...")
        processed_content = clean_function(content)

        with open(out_file, 'w', encoding='utf-8') as f:
            f.write(processed_content)

        print(f"-> Zapisano przetworzoną zawartość do {out_file}")

    print("--- Zakończono ---")

if __name__ == "__main__":
    main()