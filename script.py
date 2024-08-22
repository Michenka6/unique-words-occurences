from collections import Counter
import string

def count_unique_words(file_path):
    # Open the file in read mode
    with open(file_path, 'r') as file:
        # Read the contents of the file
        text = file.read()
        
        # Convert text to lowercase to make the counting case-insensitive
        text = text.lower()
        
        # Remove punctuation from the text
        text = text.translate(str.maketrans('', '', string.punctuation))
        
        # Split the text into words
        words = text.split()
        
        # Use Counter to count the occurrences of each word
        word_counts = Counter(words)
        
    return word_counts

# Example usage:
file_path = 'text-files/sherlock-holms.txt'  # Replace with the path to your file
word_counts = count_unique_words(file_path)

# Print the unique words and their counts
for word, count in word_counts.items():
    print(f"{word}: {count}")
