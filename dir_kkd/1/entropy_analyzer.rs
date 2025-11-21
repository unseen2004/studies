use std::env;
use std::fs::File;
use std::io::Read;
use std::collections::HashMap;

fn main() {
    let args: Vec<String> = env::args().collect();
    
    if args.len() != 2 {
        eprintln!("Usage: {} <file>", args[0]);
        std::process::exit(1);
    }

    let filepath = &args[1];
    let data = read_file(filepath).expect("Failed to read file");
    
    if data.is_empty() {
        eprintln!("File is empty");
        std::process::exit(1);
    }

    let (symbol_freq, transition_freq) = collect_frequencies(&data);
    let total_bytes = data.len() as f64;
    
    let symbol_probs = normalize_frequencies(&symbol_freq, total_bytes);
    let transition_probs = normalize_transitions(&transition_freq, &symbol_freq);
    
    let h_y = calculate_entropy(&symbol_probs);
    let h_y_given_x = calculate_conditional_entropy(&symbol_probs, &transition_probs);
    let difference = h_y - h_y_given_x;
    
    print_results(&symbol_freq, &symbol_probs, h_y, h_y_given_x, difference, total_bytes as usize);
}

fn read_file(filepath: &str) -> std::io::Result<Vec<u8>> {
    let mut file = File::open(filepath)?;
    let mut buffer = Vec::new();
    file.read_to_end(&mut buffer)?;
    Ok(buffer)
}

fn collect_frequencies(data: &[u8]) -> (HashMap<u8, u32>, HashMap<u8, HashMap<u8, u32>>) {
    let mut symbol_freq = HashMap::new();
    let mut transition_freq: HashMap<u8, HashMap<u8, u32>> = HashMap::new();
    
    let mut prev = 0u8;
    
    for &byte in data {
        *symbol_freq.entry(byte).or_insert(0) += 1;
        
        transition_freq.entry(prev).or_insert_with(HashMap::new);
        let inner = transition_freq.get_mut(&prev).unwrap();
        *inner.entry(byte).or_insert(0) += 1;
        
        prev = byte;
    }
    
    (symbol_freq, transition_freq)
}

fn normalize_frequencies(freq: &HashMap<u8, u32>, total: f64) -> HashMap<u8, f64> {
    freq.iter()
        .map(|(k, v)| (*k, *v as f64 / total))
        .collect()
}

fn normalize_transitions(transitions: &HashMap<u8, HashMap<u8, u32>>, symbol_freq: &HashMap<u8, u32>) -> HashMap<u8, HashMap<u8, f64>> {
    transitions.iter()
        .map(|(prev, next_map)| {
            let prev_count = *symbol_freq.get(prev).unwrap_or(&1) as f64;
            let normalized = next_map.iter()
                .map(|(next, count)| (*next, *count as f64 / prev_count))
                .collect();
            (*prev, normalized)
        })
        .collect()
}

fn calculate_entropy(probs: &HashMap<u8, f64>) -> f64 {
    probs.values()
        .filter(|&&p| p > 0.0)
        .map(|&p| -p * p.log2())
        .sum()
}

fn calculate_conditional_entropy(symbol_probs: &HashMap<u8, f64>, transition_probs: &HashMap<u8, HashMap<u8, f64>>) -> f64 {
    let mut h_y_given_x = 0.0;
    
    for (&x, &p_x) in symbol_probs {
        if let Some(conditional_probs) = transition_probs.get(&x) {
            let h_y_given_x_val: f64 = conditional_probs.values()
                .filter(|&&p| p > 0.0)
                .map(|&p| -p * p.log2())
                .sum();
            h_y_given_x += p_x * h_y_given_x_val;
        }
    }
    
    h_y_given_x
}

fn print_results(symbol_freq: &HashMap<u8, u32>, symbol_probs: &HashMap<u8, f64>, h_y: f64, h_y_given_x: f64, difference: f64, total_bytes: usize) {
    println!("=== ENTROPY ANALYSIS ===\n");
    println!("File size: {} bytes", total_bytes);
    println!("Unique symbols: {}\n", symbol_freq.len());
    
    println!("SYMBOL STATISTICS:");
    println!("{:<6} {:<12} {:<12}", "Byte", "Count", "Probability");
    println!("{}", "-".repeat(30));
    
    let mut sorted: Vec<_> = symbol_freq.iter().collect();
    sorted.sort_by_key(|a| std::cmp::Reverse(*a.1));
    
    for (byte, count) in sorted.iter().take(32) {
        if let Some(&prob) = symbol_probs.get(byte) {
            let char_repr = if **byte >= 32 && **byte < 127 {
                format!("'{}'", **byte as char)
            } else {
                format!("0x{:02x}", byte)
            };
            println!("{:<6} {:<12} {:<12.6}", char_repr, count, prob);
        }
    }
    
    println!("\n=== ENTROPY MEASURES ===");
    println!("H(Y) - Total Entropy:              {:.6} bits", h_y);
    println!("H(Y|X) - Conditional Entropy:      {:.6} bits", h_y_given_x);
    println!("H(Y) - H(Y|X) - Information Gain:  {:.6} bits", difference);
}
