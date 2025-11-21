#include <iostream>
#include <fstream>
#include <string>
#include <vector>
#include <map>
#include <cmath>
#include <filesystem>
#include <iomanip>

#define DEBUG 0

// Helper to print vector of uchars
void print_vec(const std::vector<unsigned char>& v) {
    for(unsigned char c : v) {
        if (isprint(c)) {
            std::cerr << (char)c;
        } else {
            std::cerr << ".";
        }
    }
}

// --- Bitwise I/O ---
class BitWriter {
public:
    BitWriter(std::ofstream& stream) : stream_(stream), buffer_(0), bit_count_(0) {}

    void write(uint32_t value, uint8_t num_bits) {
        buffer_ |= (uint64_t)value << bit_count_;
        bit_count_ += num_bits;
        while (bit_count_ >= 8) {
            stream_.put(buffer_ & 0xFF);
            buffer_ >>= 8;
            bit_count_ -= 8;
        }
    }

    void flush() {
        if (bit_count_ > 0) {
            stream_.put(buffer_ & 0xFF);
        }
    }

private:
    std::ofstream& stream_;
    uint64_t buffer_;
    uint8_t bit_count_;
};

class BitReader {
public:
    BitReader(std::ifstream& stream) : stream_(stream), buffer_(0), bit_count_(0) {}

    bool read(uint32_t& value, uint8_t num_bits) {
        value = 0;
        while (bit_count_ < num_bits) {
            int read_char = stream_.get();
            if (read_char == EOF) {
                return false; // End of stream
            }
            buffer_ |= (uint64_t)(unsigned char)read_char << bit_count_;
            bit_count_ += 8;
        }

        value = buffer_ & ((1ULL << num_bits) - 1);
        buffer_ >>= num_bits;
        bit_count_ -= num_bits;
        return true;
    }

private:
    std::ifstream& stream_;
    uint64_t buffer_;
    uint8_t bit_count_;
};


// --- Entropy Calculation ---
double calculate_entropy(const std::vector<unsigned char>& data) {
    if (data.empty()) {
        return 0.0;
    }

    std::map<unsigned char, int> freqs;
    for (unsigned char byte : data) {
        freqs[byte]++;
    }

    double entropy = 0.0;
    double total_size = data.size();
    for (auto const& [key, val] : freqs) {
        double prob = val / total_size;
        entropy -= prob * std::log2(prob);
    }
    return entropy;
}

// --- LZW Core ---
void encode(const std::string& input_path, const std::string& output_path) {
    std::ifstream input_file(input_path, std::ios::binary);
    if (!input_file) {
        std::cerr << "Error: Cannot open input file: " << input_path << std::endl;
        return;
    }
    
    // Read whole file
    input_file.seekg(0, std::ios::end);
    std::streamsize size = input_file.tellg();
    input_file.seekg(0, std::ios::beg);
    std::vector<unsigned char> input_data(size);
    input_file.read(reinterpret_cast<char*>(input_data.data()), size);
    input_file.close();

    if (input_data.empty()) {
        std::ofstream output_file(output_path, std::ios::binary); // Create empty file
        std::cout << "Input file is empty. Output file is created." << std::endl;
        return;
    }

    uint32_t dict_size = 256;
    std::map<std::vector<unsigned char>, uint32_t> dictionary;
    for (int i = 0; i < 256; ++i) {
        dictionary[{ (unsigned char)i }] = i;
    }
    
    uint8_t num_bits = 9;
    uint32_t max_dict_size = 1 << num_bits;

    std::ofstream output_file(output_path, std::ios::binary);
    if (!output_file) {
        std::cerr << "Error: Cannot create output file: " << output_path << std::endl;
        return;
    }
    BitWriter writer(output_file);

    std::vector<unsigned char> w;
    for (unsigned char c : input_data) {
        std::vector<unsigned char> wc = w;
        wc.push_back(c);
        if (dictionary.count(wc)) {
            w = wc;
        } else {
            uint32_t code_to_write = dictionary[w];
            writer.write(code_to_write, num_bits);
            if (DEBUG) {
                std::cerr << "[ENC] Writing code: " << code_to_write << " (" << (int)num_bits << " bits) for string: '";
                print_vec(w);
                std::cerr << "'. Dict size: " << dict_size << std::endl;
            }

            if (dict_size < (1 << 16)) { // Safety limit
                dictionary[wc] = dict_size++;
                if (dict_size == max_dict_size && num_bits < 16) {
                    num_bits++;
                    max_dict_size = 1 << num_bits;
                     if (DEBUG) std::cerr << "[ENC] ***** INCREASING BITS TO " << (int)num_bits << " *****" << std::endl;
                }
            }
            w = {c};
        }
    }

    if (!w.empty()) {
        uint32_t code_to_write = dictionary[w];
        writer.write(code_to_write, num_bits);
         if (DEBUG) {
            std::cerr << "[ENC] Writing final code: " << code_to_write << " (" << (int)num_bits << " bits) for string: '";
            print_vec(w);
            std::cerr << "'. Dict size: " << dict_size << std::endl;
        }
    }
    writer.flush();
    output_file.close();

    // Statistics
    auto input_size = std::filesystem::file_size(input_path);
    auto output_size = std::filesystem::file_size(output_path);
    double compression_ratio = (output_size > 0 && input_size > 0) ? (double)output_size / input_size * 100.0 : 0.0;
    
    // Read output file for entropy calculation
    std::ifstream out_file_read(output_path, std::ios::binary);
    out_file_read.seekg(0, std::ios::end);
    std::streamsize out_size = out_file_read.tellg();
    out_file_read.seekg(0, std::ios::beg);
    std::vector<unsigned char> output_data(out_size);
    out_file_read.read(reinterpret_cast<char*>(output_data.data()), out_size);
    out_file_read.close();

    std::cout << "Input file size: " << input_size << " bytes" << std::endl;
    std::cout << "Output file size: " << output_size << " bytes" << std::endl;
    std::cout << "Compression ratio: " << std::fixed << std::setprecision(2) << compression_ratio << "%" << std::endl;
    std::cout << "Input entropy: " << std::fixed << std::setprecision(4) << calculate_entropy(input_data) << " bits/byte" << std::endl;
    std::cout << "Output entropy: " << std::fixed << std::setprecision(4) << calculate_entropy(output_data) << " bits/byte" << std::endl;
}

void decode(const std::string& input_path, const std::string& output_path) {
    std::ifstream input_file(input_path, std::ios::binary);
    if (!input_file) {
        std::cerr << "Error: Cannot open input file: " << input_path << std::endl;
        return;
    }

    if (std::filesystem::file_size(input_path) == 0) {
        std::ofstream(output_path, std::ios::binary);
        std::cout << "Input file is empty. Output file is created." << std::endl;
        return;
    }
    
    BitReader reader(input_file);
    std::ofstream output_file(output_path, std::ios::binary);

    uint32_t dict_size = 256;
    std::map<uint32_t, std::vector<unsigned char>> dictionary;
    for (int i = 0; i < 256; ++i) {
        dictionary[i] = { (unsigned char)i };
    }

    uint8_t num_bits = 9;
    uint32_t max_dict_size = 1 << num_bits;

    uint32_t code;
    if (!reader.read(code, num_bits)) {
        return; // Empty file
    }
     if (DEBUG) {
        std::cerr << "[DEC] Read initial code: " << code << " (" << (int)num_bits << " bits). Dict size: " << dict_size << std::endl;
    }


    std::vector<unsigned char> w = dictionary[code];
    output_file.write(reinterpret_cast<const char*>(w.data()), w.size());

    while (reader.read(code, num_bits)) {
        if (DEBUG) {
            std::cerr << "[DEC] Read code: " << code << " (" << (int)num_bits << " bits). Dict size: " << dict_size << std::endl;
        }

        std::vector<unsigned char> entry;
        if (dictionary.count(code)) {
            entry = dictionary[code];
        } else if (code == dict_size) {
            entry = w;
            entry.push_back(w[0]);
             if (DEBUG) std::cerr << "[DEC] KWKWK case triggered for code " << code << std::endl;
        } else {
            std::cerr << "Bad compressed code: " << code << std::endl;
            return;
        }

        output_file.write(reinterpret_cast<const char*>(entry.data()), entry.size());

        if (dict_size < (1 << 16)) {
            std::vector<unsigned char> new_entry = w;
            new_entry.push_back(entry[0]);
            dictionary[dict_size++] = new_entry;
        }
        w = entry;

        if (dict_size == max_dict_size && num_bits < 16) {
            num_bits++;
            max_dict_size = 1 << num_bits;
            if (DEBUG) std::cerr << "[DEC] ***** INCREASING BITS TO " << (int)num_bits << " *****" << std::endl;
        }
    }
}


int main(int argc, char* argv[]) {
    if (argc != 4) {
        std::cerr << "Usage: " << argv[0] << " <encode|decode> <input_file> <output_file>" << std::endl;
        return 1;
    }

    std::string command = argv[1];
    std::string input_file = argv[2];
    std::string output_file = argv[3];

    if (command == "encode") {
        encode(input_file, output_file);
    } else if (command == "decode") {
        decode(input_file, output_file);
    } else {
        std::cerr << "Unknown command: '" << command << "'" << std::endl;
        std::cerr << "Usage: " << argv[0] << " <encode|decode> <input_file> <output_file>" << std::endl;
        return 1;
    }

    return 0;
}