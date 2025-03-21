# Natural Language Processing (NLP) Notes

## Introduction
Natural Language Processing (NLP) is a field focused on understanding and processing human language. NLP not only analyzes individual words but also understands the context in which they are used.

---

## Common NLP Tasks
NLP is used for various tasks, including:

- **Classifying whole sentences**: 
  - Sentiment analysis (e.g., determining if a review is positive or negative).
  - Spam detection (e.g., identifying if an email is spam).
  - Grammar checking (e.g., determining if a sentence is grammatically correct).
- **Classifying individual words in a sentence**: 
  - Identifying grammatical components (e.g., noun, verb, adjective).
  - Named entity recognition (e.g., extracting person, location, organization names).
- **Text generation**: 
  - Generating new sentences based on input text.
- **Extracting answers from text**.
- **Speech recognition** (e.g., transcribing spoken words into text).
- **Computer vision applications related to text processing**.

---

## Transformer Models
Transformer models are a powerful type of language model used to solve various NLP tasks. These models have been trained on vast amounts of raw text in a **self-supervised** manner, meaning that the training objectives are derived automatically from the input data without requiring human-labeled annotations.

### Example: Using a Transformer Model
```python
!pip install transformers

from transformers import pipeline

model = pipeline("sentiment-analysis")
res = model("I have been waiting for this course my whole life!")
print(res)
```

### Scaling Transformer Models
- Performance improvements are achieved by **increasing model size** (number of parameters) and **expanding the dataset** used for pretraining.

---

## Pretraining vs. Fine-Tuning
### **Pretraining**
- Training a model from scratch without prior knowledge.
- Requires **large datasets** and **long training times** (weeks).

### **Fine-Tuning**
- Training a **pretrained model** on a specific dataset.
- Requires **less data, time, and resources** than pretraining.

---

## Transformer Model Architecture
Transformer models consist of **attention layers** that enable the model to focus on important words while **ignoring less relevant words** in a sentence.

### **Components of a Transformer Model**
- **Encoder**: Processes the input and builds a representation of it.
- **Decoder**: Uses the encoder's representation along with additional inputs to generate a target sequence.

### **Types of Transformer Models**
1. **Encoder-Only Models**
   - Uses only the encoder component.
   - Attention layers can access **all words in a sentence**.
   - Best suited for:
     - Sentence classification
     - Named entity recognition (NER)
     - Extractive question answering

2. **Decoder-Only Models**
   - Uses only the decoder component.
   - Attention layers **can only access previous words** in a sequence.
   - Best suited for:
     - Text generation tasks

3. **Encoder-Decoder Models**
   - Uses **both** encoder and decoder components.
   - Encoder accesses all words in the input sentence.
   - Decoder accesses only previous words while generating new text.
   - Best suited for:
     - Summarization
     - Translation
     - Generative question answering

---

## Tokenization
### **What is a Tokenizer?**
A **tokenizer** is responsible for preprocessing text by splitting the input into **tokens** (words, subwords, or symbols) and mapping them to integers.

- **Example**:
  - Input: "Natural Language Processing"
  - Tokenized output: `[1002, 2045, 9876]` (IDs may vary depending on the tokenizer used)

---

This structured NLP notes document is now ready for use! 🚀
