# NLP model

## Overall process

* input strings and receive analysis output

## I/O protocols

### Input

``` python
message = {"input": ["<input-1>", "<input-2>"]}

# example
message = {"input": "Hello again worlds"}
```

### Output

``` python
result = {"class": 
            [{'labels': <label-for-input-1>, 'scores': <scores-for-input-1>}]
          "word_count":            
            [{'<word-1-in-input-1>': <word-count>,
              '<word-2-in-input-1>': <word-count>, ...}],
              ...
          "sentence_count": [<sentence-count-for-input-1>]

# example
result = {
{
'class': 
  [{'labels': 'neutral', 'scores': 0.9994369}]
'word_count': 
  [{'Hello': 1, 'again': 1, 'world': 1}]
'sentence_count': [1]
}

```

## Pretrained Models

* Not needed
