
import sys
import math
import os

def calculate_entropy(data):
    """Calculates the entropy of a given byte stream."""
    if not data:
        return 0
    
    freq = {}
    for byte in data:
        freq[byte] = freq.get(byte, 0) + 1
        
    entropy = 0.0
    total_bytes = len(data)
    for byte in freq:
        probability = freq[byte] / total_bytes
        entropy -= probability * math.log2(probability)
        
    return entropy

class BitWriter:
    def __init__(self, file):
        self.file = file
        self.buffer = 0
        self.bit_count = 0

    def write(self, value, num_bits):
        self.buffer |= (value << self.bit_count)
        self.bit_count += num_bits
        while self.bit_count >= 8:
            byte_to_write = self.buffer & 0xFF
            self.file.write(bytes([byte_to_write]))
            self.buffer >>= 8
            self.bit_count -= 8
    
    def flush(self):
        if self.bit_count > 0:
            self.file.write(bytes([self.buffer]))

class BitReader:
    def __init__(self, file):
        self.file = file
        self.buffer = 0
        self.bit_count = 0

    def read(self, num_bits):
        while self.bit_count < num_bits:
            byte_read = self.file.read(1)
            if not byte_read:
                return None # End of stream
            self.buffer |= (byte_read[0] << self.bit_count)
            self.bit_count += 8
        
        value = self.buffer & ((1 << num_bits) - 1)
        self.buffer >>= num_bits
        self.bit_count -= num_bits
        return value

def encode(input_file, output_file):
    """Encodes a file using LZW algorithm with dynamic bit width."""
    try:
        with open(input_file, 'rb') as f_in:
            input_data = f_in.read()
    except FileNotFoundError:
        print(f"Error: Input file '{input_file}' not found.")
        return

    input_size = len(input_data)
    if input_size == 0:
        with open(output_file, 'wb') as f_out:
            pass # Create an empty file
        print("Input file is empty. Output file is created.")
        return

    # Initialize dictionary
    dict_size = 256
    dictionary = {bytes([i]): i for i in range(256)}
    
    num_bits = 9
    max_dict_size = 1 << num_bits

    with open(output_file, 'wb') as f_out:
        writer = BitWriter(f_out)
        
        w = b""
        for byte in input_data:
            c = bytes([byte])
            wc = w + c
            if wc in dictionary:
                w = wc
            else:
                writer.write(dictionary[w], num_bits)
                if dict_size < (1 << 16): # Limit dictionary size
                    dictionary[wc] = dict_size
                    dict_size += 1
                    if dict_size > max_dict_size:
                        num_bits += 1
                        if num_bits <= 16:
                             max_dict_size = 1 << num_bits
                w = c
        
        if w:
            writer.write(dictionary[w], num_bits)
            
        writer.flush()

    output_size = os.path.getsize(output_file)
    
    # Calculate statistics
    input_entropy = calculate_entropy(input_data)
    
    with open(output_file, 'rb') as f_out:
        output_data = f_out.read()
    output_entropy = calculate_entropy(output_data)

    compression_ratio = (output_size / input_size) * 100 if input_size > 0 else 0

    print(f"Input file size: {input_size} bytes")
    print(f"Output file size: {output_size} bytes")
    print(f"Compression ratio: {compression_ratio:.2f}%")
    print(f"Input entropy: {input_entropy:.4f} bits/byte")
    print(f"Output entropy: {output_entropy:.4f} bits/byte")


def decode(input_file, output_file):
    """Decodes a file using LZW algorithm with dynamic bit width."""
    try:
        with open(input_file, 'rb') as f_in:
            if os.path.getsize(input_file) == 0:
                with open(output_file, 'wb') as f_out:
                    pass # Create empty file
                print("Input file is empty. Output file is created.")
                return
            reader = BitReader(f_in)
    except FileNotFoundError:
        print(f"Error: Input file '{input_file}' not found.")
        return

    # Initialize dictionary
    dict_size = 256
    dictionary = {i: bytes([i]) for i in range(256)}

    num_bits = 9
    max_dict_size = 1 << num_bits

    with open(output_file, 'wb') as f_out:
        code = reader.read(num_bits)
        if code is None:
            return
            
        w = dictionary[code]
        f_out.write(w)
        
        while True:
            code = reader.read(num_bits)
            if code is None:
                break
            
            if dict_size >= max_dict_size and num_bits < 16:
                num_bits += 1
                max_dict_size = 1 << num_bits
                
            entry = b""
            if code in dictionary:
                entry = dictionary[code]
            elif code == dict_size:
                entry = w + w[:1]
            else:
                raise ValueError(f"Bad compressed code: {code}")

            f_out.write(entry)

            if dict_size < (1 << 16) -1:
                dictionary[dict_size] = w + entry[:1]
                dict_size += 1
            
            w = entry


def main():
    """Main function to handle command-line arguments."""
    if len(sys.argv) != 4:
        print("Usage: python lzw.py <encode|decode> <input_file> <output_file>")
        sys.exit(1)

    command = sys.argv[1]
    input_file = sys.argv[2]
    output_file = sys.argv[3]

    if command.lower() == 'encode':
        encode(input_file, output_file)
    elif command.lower() == 'decode':
        decode(input_file, output_file)
    else:
        print(f"Unknown command: '{command}'")
        print("Usage: python lzw.py <encode|decode> <input_file> <output_file>")
        sys.exit(1)

if __name__ == "__main__":
    main()
