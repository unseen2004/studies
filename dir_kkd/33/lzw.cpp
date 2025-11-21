#include <iostream>
#include <fstream>
#include <vector>
#include <unordered_map>
#include <string>
#include <cmath>
#include <cstring>
#include <algorithm>

using namespace std;

// Klasa do pisania bitów do pliku
class BitWriter {
private:
    ofstream& out;
    unsigned char buffer;
    int bitCount;

public:
    BitWriter(ofstream& output) : out(output), buffer(0), bitCount(0) {}

    void writeBits(int value, int numBits) {
        for (int i = numBits - 1; i >= 0; i--) {
            buffer = (buffer << 1) | ((value >> i) & 1);
            bitCount++;
            if (bitCount == 8) {
                out.put(buffer);
                buffer = 0;
                bitCount = 0;
            }
        }
    }

    void flush() {
        if (bitCount > 0) {
            buffer <<= (8 - bitCount);
            out.put(buffer);
        }
    }

    long long getBitsWritten(long long bytesWritten) {
        return bytesWritten * 8 + bitCount;
    }
};

// Klasa do czytania bitów z pliku
class BitReader {
private:
    ifstream& in;
    unsigned char buffer;
    int bitCount;

public:
    BitReader(ifstream& input) : in(input), buffer(0), bitCount(0) {}

    int readBits(int numBits) {
        int result = 0;
        for (int i = 0; i < numBits; i++) {
            if (bitCount == 0) {
                if (!in.get(reinterpret_cast<char&>(buffer))) {
                    return -1;
                }
                bitCount = 8;
            }
            result = (result << 1) | ((buffer >> 7) & 1);
            buffer <<= 1;
            bitCount--;
        }
        return result;
    }

    bool hasMore() {
        return in.peek() != EOF || bitCount > 0;
    }
};

// Obliczanie entropii
double calculateEntropy(const vector<unsigned char>& data) {
    if (data.empty()) return 0.0;

    unordered_map<unsigned char, int> freq;
    for (unsigned char c : data) {
        freq[c]++;
    }

    double entropy = 0.0;
    int total = data.size();
    for (const auto& pair : freq) {
        double p = static_cast<double>(pair.second) / total;
        entropy -= p * log2(p);
    }
    return entropy;
}

// Obliczanie entropii z kodów LZW
double calculateCodeEntropy(const vector<int>& codes) {
    if (codes.empty()) return 0.0;

    unordered_map<int, int> freq;
    for (int code : codes) {
        freq[code]++;
    }

    double entropy = 0.0;
    int total = codes.size();
    for (const auto& pair : freq) {
        double p = static_cast<double>(pair.second) / total;
        entropy -= p * log2(p);
    }
    return entropy;
}

void encode(const string& inputFile, const string& outputFile) {
    ifstream input(inputFile, ios::binary);
    if (!input) {
        cerr << "Nie można otworzyć pliku wejściowego: " << inputFile << endl;
        return;
    }

    // Wczytaj cały plik
    vector<unsigned char> data((istreambuf_iterator<char>(input)),
                                istreambuf_iterator<char>());
    input.close();

    if (data.empty()) {
        cerr << "Plik wejściowy jest pusty" << endl;
        return;
    }

    // Inicjalizacja słownika (0-255 dla pojedynczych bajtów)
    unordered_map<string, int> dictionary;
    for (int i = 0; i < 256; i++) {
        dictionary[string(1, static_cast<char>(i))] = i;
    }

    int dictSize = 256;
    string current;
    vector<int> codes;
    int currentBitWidth = 9;

    for (unsigned char c : data) {
        string next = current + string(1, c);
        if (dictionary.find(next) != dictionary.end()) {
            current = next;
        } else {
            codes.push_back(dictionary[current]);

            // Dodaj nowy wpis do słownika
            if (dictSize < (1 << 20)) { // Limit słownika na 2^20
                dictionary[next] = dictSize++;

                // Sprawdź czy potrzebujemy więcej bitów
                if (dictSize > (1 << currentBitWidth) && currentBitWidth < 20) {
                    currentBitWidth++;
                }
            }
            current = string(1, c);
        }
    }

    if (!current.empty()) {
        codes.push_back(dictionary[current]);
    }

    // Zapisz skompresowane dane
    ofstream output(outputFile, ios::binary);
    if (!output) {
        cerr << "Nie można utworzyć pliku wyjściowego: " << outputFile << endl;
        return;
    }

    BitWriter writer(output);
    currentBitWidth = 9;
    dictSize = 256;

    for (int code : codes) {
        writer.writeBits(code, currentBitWidth);
        dictSize++;

        if (dictSize > (1 << currentBitWidth) && currentBitWidth < 20) {
            currentBitWidth++;
        }
    }

    writer.flush();
    long long outputSize = output.tellp();
    output.close();

    // Statystyki
    long long inputSize = data.size();
    double compressionRatio = 100.0 * (1.0 - static_cast<double>(outputSize) / inputSize);
    double inputEntropy = calculateEntropy(data);
    double outputEntropy = calculateCodeEntropy(codes);

    cout << "=== Statystyki kodowania ===" << endl;
    cout << "Długość kodowanego pliku: " << inputSize << " bajtów" << endl;
    cout << "Długość uzyskanego kodu: " << outputSize << " bajtów" << endl;
    cout << "Stopień kompresji: " << fixed << compressionRatio << "%" << endl;
    cout << "Entropia kodowanego tekstu: " << fixed << inputEntropy << " bitów/symbol" << endl;
    cout << "Entropia uzyskanego kodu: " << fixed << outputEntropy << " bitów/symbol" << endl;
}

void decode(const string& inputFile, const string& outputFile) {
    ifstream input(inputFile, ios::binary);
    if (!input) {
        cerr << "Nie można otworzyć pliku wejściowego: " << inputFile << endl;
        return;
    }

    ofstream output(outputFile, ios::binary);
    if (!output) {
        cerr << "Nie można utworzyć pliku wyjściowego: " << outputFile << endl;
        return;
    }

    // Inicjalizacja słownika
    vector<string> dictionary;
    for (int i = 0; i < 256; i++) {
        dictionary.push_back(string(1, static_cast<char>(i)));
    }

    BitReader reader(input);
    int currentBitWidth = 9;
    int dictSize = 256;

    int prevCode = reader.readBits(currentBitWidth);
    if (prevCode == -1) {
        return;
    }

    string result = dictionary[prevCode];
    output.write(result.c_str(), result.size());
    dictSize++;

    if (dictSize > (1 << currentBitWidth) && currentBitWidth < 20) {
        currentBitWidth++;
    }

    while (reader.hasMore()) {
        int code = reader.readBits(currentBitWidth);
        if (code == -1) break;

        string entry;
        if (code < dictionary.size()) {
            entry = dictionary[code];
        } else if (code == dictionary.size()) {
            entry = result + result[0];
        } else {
            cerr << "Błąd dekodowania: nieprawidłowy kod " << code << endl;
            return;
        }

        output.write(entry.c_str(), entry.size());

        if (dictSize < (1 << 20)) {
            dictionary.push_back(result + entry[0]);
            dictSize++;

            if (dictSize > (1 << currentBitWidth) && currentBitWidth < 20) {
                currentBitWidth++;
            }
        }

        result = entry;
    }

    input.close();
    output.close();
}

int main(int argc, char* argv[]) {
    if (argc < 4) {
        cerr << "Użycie: " << argv[0] << " [encode|decode] <plik_wejściowy> <plik_wyjściowy>" << endl;
        return 1;
    }

    string mode = argv[1];
    string inputFile = argv[2];
    string outputFile = argv[3];

    if (mode == "encode") {
        encode(inputFile, outputFile);
    } else if (mode == "decode") {
        decode(inputFile, outputFile);
    } else {
        cerr << "Nieprawidłowy tryb. Użyj 'encode' lub 'decode'" << endl;
        return 1;
    }

    return 0;
}