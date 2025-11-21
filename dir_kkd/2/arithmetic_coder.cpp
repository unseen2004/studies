#include <iostream>
#include <fstream>
#include <vector>
#include <string>
#include <stdexcept>
#include <cstdint>
#include <cmath>
#include <iomanip>

namespace {


// Liczba bitów precyzji dla arytmetyki
constexpr int PRECISION_BITS = 32;
// Używamy uint64_t do przechowywania wartości, aby uniknąć przepełnień podczas obliczeń pośrednich
using int_type = uint64_t;
constexpr int_type TOP_VALUE = (static_cast<int_type>(1) << PRECISION_BITS) - 1;
constexpr int_type FIRST_QUARTER = (TOP_VALUE / 4) + 1;
constexpr int_type HALF = 2 * FIRST_QUARTER;
constexpr int_type THIRD_QUARTER = 3 * FIRST_QUARTER;

// Symbol oznaczający koniec pliku (End Of File)
constexpr uint16_t EOF_SYMBOL = 256;
// Całkowita liczba symboli (0-255 + EOF)
constexpr uint16_t NUM_SYMBOLS = 257;

// Maksymalna suma częstotliwości, po której następuje przeskalowanie modelu
constexpr uint32_t MAX_TOTAL_COUNT = 1 << 16;


// Zapisuje pojedyncze bity do strumienia wyjściowego
class BitWriter {
    std::ostream& os;
    uint8_t buffer = 0;
    int bit_count = 0;
    uint64_t total_bits_written = 0;
    uint64_t total_bytes_written = 0;

    void flush_buffer() {
        if (bit_count > 0) {
            os.put(buffer);
            total_bytes_written++;
            buffer = 0;
            bit_count = 0;
        }
    }

public:
    explicit BitWriter(std::ostream& out) : os(out) {}

    ~BitWriter() {
        flush(); // Upewnij się, że ostatni bajt jest zapisany
    }

    void write(int bit) {
        buffer = (buffer << 1) | (bit & 1);
        bit_count++;
        total_bits_written++;
        if (bit_count == 8) {
            flush_buffer();
        }
    }

    void flush() {
        if (bit_count > 0) {
            // Dopełnij ostatni bajt zerami z prawej strony
            buffer <<= (8 - bit_count);
            flush_buffer();
        }
    }

    uint64_t get_total_bits() const { return total_bits_written; }
    uint64_t get_total_bytes() const { return total_bytes_written; }
};

// Odczytuje pojedyncze bity ze strumienia wejściowego
class BitReader {
    std::istream& is;
    uint8_t buffer = 0;
    int bit_count = 0;

    int read_bit() {
        if (bit_count == 0) {
            int ch = is.get();
            if (ch == EOF) {
                return 0; // Zwróć 0, jeśli skończył się strumień (dopełnienie)
            }
            buffer = static_cast<uint8_t>(ch);
            bit_count = 8;
        }
        bit_count--;
        // Odczytaj najbardziej znaczący bit
        return (buffer >> bit_count) & 1;
    }

public:
    explicit BitReader(std::istream& in) : is(in) {}

    int read() {
        return read_bit();
    }
};

class AdaptiveModel {
    // Drzewo Fenwicka (Binary Indexed Tree) do przechowywania skumulowanych częstotliwości
    std::vector<uint32_t> tree;
    uint32_t total_count = 0;

    // Aktualizuje drzewo Fenwicka (indeksy 1-based)
    void update_tree(int index, int delta) {
        index++; // 1-based indexing
        while (index < tree.size()) {
            tree[index] += delta;
            index += index & (-index); // Przejdź do następnego węzła
        }
    }

    // Odczytuje skumulowaną częstotliwość (indeksy 1-based)
    uint32_t query_tree(int index) const {
        index++; // 1-based indexing
        uint32_t sum = 0;
        while (index > 0) {
            sum += tree[index];
            index -= index & (-index); // Przejdź do rodzica
        }
        return sum;
    }

    // Przeskalowuje wszystkie częstotliwości, gdy suma jest zbyt duża
    void rescale() {
        total_count = 0;
        std::vector<uint32_t> old_tree = tree;
        std::fill(tree.begin(), tree.end(), 0);

        for (int symbol = 0; symbol < NUM_SYMBOLS; ++symbol) {
            // Pobierz starą indywidualną częstotliwość
            uint32_t old_freq = query_tree(symbol, old_tree) - query_tree(symbol - 1, old_tree);
            // Przeskaluj, zapewniając minimum 1
            uint32_t new_freq = (old_freq / 2) + 1;

            update_tree(symbol, new_freq);
            total_count += new_freq;
        }
    }

    // Pomocnik do odpytywania z obsługą indeksu -1
    uint32_t query_tree(int index, const std::vector<uint32_t>& t) const {
        if (index < 0) return 0;
        index++; // 1-based
        uint32_t sum = 0;
        while (index > 0) {
            sum += t[index];
            index -= index & (-index);
        }
        return sum;
    }


public:
    AdaptiveModel() : tree(NUM_SYMBOLS + 1, 0) {
        // Inicjalizacja: każdy symbol (0-256) ma częstotliwość 1
        for (int i = 0; i < NUM_SYMBOLS; ++i) {
            update(i);
        }
    }

    // Aktualizuje model o nowy symbol
    void update(int symbol) {
        update_tree(symbol, 1);
        total_count++;
        if (total_count >= MAX_TOTAL_COUNT) {
            rescale();
        }
    }

    // Zwraca całkowitą sumę częstotliwości
    uint32_t get_total() const {
        return total_count;
    }

    // Zwraca zakres skumulowanych częstotliwości dla danego symbolu
    void get_range(int symbol, uint32_t& low, uint32_t& high) const {
        low = query_tree(symbol - 1); // Skumulowana suma *przed* symbolem
        high = query_tree(symbol);    // Skumulowana suma *włącznie* z symbolem
    }

    // Znajduje symbol odpowiadający danej skumulowanej wartości (dla dekodera)
    int get_symbol(uint32_t target_count, uint32_t& low, uint32_t& high) const {
        // Wyszukiwanie binarne na drzewie Fenwicka, aby znaleźć symbol
        int symbol = 0;
        int min_s = 0;
        int max_s = NUM_SYMBOLS - 1;

        while (min_s <= max_s) {
            int mid = min_s + (max_s - min_s) / 2;
            uint32_t mid_high = query_tree(mid);
            if (mid_high <= target_count) {
                // Ta wartość jest w lub przed `mid`, spróbuj wyżej
                symbol = mid;
                min_s = mid + 1;
            } else {
                max_s = mid - 1;
            }
        }

        // Musimy znaleźć symbol, którego zakres [low, high) zawiera target_count
        // Binary search znajduje ostatni symbol, którego high <= target_count.
        // Prawidłowy symbol to ten, dla którego target_count < high
        while (query_tree(symbol) <= target_count) {
            symbol++;
        }

        get_range(symbol, low, high);
        return symbol;
    }
};

class ArithmeticEncoder {
    BitWriter& writer;
    AdaptiveModel model;
    int_type low;
    int_type high;
    int pending_bits;

    // Propaguje bity (E1, E2)
    void output_bit_plus_pending(int bit) {
        writer.write(bit);
        for (int i = 0; i < pending_bits; ++i) {
            writer.write(!bit);
        }
        pending_bits = 0;
    }

    // Skalowanie E1, E2, E3
    void scale() {
        while (true) {
            // Skalowanie E1: górna połowa bitów taka sama (oba < 0.5)
            if (high < HALF) {
                output_bit_plus_pending(0);
                low = 2 * low;
                high = 2 * high + 1;
            }
            // Skalowanie E2: dolna połowa bitów taka sama (oba >= 0.5)
            else if (low >= HALF) {
                output_bit_plus_pending(1);
                low = 2 * (low - HALF);
                high = 2 * (high - HALF) + 1;
            }
            // Skalowanie E3: niedomiar (underflow), zakres zawiera 0.5
            else if (low >= FIRST_QUARTER && high < THIRD_QUARTER) {
                pending_bits++;
                low = 2 * (low - FIRST_QUARTER);
                high = 2 * (high - FIRST_QUARTER) + 1;
            }
            // Koniec skalowania
            else {
                break;
            }
        }
    }

public:
    long double total_information = 0.0;
    uint64_t total_symbols = 0;

    explicit ArithmeticEncoder(BitWriter& bw)
        : writer(bw), low(0), high(TOP_VALUE), pending_bits(0) {}

    void encode(int symbol) {
        // 1. Pobierz zakres prawdopodobieństwa dla symbolu
        uint32_t sym_low, sym_high, total;
        total = model.get_total();
        model.get_range(symbol, sym_low, sym_high);

        // Oblicz entropię *przed* aktualizacją modelu
        long double p = static_cast<long double>(sym_high - sym_low) / total;
        total_information += -log2l(p);
        total_symbols++;

        // 2. Zawęź główny zakres [low, high]
        const int_type range = high - low + 1;
        high = low + (range * sym_high) / total - 1;
        low = low + (range * sym_low) / total;

        // 3. Wykonaj skalowanie E1/E2/E3
        scale();

        // 4. Zaktualizuj model adaptacyjny
        model.update(symbol);
    }

    void flush() {
        // Zapisz ostatnie bity, aby zakończyć kodowanie
        pending_bits++;
        if (low < FIRST_QUARTER) {
            output_bit_plus_pending(0);
        } else {
            output_bit_plus_pending(1);
        }
        writer.flush(); // Zapisz resztę z bufora bitowego
    }
};

// === Dekoder Arytmetyczny ===
class ArithmeticDecoder {
    BitReader& reader;
    AdaptiveModel model;
    int_type low;
    int_type high;
    int_type value; // Aktualna wartość odczytana ze strumienia

    // Skalowanie E1, E2, E3 (dla dekodera)
    void scale() {
        while (true) {
            if (high < HALF) {
                // E1
                low = 2 * low;
                high = 2 * high + 1;
                value = 2 * value + reader.read();
            } else if (low >= HALF) {
                // E2
                low = 2 * (low - HALF);
                high = 2 * (high - HALF) + 1;
                value = 2 * (value - HALF) + reader.read();
            } else if (low >= FIRST_QUARTER && high < THIRD_QUARTER) {
                // E3
                low = 2 * (low - FIRST_QUARTER);
                high = 2 * (high - FIRST_QUARTER) + 1;
                value = 2 * (value - FIRST_QUARTER) + reader.read();
            } else {
                break;
            }
        }
    }

public:
    explicit ArithmeticDecoder(BitReader& br)
        : reader(br), low(0), high(TOP_VALUE), value(0) {
        // Zainicjuj 'value' pierwszymi bitami ze strumienia
        for (int i = 0; i < PRECISION_BITS; ++i) {
            value = (value << 1) | reader.read();
        }
    }

    int decode() {
        // 1. Znajdź symbol na podstawie aktualnej wartości 'value'
        const int_type range = high - low + 1;
        const uint32_t total = model.get_total();
        // Przeskaluj 'value' do zakresu licznika modelu
        const uint32_t target_count = static_cast<uint32_t>(((value - low + 1) * total - 1) / range);

        uint32_t sym_low, sym_high;
        int symbol = model.get_symbol(target_count, sym_low, sym_high);

        // 2. Jeśli EOF, zakończ
        if (symbol == EOF_SYMBOL) {
            return EOF_SYMBOL;
        }

        // 3. Zawęź zakres (identycznie jak w koderze)
        high = low + (range * sym_high) / total - 1;
        low = low + (range * sym_low) / total;

        // 4. Wykonaj skalowanie
        scale();

        // 5. Zaktualizuj model (identycznie jak w koderze)
        model.update(symbol);

        return symbol;
    }
};


// === Funkcje pomocnicze ===

uint64_t get_file_size(const std::string& filename) {
    std::ifstream file(filename, std::ios::binary | std::ios::ate);
    if (!file) return 0;
    return static_cast<uint64_t>(file.tellg());
}

void encode_file(const std::string& input_filename, const std::string& output_filename) {
    std::ifstream ifs(input_filename, std::ios::binary);
    if (!ifs) throw std::runtime_error("Nie można otworzyć pliku wejściowego: " + input_filename);

    std::ofstream ofs(output_filename, std::ios::binary);
    if (!ofs) throw std::runtime_error("Nie można otworzyć pliku wyjściowego: " + output_filename);

    uint64_t input_file_size = get_file_size(input_filename);
    if (input_file_size == 0 && !ifs.peek()) {
        std::cout << "Plik wejściowy jest pusty. Tworzenie pustego pliku wyjściowego." << std::endl;
        return; // Obsługa pustego pliku
    }

    BitWriter writer(ofs);
    ArithmeticEncoder encoder(writer);

    std::cout << "Kodowanie pliku: " << input_filename << std::endl;

    int byte;
    while ((byte = ifs.get()) != EOF) {
        encoder.encode(static_cast<uint8_t>(byte));
    }
    // Zakoduj symbol końca pliku
    encoder.encode(EOF_SYMBOL);

    // Zakończ strumień bitów
    encoder.flush();

    // Pobierz statystyki
    uint64_t output_file_size = writer.get_total_bytes();
    uint64_t total_bits = writer.get_total_bits();
    uint64_t total_symbols = encoder.total_symbols; // (liczba bajtów + 1 za EOF)
    long double entropy = encoder.total_information / total_symbols;
    long double avg_length = static_cast<long double>(total_bits) / total_symbols;
    long double ratio = static_cast<long double>(output_file_size) / input_file_size;

    std::cout << std::fixed << std::setprecision(6);
    std::cout << "--- Statystyki Kodowania ---" << std::endl;
    std::cout << "Rozmiar wejściowy: " << input_file_size << " bajtów" << std::endl;
    std::cout << "Rozmiar wyjściowy: " << output_file_size << " bajtów" << std::endl;
    std::cout << "Entropia modelu:   " << entropy << " bitów/symbol" << std::endl;
    std::cout << "Śr. dł. kodowania: " << avg_length << " bitów/symbol" << std::endl;
    std::cout << "Stopień kompresji: " << ratio << " (" << ratio * 100.0 << "%)" << std::endl;
}

void decode_file(const std::string& input_filename, const std::string& output_filename) {
    std::ifstream ifs(input_filename, std::ios::binary);
    if (!ifs) throw std::runtime_error("Nie można otworzyć pliku wejściowego: " + input_filename);

    if (get_file_size(input_filename) == 0) {
        std::cout << "Plik wejściowy jest pusty. Tworzenie pustego pliku wyjściowego." << std::endl;
        std::ofstream ofs(output_filename, std::ios::binary); // Utwórz pusty plik
        return;
    }

    std::ofstream ofs(output_filename, std::ios::binary);
    if (!ofs) throw std::runtime_error("Nie można otworzyć pliku wyjściowego: " + output_filename);

    BitReader reader(ifs);
    ArithmeticDecoder decoder(reader);

    std::cout << "Dekodowanie pliku: " << input_filename << std::endl;

    while (true) {
        int symbol = decoder.decode();
        if (symbol == EOF_SYMBOL) {
            break; // Zakończono dekodowanie
        }
        ofs.put(static_cast<char>(symbol));
    }

    std::cout << "Dekodowanie zakończone." << std::endl;
}

}

int main(int argc, char* argv[]) {
    if (argc != 4) {
        std::cerr << "Użycie: " << argv[0] << " <-c | -d> <plik_wejsciowy> <plik_wyjsciowy>" << std::endl;
        std::cerr << "  -c : kompresuj (koduj)" << std::endl;
        std::cerr << "  -d : dekompresuj (dekoduj)" << std::endl;
        return 1;
    }

    std::string mode = argv[1];
    std::string input_file = argv[2];
    std::string output_file = argv[3];

    try {
        if (mode == "-c") {
            encode_file(input_file, output_file);
        } else if (mode == "-d") {
            decode_file(input_file, output_file);
        } else {
            std::cerr << "Nieznany tryb: " << mode << std::endl;
            return 1;
        }
    } catch (const std::exception& e) {
        std::cerr << "Wystąpił błąd: " << e.what() << std::endl;
        return 1;
    }

    return 0;
}